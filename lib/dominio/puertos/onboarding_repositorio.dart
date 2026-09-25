/// Puerto para el onboarding de categorías.
abstract class OnboardingRepositorio {
  /// Guarda todas las categorías que el usuario marcó en el onboarding.
  /// Reemplaza las existentes del mismo tipo.
  Future<void> guardarSeleccion(
    int usuarioId,
    Map<String, List<String>> seleccion,
  );

  /// Categorías típicas precargadas en el sistema.
  Map<String, List<String>> obtenerPredefinidas();

  /// Categorías personalizadas actuales del usuario.
  Future<Map<String, List<String>>> obtenerSeleccion(int usuarioId);
}
