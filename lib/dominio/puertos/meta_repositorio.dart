import '../meta.dart';

/// Puerto para la persistencia de metas.
abstract class MetaRepositorio {
  Future<void> crear(Meta meta);
  Future<List<Meta>> listarPorUsuario(int usuarioId);
  Future<void> aportar(int metaId, double monto);
  Future<void> eliminar(int id, int usuarioId);
}
