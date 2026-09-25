import '../../dominio/puertos/meta_repositorio.dart';

class EliminarMeta {
  final MetaRepositorio repo;
  EliminarMeta(this.repo);

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
