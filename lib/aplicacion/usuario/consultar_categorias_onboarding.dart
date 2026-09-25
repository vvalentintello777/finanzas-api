import '../../dominio/puertos/onboarding_repositorio.dart';

class ConsultarCategoriasOnboarding {
  final OnboardingRepositorio repo;
  ConsultarCategoriasOnboarding(this.repo);

  Future<Map<String, dynamic>> ejecutar(int usuarioId) async {
    final predefinidas = repo.obtenerPredefinidas();
    final seleccion = await repo.obtenerSeleccion(usuarioId);
    return {
      'predefinidas': predefinidas,
      'seleccion': seleccion,
    };
  }
}
