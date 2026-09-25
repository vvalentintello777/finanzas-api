import '../../config/db.dart';
import '../../dominio/deuda.dart';
import '../../dominio/puertos/deuda_repositorio.dart';

class DeudaRepoMysql implements DeudaRepositorio {
  @override
  Future<void> crear(Deuda d) async {
    await Db.conn.execute(
      'INSERT INTO deudas '
      '(usuario_id, concepto, tipo, monto_total, monto_pagado, fecha_inicio, fecha_limite, interes, descripcion, saldada) '
      'VALUES (:u, :c, :t, :mt, 0, :fi, :fl, :i, :d, 0)',
      {
        'u': d.usuarioId,
        'c': d.concepto,
        't': d.tipo,
        'mt': d.montoTotal,
        'fi': d.fechaInicio.toIso8601String().substring(0, 10),
        'fl': d.fechaLimite?.toIso8601String().substring(0, 10),
        'i': d.interes,
        'd': d.descripcion,
      },
    );
  }

  @override
  Future<List<Deuda>> listarPorUsuario(int usuarioId) async {
    final rs = await Db.conn.execute(
      'SELECT * FROM deudas WHERE usuario_id = :u ORDER BY id DESC',
      {'u': usuarioId},
    );
    return rs.rows.map((r) {
      final row = r.assoc();
      return Deuda(
        id: int.parse(row['id'].toString()),
        usuarioId: int.parse(row['usuario_id'].toString()),
        concepto: row['concepto'].toString(),
        tipo: row['tipo'].toString(),
        montoTotal: double.parse(row['monto_total'].toString()),
        montoPagado: double.parse(row['monto_pagado'].toString()),
        fechaInicio: DateTime.parse(row['fecha_inicio'].toString()),
        fechaLimite: row['fecha_limite'] != null
            ? DateTime.parse(row['fecha_limite'].toString())
            : null,
        interes: row['interes'] != null
            ? double.parse(row['interes'].toString())
            : null,
        descripcion: row['descripcion']?.toString(),
        saldada: row['saldada'].toString() == '1',
      );
    }).toList();
  }

  @override
  Future<void> pagar(int deudaId, double monto) async {
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    await Db.conn.execute(
      'INSERT INTO pagos_deuda (deuda_id, monto, fecha) VALUES (:d, :m, :f)',
      {'d': deudaId, 'm': monto, 'f': hoy},
    );
    await Db.conn.execute(
      'UPDATE deudas SET monto_pagado = monto_pagado + :m WHERE id = :d',
      {'m': monto, 'd': deudaId},
    );
    await Db.conn.execute(
      'UPDATE deudas SET saldada = 1 '
      'WHERE id = :d AND monto_pagado >= monto_total',
      {'d': deudaId},
    );
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    await Db.conn.execute(
      'DELETE FROM deudas WHERE id = :i AND usuario_id = :u',
      {'i': id, 'u': usuarioId},
    );
  }
}
