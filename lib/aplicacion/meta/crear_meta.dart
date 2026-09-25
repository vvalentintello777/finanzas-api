import '../../dominio/meta.dart';
import '../../dominio/puertos/meta_repositorio.dart';

class CrearMeta {
  final MetaRepositorio repo;
  CrearMeta(this.repo);

  Future<void> ejecutar({
    required int usuarioId,
    required String nombre,
    required double montoObjetivo,
    DateTime? fechaLimite,
    String? descripcion,
  }) async {
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }
    if (montoObjetivo <= 0) {
      throw ArgumentError('El monto objetivo debe ser mayor a 0');
    }

    final meta = Meta(
      usuarioId: usuarioId,
      nombre: nombre.trim(),
      montoObjetivo: montoObjetivo,
      fechaLimite: fechaLimite,
      descripcion: descripcion?.trim(),
    );
    await repo.crear(meta);
  }
}
