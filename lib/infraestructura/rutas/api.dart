import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../dominio/puertos/usuario_repositorio.dart';
import '../../dominio/puertos/movimiento_repositorio.dart';
import '../../dominio/puertos/meta_repositorio.dart';
import '../../dominio/puertos/deuda_repositorio.dart';
import '../../dominio/puertos/onboarding_repositorio.dart';

import '../../aplicacion/usuario/registrar_usuario.dart';
import '../../aplicacion/usuario/iniciar_sesion.dart';
import '../../aplicacion/usuario/completar_onboarding.dart';
import '../../aplicacion/usuario/consultar_categorias_onboarding.dart';
import '../../aplicacion/movimiento/registrar_movimiento.dart';
import '../../aplicacion/movimiento/consultar_movimientos.dart';
import '../../aplicacion/movimiento/eliminar_movimiento.dart';
import '../../aplicacion/meta/crear_meta.dart';
import '../../aplicacion/meta/consultar_metas.dart';
import '../../aplicacion/meta/aportar_meta.dart';
import '../../aplicacion/meta/eliminar_meta.dart';
import '../../aplicacion/deuda/crear_deuda.dart';
import '../../aplicacion/deuda/consultar_deudas.dart';
import '../../aplicacion/deuda/pagar_deuda.dart';
import '../../aplicacion/deuda/eliminar_deuda.dart';

