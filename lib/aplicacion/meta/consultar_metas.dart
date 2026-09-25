import '../../dominio/meta.dart';
import '../../dominio/puertos/meta_repositorio.dart';

class ConsultarMetas {
  final MetaRepositorio repo;
  ConsultarMetas(this.repo);

  Future<List<Meta>> ejecutar(int usuarioId) async {
    if (usuarioId <= 0) {
      throw ArgumentError('usuarioId inválido');
    }
    return await repo.listarPorUsuario(usuarioId);
  }
}
