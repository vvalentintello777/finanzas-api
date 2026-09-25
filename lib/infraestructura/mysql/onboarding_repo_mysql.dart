import '../../config/db.dart';
import '../../dominio/puertos/onboarding_repositorio.dart';

class OnboardingRepoMysql implements OnboardingRepositorio {
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

  @override
  Map<String, List<String>> obtenerPredefinidas() => _predefinidas;

  @override
  Future<void> guardarSeleccion(
    int usuarioId,
    Map<String, List<String>> seleccion,
  ) async {
    await Db.conn.execute(
      'DELETE FROM categorias_personalizadas WHERE usuario_id = :u',
      {'u': usuarioId},
    );

    for (final entry in seleccion.entries) {
      final tipo = entry.key;
      for (final cat in entry.value) {
        final limpia = cat.trim();
        if (limpia.isEmpty) continue;
        await Db.conn.execute(
          'INSERT IGNORE INTO categorias_personalizadas '
          '(usuario_id, tipo, categoria) VALUES (:u, :t, :c)',
          {'u': usuarioId, 't': tipo, 'c': limpia},
        );
      }
    }

    await Db.conn.execute(
      'UPDATE usuarios SET onboarding_completado = 1 WHERE id = :u',
      {'u': usuarioId},
    );
  }

  @override
  Future<Map<String, List<String>>> obtenerSeleccion(int usuarioId) async {
    final rs = await Db.conn.execute(
      'SELECT tipo, categoria FROM categorias_personalizadas '
      'WHERE usuario_id = :u ORDER BY categoria',
      {'u': usuarioId},
    );
    final res = <String, List<String>>{
      'ingreso': <String>[],
      'gasto': <String>[],
    };
    for (final r in rs.rows) {
      final row = r.assoc();
      final tipo = row['tipo'].toString();
      final cat = row['categoria'].toString();
      res.putIfAbsent(tipo, () => <String>[]).add(cat);
    }
    return res;
  }
}