Response _json(Object data, {int status = 200}) => Response(
      status,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

Response _error(Object e, {int status = 400}) =>
    _json({'error': e.toString()}, status: status);

class ApiRouter {
  final UsuarioRepositorio usuarioRepo;
  final MovimientoRepositorio movimientoRepo;
  final MetaRepositorio metaRepo;
  final DeudaRepositorio deudaRepo;
  final OnboardingRepositorio onboardingRepo;

  late final RegistrarUsuario registrarUsuario;
  late final IniciarSesion iniciarSesion;
  late final CompletarOnboarding completarOnboarding;
  late final ConsultarCategoriasOnboarding consultarCategoriasOnboarding;
  late final RegistrarMovimiento registrarMovimiento;
  late final ConsultarMovimientos consultarMovimientos;
  late final EliminarMovimiento eliminarMovimiento;
  late final CrearMeta crearMeta;
  late final ConsultarMetas consultarMetas;
  late final AportarMeta aportarMeta;
  late final EliminarMeta eliminarMeta;
  late final CrearDeuda crearDeuda;
  late final ConsultarDeudas consultarDeudas;
  late final PagarDeuda pagarDeuda;
  late final EliminarDeuda eliminarDeuda;

  ApiRouter({
    required this.usuarioRepo,
    required this.movimientoRepo,
    required this.metaRepo,
    required this.deudaRepo,
    required this.onboardingRepo,
  }) {
    registrarUsuario = RegistrarUsuario(usuarioRepo);
    iniciarSesion = IniciarSesion(usuarioRepo);
    completarOnboarding = CompletarOnboarding(onboardingRepo);
    consultarCategoriasOnboarding =
        ConsultarCategoriasOnboarding(onboardingRepo);
    registrarMovimiento = RegistrarMovimiento(movimientoRepo);
    consultarMovimientos = ConsultarMovimientos(movimientoRepo);
    eliminarMovimiento = EliminarMovimiento(movimientoRepo);
    crearMeta = CrearMeta(metaRepo);
    consultarMetas = ConsultarMetas(metaRepo);
    aportarMeta = AportarMeta(metaRepo);
    eliminarMeta = EliminarMeta(metaRepo);
    crearDeuda = CrearDeuda(deudaRepo);
    consultarDeudas = ConsultarDeudas(deudaRepo);
    pagarDeuda = PagarDeuda(deudaRepo);
    eliminarDeuda = EliminarDeuda(deudaRepo);
  }

  Router get router {
    final r = Router();

    // ---------- AUTH ----------
    r.post('/api/register', (Request req) async {
      try {
        final b = jsonDecode(await req.readAsString());
        final u = await registrarUsuario.ejecutar(
          email: b['email'] ?? '',
          password: b['password'] ?? '',
          nombre: b['nombre'] ?? '',
        );
        return _json(u.toPublicJson());
      } catch (e) {
        return _error(e, status: 400);
      }
    });

    r.post('/api/login', (Request req) async {
      try {
        final b = jsonDecode(await req.readAsString());
        final u = await iniciarSesion.ejecutar(
          email: b['email'] ?? '',
          password: b['password'] ?? '',
        );
        return _json(u.toPublicJson());
      } catch (e) {
        return _error(e, status: 401);
      }
    });

    // ---------- ONBOARDING ----------
    r.get('/api/onboarding/<uid>', (Request req, String uid) async {
      try {
        final data =
            await consultarCategoriasOnboarding.ejecutar(int.parse(uid));
        return _json(data);
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/onboarding/<uid>', (Request req, String uid) async {
      try {
        final b = jsonDecode(await req.readAsString());
        final seleccionRaw = b['seleccion'] as Map<String, dynamic>;
        final seleccion = <String, List<String>>{
          'ingreso':
              List<String>.from(seleccionRaw['ingreso'] ?? const []),
          'gasto':
              List<String>.from(seleccionRaw['gasto'] ?? const []),
        };
        await completarOnboarding.ejecutar(
          usuarioId: int.parse(uid),
          seleccion: seleccion,
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    // ---------- MOVIMIENTOS ----------
    r.get('/api/movimientos/<uid>', (Request req, String uid) async {
      try {
        final lista = await consultarMovimientos.ejecutar(int.parse(uid));
        return _json(lista.map((m) => m.toJson()).toList());
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/movimientos', (Request req) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await registrarMovimiento.ejecutar(
          usuarioId: b['usuarioId'],
          tipo: b['tipo'],
          monto: (b['monto'] as num).toDouble(),
          categoria: b['categoria'],
          descripcion: b['descripcion'],
          metodoPago: b['metodoPago'] ?? 'efectivo',
          referencia: b['referencia'],
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.delete('/api/movimientos/<id>/<uid>',
        (Request req, String id, String uid) async {
      try {
        await eliminarMovimiento.ejecutar(
          id: int.parse(id),
          usuarioId: int.parse(uid),
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    // ---------- CATEGORIAS ----------
    r.get('/api/categorias/<uid>/<tipo>',
        (Request req, String uid, String tipo) async {
      try {
        final lista = await consultarMovimientos
            .categorias(int.parse(uid), tipo);
        return _json(lista);
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/categorias/<uid>/<tipo>',
        (Request req, String uid, String tipo) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await consultarMovimientos.agregarCategoriaPersonalizada(
          int.parse(uid),
          tipo,
          b['categoria'] ?? '',
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/categorias/<uid>/<tipo>/ocultar',
        (Request req, String uid, String tipo) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await consultarMovimientos.ocultarCategoria(
          int.parse(uid),
          tipo,
          b['categoria'] ?? '',
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    // ---------- METAS ----------
    r.get('/api/metas/<uid>', (Request req, String uid) async {
      try {
        final lista = await consultarMetas.ejecutar(int.parse(uid));
        return _json(lista.map((m) => m.toJson()).toList());
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/metas', (Request req) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await crearMeta.ejecutar(
          usuarioId: b['usuarioId'],
          nombre: b['nombre'],
          montoObjetivo: (b['montoObjetivo'] as num).toDouble(),
          fechaLimite: b['fechaLimite'] != null
              ? DateTime.parse(b['fechaLimite'])
              : null,
          descripcion: b['descripcion'],
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/metas/<id>/aportar', (Request req, String id) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await aportarMeta.ejecutar(
          metaId: int.parse(id),
          monto: (b['monto'] as num).toDouble(),
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.delete('/api/metas/<id>/<uid>',
        (Request req, String id, String uid) async {
      try {
        await eliminarMeta.ejecutar(
          id: int.parse(id),
          usuarioId: int.parse(uid),
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    // ---------- DEUDAS ----------
    r.get('/api/deudas/<uid>', (Request req, String uid) async {
      try {
        final lista = await consultarDeudas.ejecutar(int.parse(uid));
        return _json(lista.map((d) => d.toJson()).toList());
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/deudas', (Request req) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await crearDeuda.ejecutar(
          usuarioId: b['usuarioId'],
          concepto: b['concepto'],
          tipo: b['tipo'],
          montoTotal: (b['montoTotal'] as num).toDouble(),
          fechaLimite: b['fechaLimite'] != null
              ? DateTime.parse(b['fechaLimite'])
              : null,
          interes:
              b['interes'] != null ? (b['interes'] as num).toDouble() : null,
          descripcion: b['descripcion'],
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.post('/api/deudas/<id>/pagar', (Request req, String id) async {
      try {
        final b = jsonDecode(await req.readAsString());
        await pagarDeuda.ejecutar(
          deudaId: int.parse(id),
          monto: (b['monto'] as num).toDouble(),
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    r.delete('/api/deudas/<id>/<uid>',
        (Request req, String id, String uid) async {
      try {
        await eliminarDeuda.ejecutar(
          id: int.parse(id),
          usuarioId: int.parse(uid),
        );
        return _json({'ok': true});
      } catch (e) {
        return _error(e);
      }
    });

    return r;
  }
}
