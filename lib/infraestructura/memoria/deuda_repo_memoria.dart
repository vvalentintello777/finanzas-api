import '../../dominio/deuda.dart';
import '../../dominio/puertos/deuda_repositorio.dart';

class DeudaRepoMemoria implements DeudaRepositorio {
  final Map<int, Deuda> _datos = {};
  int _proximoId = 1;

  @override
  Future<void> crear(Deuda d) async {
    final nueva = Deuda(
      id: _proximoId++,
      usuarioId: d.usuarioId,
      concepto: d.concepto,
      tipo: d.tipo,
      montoTotal: d.montoTotal,
      montoPagado: d.montoPagado,
      fechaInicio: d.fechaInicio,
      fechaLimite: d.fechaLimite,
      interes: d.interes,
      descripcion: d.descripcion,
      saldada: d.saldada,
    );
    _datos[nueva.id!] = nueva;
  }

  @override
  Future<List<Deuda>> listarPorUsuario(int usuarioId) async {
    return _datos.values.where((d) => d.usuarioId == usuarioId).toList();
  }

  @override
  Future<void> pagar(int deudaId, double monto) async {
    final d = _datos[deudaId];
    if (d == null) return;
    final nuevoPagado = d.montoPagado + monto;
    final actualizada = Deuda(
      id: d.id,
      usuarioId: d.usuarioId,
      concepto: d.concepto,
      tipo: d.tipo,
      montoTotal: d.montoTotal,
      montoPagado: nuevoPagado,
      fechaInicio: d.fechaInicio,
      fechaLimite: d.fechaLimite,
      interes: d.interes,
      descripcion: d.descripcion,
      saldada: nuevoPagado >= d.montoTotal,
    );
    _datos[deudaId] = actualizada;
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    final d = _datos[id];
    if (d != null && d.usuarioId == usuarioId) {
      _datos.remove(id);
    }
  }
}
