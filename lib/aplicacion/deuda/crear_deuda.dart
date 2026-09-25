import '../../dominio/deuda.dart';
import '../../dominio/puertos/deuda_repositorio.dart';

class CrearDeuda {
  final DeudaRepositorio repo;
  CrearDeuda(this.repo);

  Future<void> ejecutar({
    required int usuarioId,
    required String concepto,
    required String tipo,
    required double montoTotal,
    DateTime? fechaLimite,
    double? interes,
    String? descripcion,
  }) async {
    if (concepto.trim().isEmpty) {
      throw ArgumentError('El concepto no puede estar vacío');
    }
    if (tipo != 'prestamo' && tipo != 'cuota' && tipo != 'tarjeta') {
      throw ArgumentError('Tipo de deuda inválido');
    }
    if (montoTotal <= 0) {
      throw ArgumentError('El monto total debe ser mayor a 0');
    }

    final deuda = Deuda(
      usuarioId: usuarioId,
      concepto: concepto.trim(),
      tipo: tipo,
      montoTotal: montoTotal,
      fechaInicio: DateTime.now(),
      fechaLimite: fechaLimite,
      interes: interes,
      descripcion: descripcion?.trim(),
    );
    await repo.crear(deuda);
  }
}
