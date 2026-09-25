import '../../dominio/puertos/onboarding_repositorio.dart';

class OnboardingRepoMemoria implements OnboardingRepositorio {
  static const _predefinidas = {
    'ingreso': [
      'Sueldo',
      'Freelance',
      'Ventas',
      'Alquileres',
      'Inversiones',
    ],
    'gasto': [
      'Alimentación',
      'Transporte',
      'Servicios',
      'Compras',
      'Ocio',
      'Salud',
      'Educación',
    ],
  };

  final Map<int, Map<String, List<String>>> _datos = {};

  @override
  Map<String, List<String>> obtenerPredefinidas() => _predefinidas;

  @override
  Future<void> guardarSeleccion(
    int usuarioId,
    Map<String, List<String>> seleccion,
  ) async {
    _datos[usuarioId] = {
      'ingreso': List<String>.from(seleccion['ingreso'] ?? []),
      'gasto': List<String>.from(seleccion['gasto'] ?? []),
    };
  }

  @override
  Future<Map<String, List<String>>> obtenerSeleccion(int usuarioId) async {
    return _datos[usuarioId] ??
        {
          'ingreso': <String>[],
          'gasto': <String>[],
        };
  }
}
