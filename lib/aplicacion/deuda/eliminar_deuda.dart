import '../../dominio/puertos/deuda_repositorio.dart';

class EliminarDeuda {
  final DeudaRepositorio repo;
  EliminarDeuda(this.repo);

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
