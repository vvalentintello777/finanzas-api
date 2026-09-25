import '../../dominio/movimiento.dart';
import '../../dominio/puertos/movimiento_repositorio.dart';

class ConsultarMovimientos {
  final MovimientoRepositorio repo;
  ConsultarMovimientos(this.repo);

  Future<List<Movimiento>> ejecutar(int usuarioId) async {
    if (usuarioId <= 0) {
      throw ArgumentError('usuarioId inválido');
    }
    return await repo.listarPorUsuario(usuarioId);
  }

  Future<List<String>> categorias(int usuarioId, String tipo) async {
    if (tipo != 'ingreso' && tipo != 'gasto') {
      throw ArgumentError('Tipo inválido');
    }
    return await repo.categorias(usuarioId, tipo);
  }

  Future<void> ocultarCategoria(
      int usuarioId, String tipo, String categoria) async {
    if (categoria.trim().isEmpty) {
      throw ArgumentError('La categoría no puede estar vacía');
    }
    await repo.ocultarCategoria(usuarioId, tipo, categoria.trim());
  }

  Future<void> agregarCategoriaPersonalizada(
      int usuarioId, String tipo, String categoria) async {
    if (categoria.trim().isEmpty) {
      throw ArgumentError('La categoría no puede estar vacía');
    }
    await repo.agregarCategoriaPersonalizada(
        usuarioId, tipo, categoria.trim());
  }
}
