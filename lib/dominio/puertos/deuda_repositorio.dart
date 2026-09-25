import '../deuda.dart';

/// Puerto para la persistencia de deudas.
abstract class DeudaRepositorio {
  Future<void> crear(Deuda deuda);
  Future<List<Deuda>> listarPorUsuario(int usuarioId);
  Future<void> pagar(int deudaId, double monto);
  Future<void> eliminar(int id, int usuarioId);
}
