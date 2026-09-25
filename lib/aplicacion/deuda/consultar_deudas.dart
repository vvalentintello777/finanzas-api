import '../../dominio/deuda.dart';
import '../../dominio/puertos/deuda_repositorio.dart';

class ConsultarDeudas {
  final DeudaRepositorio repo;
  ConsultarDeudas(this.repo);

  Future<List<Deuda>> ejecutar(int usuarioId) async {
    if (usuarioId <= 0) {
      throw ArgumentError('usuarioId inválido');
    }
    return await repo.listarPorUsuario(usuarioId);
  }
}
