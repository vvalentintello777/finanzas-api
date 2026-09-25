import '../../dominio/puertos/meta_repositorio.dart';

class AportarMeta {
  final MetaRepositorio repo;
  AportarMeta(this.repo);

  Future<void> ejecutar({
    required int metaId,
    required double monto,
  }) async {
    if (metaId <= 0) {
      throw ArgumentError('ID de meta inválido');
    }
    if (monto <= 0) {
      throw ArgumentError('El monto debe ser mayor a 0');
    }
    await repo.aportar(metaId, monto);
  }
}
