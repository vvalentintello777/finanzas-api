import 'dart:io';
import 'package:finanzas_api/config/db.dart';
import 'package:finanzas_api/dominio/puertos/usuario_repositorio.dart';
import 'package:finanzas_api/dominio/puertos/movimiento_repositorio.dart';
import 'package:finanzas_api/dominio/puertos/meta_repositorio.dart';
import 'package:finanzas_api/dominio/puertos/deuda_repositorio.dart';
import 'package:finanzas_api/dominio/puertos/onboarding_repositorio.dart';
import 'package:finanzas_api/infraestructura/memoria/usuario_repo_memoria.dart';
import 'package:finanzas_api/infraestructura/memoria/movimiento_repo_memoria.dart';
import 'package:finanzas_api/infraestructura/memoria/meta_repo_memoria.dart';
import 'package:finanzas_api/infraestructura/memoria/deuda_repo_memoria.dart';
import 'package:finanzas_api/infraestructura/memoria/onboarding_repo_memoria.dart';
import 'package:finanzas_api/infraestructura/mysql/usuario_repo_mysql.dart';
import 'package:finanzas_api/infraestructura/mysql/movimiento_repo_mysql.dart';
import 'package:finanzas_api/infraestructura/mysql/meta_repo_mysql.dart';
import 'package:finanzas_api/infraestructura/mysql/deuda_repo_mysql.dart';
import 'package:finanzas_api/infraestructura/mysql/onboarding_repo_mysql.dart';
import 'package:finanzas_api/infraestructura/rutas/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<void> main(List<String> args) async {

final usarMysql = Platform.environment['USE_MYSQL'] == 'true' 
    || args.contains('--mysql');

  late final UsuarioRepositorio usuarioRepo;
  late final MovimientoRepositorio movimientoRepo;
  late final MetaRepositorio metaRepo;
  late final DeudaRepositorio deudaRepo;
  late final OnboardingRepositorio onboardingRepo;

  if (usarMysql) {
    await Db.init();
    print('[Adaptador] MySQL conectado a la base de datos');
    usuarioRepo = UsuarioRepoMysql();
    movimientoRepo = MovimientoRepoMysql();
    metaRepo = MetaRepoMysql();
    deudaRepo = DeudaRepoMysql();
    onboardingRepo = OnboardingRepoMysql();
  } else {
    print('[Adaptador] Usando repositorios en memoria (sin persistencia)');
    usuarioRepo = UsuarioRepoMemoria();
    movimientoRepo = MovimientoRepoMemoria();
    metaRepo = MetaRepoMemoria();
    deudaRepo = DeudaRepoMemoria();
    onboardingRepo = OnboardingRepoMemoria();
  }

  final api = ApiRouter(
    usuarioRepo: usuarioRepo,
    movimientoRepo: movimientoRepo,
    metaRepo: metaRepo,
    deudaRepo: deudaRepo,
    onboardingRepo: onboardingRepo,
  );

  final handler = Pipeline()
      .addMiddleware(_cors())
      .addHandler(api.router.call);

  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  await io.serve(handler, InternetAddress.anyIPv4, port);
  print('API escuchando en http://0.0.0.0:$port');
}

Middleware _cors() {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
  };
  return (inner) => (req) async {
        if (req.method == 'OPTIONS') {
          return Response.ok('', headers: headers);
        }
        final res = await inner(req);
        return res.change(headers: {...res.headers, ...headers});
      };
}
