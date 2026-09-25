import '../../dominio/puertos/deuda_repositorio.dart';

class PagarDeuda {
  final DeudaRepositorio repo;
  PagarDeuda(this.repo);

  Future<void> ejecutar({
    required int deudaId,
    required double monto,
  }) async {
    if (deudaId <= 0) {
      throw ArgumentError('ID de deuda inválido');
    }
    if (monto <= 0) {
      throw ArgumentError('El monto debe ser mayor a 0');
    }
    await repo.pagar(deudaId, monto);
  }
}
