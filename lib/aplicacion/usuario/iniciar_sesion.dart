import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../dominio/usuario.dart';
import '../../dominio/puertos/usuario_repositorio.dart';

class IniciarSesion {
  final UsuarioRepositorio repo;
  IniciarSesion(this.repo);

  Future<Usuario> ejecutar({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email y contraseña son obligatorios');
    }

    final u = await repo.buscarPorEmail(email);
    if (u == null) {
      throw StateError('Usuario no existe');
    }

    final hash = sha256.convert(utf8.encode(password)).toString();
    if (hash != u.passwordHash) {
      throw StateError('Contraseña incorrecta');
    }

    return u;
  }
}
