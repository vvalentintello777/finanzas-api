import '../../config/db.dart';
import '../../dominio/meta.dart';
import '../../dominio/puertos/meta_repositorio.dart';

class MetaRepoMysql implements MetaRepositorio {
  @override
  Future<void> crear(Meta m) async {
    await Db.conn.execute(
      'INSERT INTO metas '
      '(usuario_id, nombre, monto_objetivo, monto_actual, fecha_limite, descripcion, completada) '
      'VALUES (:u, :n, :mo, :ma, :fl, :d, 0)',
      {
        'u': m.usuarioId,
        'n': m.nombre,
        'mo': m.montoObjetivo,
        'ma': m.montoActual,
        'fl': m.fechaLimite?.toIso8601String().substring(0, 10),
        'd': m.descripcion,
      },
    );
  }

  @override
  Future<List<Meta>> listarPorUsuario(int usuarioId) async {
    final rs = await Db.conn.execute(
      'SELECT * FROM metas WHERE usuario_id = :u ORDER BY id DESC',
      {'u': usuarioId},
    );
    return rs.rows.map((r) {
      final row = r.assoc();
      return Meta(
        id: int.parse(row['id'].toString()),
        usuarioId: int.parse(row['usuario_id'].toString()),
        nombre: row['nombre'].toString(),
        montoObjetivo: double.parse(row['monto_objetivo'].toString()),
        montoActual: double.parse(row['monto_actual'].toString()),
        fechaLimite: row['fecha_limite'] != null
            ? DateTime.parse(row['fecha_limite'].toString())
            : null,
        descripcion: row['descripcion']?.toString(),
        completada: row['completada'].toString() == '1',
      );
    }).toList();
  }

  @override
  Future<void> aportar(int metaId, double monto) async {
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    await Db.conn.execute(
      'INSERT INTO aportes_meta (meta_id, monto, fecha) VALUES (:m, :mo, :f)',
      {'m': metaId, 'mo': monto, 'f': hoy},
    );
    await Db.conn.execute(
      'UPDATE metas SET monto_actual = monto_actual + :mo WHERE id = :m',
      {'mo': monto, 'm': metaId},
    );
    await Db.conn.execute(
      'UPDATE metas SET completada = 1 '
      'WHERE id = :m AND monto_actual >= monto_objetivo',
      {'m': metaId},
    );
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    await Db.conn.execute(
      'DELETE FROM metas WHERE id = :i AND usuario_id = :u',
      {'i': id, 'u': usuarioId},
    );
  }
}
