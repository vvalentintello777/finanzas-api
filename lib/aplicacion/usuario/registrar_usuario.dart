import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../dominio/usuario.dart';
import '../../dominio/puertos/usuario_repositorio.dart';

class RegistrarUsuario {
  final UsuarioRepositorio repo;
  RegistrarUsuario(this.repo);

  Future<Usuario> ejecutar({
    required String email,
    required String password,
    required String nombre,
  }) async {
    // Validaciones de negocio
    if (email.trim().isEmpty || !email.contains('@')) {
      throw ArgumentError('Email inválido');
    }
    if (password.length < 4) {
      throw ArgumentError('La contraseña debe tener al menos 4 caracteres');
    }
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }

    // Regla de unicidad
    final existente = await repo.buscarPorEmail(email);
    if (existente != null) {
      throw StateError('El email ya está registrado');
    }

    // Creación con hash
    final hash = sha256.convert(utf8.encode(password)).toString();
    final nuevo = Usuario(
      email: email.trim(),
      nombre: nombre.trim(),
      passwordHash: hash,
    );
    return await repo.crear(nuevo);
  }
}
