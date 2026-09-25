import '../movimiento.dart';

abstract class MovimientoRepositorio {
  Future<void> crear(Movimiento movimiento);
  Future<List<Movimiento>> listarPorUsuario(int usuarioId);
  Future<void> eliminar(int id, int usuarioId);
  Future<List<String>> categorias(int usuarioId, String tipo);
  Future<void> ocultarCategoria(int usuarioId, String tipo, String categoria);
  Future<List<String>> categoriasPersonalizadas(int usuarioId, String tipo);
  Future<void> agregarCategoriaPersonalizada(
      int usuarioId, String tipo, String categoria);
}
