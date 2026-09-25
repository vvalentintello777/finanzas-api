import '../../config/db.dart';
import '../../dominio/movimiento.dart';
import '../../dominio/puertos/movimiento_repositorio.dart';

class MovimientoRepoMysql implements MovimientoRepositorio {
  @override
  Future<void> crear(Movimiento m) async {
    await Db.conn.execute(
      'INSERT INTO movimientos '
      '(usuario_id, tipo, monto, categoria, descripcion, metodo_pago, referencia, fecha) '
      'VALUES (:u, :t, :m, :c, :d, :mp, :r, :f)',
      {
        'u': m.usuarioId,
        't': m.tipo,
        'm': m.monto,
        'c': m.categoria,
        'd': m.descripcion,
        'mp': m.metodoPago,
        'r': m.referencia,
        'f': m.fecha.toIso8601String().substring(0, 10),
      },
    );
  }

  @override
  Future<List<Movimiento>> listarPorUsuario(int usuarioId) async {
    final rs = await Db.conn.execute(
      'SELECT * FROM movimientos WHERE usuario_id = :u '
      'ORDER BY fecha DESC, id DESC',
      {'u': usuarioId},
    );
    return rs.rows.map((r) {
      final row = r.assoc();
      return Movimiento(
        id: int.parse(row['id'].toString()),
        usuarioId: int.parse(row['usuario_id'].toString()),
        tipo: row['tipo'].toString(),
        monto: double.parse(row['monto'].toString()),
        categoria: row['categoria'].toString(),
        descripcion: row['descripcion']?.toString(),
        metodoPago: row['metodo_pago'].toString(),
        referencia: row['referencia']?.toString(),
        fecha: DateTime.parse(row['fecha'].toString()),
      );
    }).toList();
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    await Db.conn.execute(
      'DELETE FROM movimientos WHERE id = :i AND usuario_id = :u',
      {'i': id, 'u': usuarioId},
    );
  }

  @override
  Future<List<String>> categorias(int usuarioId, String tipo) async {
    final rs = await Db.conn.execute(
      "SELECT DISTINCT nombre FROM ( "
      "  SELECT m.categoria AS nombre FROM movimientos m "
      "  LEFT JOIN categorias_ocultas co "
      "    ON co.usuario_id = m.usuario_id "
      "   AND co.tipo = m.tipo "
      "   AND co.categoria = m.categoria "
      "  WHERE m.usuario_id = :u AND m.tipo = :t AND co.id IS NULL "
      "  UNION "
      "  SELECT cp.categoria AS nombre FROM categorias_personalizadas cp "
      "  LEFT JOIN categorias_ocultas co2 "
      "    ON co2.usuario_id = cp.usuario_id "
      "   AND co2.tipo = cp.tipo "
      "   AND co2.categoria = cp.categoria "
      "  WHERE cp.usuario_id = :u AND cp.tipo = :t AND co2.id IS NULL "
      ") AS t ORDER BY nombre",
      {'u': usuarioId, 't': tipo},
    );
    return rs.rows
        .map((r) => r.assoc()['nombre'].toString())
        .toList();
  }

  @override
  Future<void> ocultarCategoria(
      int usuarioId, String tipo, String categoria) async {
    await Db.conn.execute(
      'INSERT IGNORE INTO categorias_ocultas (usuario_id, tipo, categoria) '
      'VALUES (:u, :t, :c)',
      {'u': usuarioId, 't': tipo, 'c': categoria},
    );
  }

  @override
  Future<List<String>> categoriasPersonalizadas(
      int usuarioId, String tipo) async {
    final rs = await Db.conn.execute(
      'SELECT categoria FROM categorias_personalizadas '
      'WHERE usuario_id = :u AND tipo = :t ORDER BY categoria',
      {'u': usuarioId, 't': tipo},
    );
    return rs.rows
        .map((r) => r.assoc()['categoria'].toString())
        .toList();
  }

  @override
  Future<void> agregarCategoriaPersonalizada(
      int usuarioId, String tipo, String categoria) async {
    await Db.conn.execute(
      'INSERT IGNORE INTO categorias_personalizadas '
      '(usuario_id, tipo, categoria) VALUES (:u, :t, :c)',
      {'u': usuarioId, 't': tipo, 'c': categoria},
    );
  }
}
