import '../../dominio/usuario.dart';
import '../../dominio/puertos/usuario_repositorio.dart';

class UsuarioRepoMemoria implements UsuarioRepositorio {
  final Map<int, Usuario> _datos = {};
  int _proximoId = 1;

  @override
  Future<Usuario?> buscarPorEmail(String email) async {
    for (final u in _datos.values) {
      if (u.email == email) return u;
    }
    return null;
  }

  @override
  Future<Usuario?> buscarPorId(int id) async {
    return _datos[id];
  }

  @override
  Future<Usuario> crear(Usuario u) async {
    final nuevo = u.copyWith(id: _proximoId++);
    _datos[nuevo.id!] = nuevo;
    return nuevo;
  }

  @override
  Future<void> marcarOnboardingCompletado(int usuarioId) async {
    final u = _datos[usuarioId];
    if (u != null) {
      _datos[usuarioId] = u.copyWith(onboardingCompletado: true);
    }
  }
}
