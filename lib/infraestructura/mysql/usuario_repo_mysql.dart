import '../../config/db.dart';
import '../../dominio/usuario.dart';
import '../../dominio/puertos/usuario_repositorio.dart';

class UsuarioRepoMysql implements UsuarioRepositorio {
  Usuario _fromRow(Map<String, dynamic> r) => Usuario(
        id: int.parse(r['id'].toString()),
        email: r['email'].toString(),
        nombre: r['nombre'].toString(),
        passwordHash: r['password_hash'].toString(),
        onboardingCompletado: r['onboarding_completado'].toString() == '1',
      );

  @override
  Future<Usuario?> buscarPorEmail(String email) async {
    final rs = await Db.conn.execute(
      'SELECT id, email, nombre, password_hash, onboarding_completado '
      'FROM usuarios WHERE email = :e',
      {'e': email},
    );
    if (rs.rows.isEmpty) return null;
    return _fromRow(rs.rows.first.assoc());
  }

  @override
  Future<Usuario?> buscarPorId(int id) async {
    final rs = await Db.conn.execute(
      'SELECT id, email, nombre, password_hash, onboarding_completado '
      'FROM usuarios WHERE id = :i',
      {'i': id},
    );
    if (rs.rows.isEmpty) return null;
    return _fromRow(rs.rows.first.assoc());
  }

  @override
  Future<Usuario> crear(Usuario u) async {
    await Db.conn.execute(
      'INSERT INTO usuarios (email, password_hash, nombre, onboarding_completado) '
      'VALUES (:e, :p, :n, 0)',
      {'e': u.email, 'p': u.passwordHash, 'n': u.nombre},
    );
    final creado = await buscarPorEmail(u.email);
    return creado!;
  }

  @override
  Future<void> marcarOnboardingCompletado(int usuarioId) async {
    await Db.conn.execute(
      'UPDATE usuarios SET onboarding_completado = 1 WHERE id = :i',
      {'i': usuarioId},
    );
  }
}
