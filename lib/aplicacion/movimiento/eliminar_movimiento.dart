import '../../dominio/puertos/movimiento_repositorio.dart';

class EliminarMovimiento {
  final MovimientoRepositorio repo;
  EliminarMovimiento(this.repo);

  Future<void> ejecutar({
    required int id,
    required int usuarioId,
  }) async {
    if (id <= 0 || usuarioId <= 0) {
      throw ArgumentError('IDs inválidos');
    }
    await repo.eliminar(id, usuarioId);
  }
}
