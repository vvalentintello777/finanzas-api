import '../usuario.dart';

abstract class UsuarioRepositorio {
  Future<Usuario?> buscarPorEmail(String email);
  Future<Usuario?> buscarPorId(int id);
  Future<Usuario> crear(Usuario usuario);

  /// Marca al usuario como que completó el onboarding de categorías.
  Future<void> marcarOnboardingCompletado(int usuarioId);
}
