import '../../dominio/meta.dart';
import '../../dominio/puertos/meta_repositorio.dart';

class MetaRepoMemoria implements MetaRepositorio {
  final Map<int, Meta> _datos = {};
  int _proximoId = 1;

  @override
  Future<void> crear(Meta m) async {
    final nueva = Meta(
      id: _proximoId++,
      usuarioId: m.usuarioId,
      nombre: m.nombre,
      montoObjetivo: m.montoObjetivo,
      montoActual: m.montoActual,
      fechaLimite: m.fechaLimite,
      descripcion: m.descripcion,
      completada: m.completada,
    );
    _datos[nueva.id!] = nueva;
  }

  @override
  Future<List<Meta>> listarPorUsuario(int usuarioId) async {
    return _datos.values.where((m) => m.usuarioId == usuarioId).toList();
  }

  @override
  Future<void> aportar(int metaId, double monto) async {
    final m = _datos[metaId];
    if (m == null) return;
    final nuevoActual = m.montoActual + monto;
    final actualizada = Meta(
      id: m.id,
      usuarioId: m.usuarioId,
      nombre: m.nombre,
      montoObjetivo: m.montoObjetivo,
      montoActual: nuevoActual,
      fechaLimite: m.fechaLimite,
      descripcion: m.descripcion,
      completada: nuevoActual >= m.montoObjetivo,
    );
    _datos[metaId] = actualizada;
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    final m = _datos[id];
    if (m != null && m.usuarioId == usuarioId) {
      _datos.remove(id);
    }
  }
}
