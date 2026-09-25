import '../../dominio/puertos/onboarding_repositorio.dart';

class CompletarOnboarding {
  final OnboardingRepositorio repo;
  CompletarOnboarding(this.repo);

  Future<void> ejecutar({
    required int usuarioId,
    required Map<String, List<String>> seleccion,
  }) async {
    if (usuarioId <= 0) {
      throw ArgumentError('usuarioId inválido');
    }

    final limpio = <String, List<String>>{
      'ingreso': [],
      'gasto': [],
    };

    for (final entry in seleccion.entries) {
      if (entry.key != 'ingreso' && entry.key != 'gasto') continue;
      for (final cat in entry.value) {
        final c = cat.trim();
        if (c.isEmpty) continue;
        if (!limpio[entry.key]!.contains(c)) {
          limpio[entry.key]!.add(c);
        }
      }
    }

    await repo.guardarSeleccion(usuarioId, limpio);
  }
}
