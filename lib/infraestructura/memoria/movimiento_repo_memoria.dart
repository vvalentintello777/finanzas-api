import '../../dominio/movimiento.dart';
import '../../dominio/puertos/movimiento_repositorio.dart';

class MovimientoRepoMemoria implements MovimientoRepositorio {
  final Map<int, Movimiento> _datos = {};
  final Set<String> _ocultas = {};
  final Set<String> _personalizadas = {};
  int _proximoId = 1;

  @override
  Future<void> crear(Movimiento m) async {
    final nuevo = Movimiento(
      id: _proximoId++,
      usuarioId: m.usuarioId,
      tipo: m.tipo,
      monto: m.monto,
      categoria: m.categoria,
      descripcion: m.descripcion,
      metodoPago: m.metodoPago,
      referencia: m.referencia,
      fecha: m.fecha,
    );
    _datos[nuevo.id!] = nuevo;
  }

  @override
  Future<List<Movimiento>> listarPorUsuario(int usuarioId) async {
    final lista = _datos.values
        .where((m) => m.usuarioId == usuarioId)
        .toList();
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  @override
  Future<void> eliminar(int id, int usuarioId) async {
    final m = _datos[id];
    if (m != null && m.usuarioId == usuarioId) {
      _datos.remove(id);
    }
  }

  @override
  Future<List<String>> categorias(int usuarioId, String tipo) async {
    final set = <String>{};
    for (final m in _datos.values) {
      if (m.usuarioId == usuarioId && m.tipo == tipo) {
        set.add(m.categoria);
      }
    }
    for (final c in _personalizadas) {
      final partes = c.split('|');
      if (partes.length == 3 &&
          int.parse(partes[0]) == usuarioId &&
          partes[1] == tipo) {
        set.add(partes[2]);
      }
    }
    for (final o in _ocultas) {
      final partes = o.split('|');
      if (partes.length == 3 &&
          int.parse(partes[0]) == usuarioId &&
          partes[1] == tipo) {
        set.remove(partes[2]);
      }
    }
    final lista = set.toList()..sort();
    return lista;
  }

  @override
  Future<void> ocultarCategoria(
      int usuarioId, String tipo, String categoria) async {
    _ocultas.add('$usuarioId|$tipo|$categoria');
    _personalizadas.remove('$usuarioId|$tipo|$categoria');
  }

  @override
  Future<List<String>> categoriasPersonalizadas(
      int usuarioId, String tipo) async {
    final res = <String>[];
    for (final c in _personalizadas) {
      final partes = c.split('|');
      if (partes.length == 3 &&
          int.parse(partes[0]) == usuarioId &&
          partes[1] == tipo) {
        res.add(partes[2]);
      }
    }
    return res;
  }

  @override
  Future<void> agregarCategoriaPersonalizada(
      int usuarioId, String tipo, String categoria) async {
    _personalizadas.add('$usuarioId|$tipo|$categoria');
  }
}
