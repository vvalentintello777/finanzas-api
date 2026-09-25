import '../../dominio/movimiento.dart';
import '../../dominio/puertos/movimiento_repositorio.dart';

class RegistrarMovimiento {
  final MovimientoRepositorio repo;
  RegistrarMovimiento(this.repo);

  Future<Movimiento> ejecutar({
    required int usuarioId,
    required String tipo,
    required double monto,
    required String categoria,
    String? descripcion,
    String metodoPago = 'efectivo',
    String? referencia,
  }) async {
    if (tipo != 'ingreso' && tipo != 'gasto') {
      throw ArgumentError("El tipo debe ser 'ingreso' o 'gasto'");
    }
    if (monto <= 0) {
      throw ArgumentError('El monto debe ser mayor a 0');
    }
    if (categoria.trim().isEmpty) {
      throw ArgumentError('La categoría no puede estar vacía');
    }
    if (metodoPago != 'efectivo' && metodoPago != 'transferencia') {
      throw ArgumentError('Método de pago inválido');
    }

    final mov = Movimiento(
      usuarioId: usuarioId,
      tipo: tipo,
      monto: monto,
      categoria: categoria.trim(),
      descripcion: descripcion?.trim(),
      metodoPago: metodoPago,
      referencia: referencia?.trim(),
      fecha: DateTime.now(),
    );
    await repo.crear(mov);
    return mov;
  }
}
