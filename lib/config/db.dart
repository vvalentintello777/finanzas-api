import 'dart:io';
import 'package:mysql_client/mysql_client.dart';

class Db {
  static late final MySQLConnection _conn;
  static MySQLConnection get conn => _conn;

  static Future<void> init() async {
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
    final port = int.tryParse(Platform.environment['DB_PORT'] ?? '3306') ?? 3306;
    final user = Platform.environment['DB_USER'] ?? 'root';
    final password = Platform.environment['DB_PASSWORD'] ?? 'Kodify2026';
    final database = Platform.environment['DB_NAME'] ?? 'finanzas_db';

    _conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: database,
      secure: true,  // ← SSL para Aiven
    );
    await _conn.connect();
  }

  static Future<void> close() async {
    await _conn.close();
  }
}
