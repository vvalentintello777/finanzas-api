class Movimiento {
  final int? id;
  final int usuarioId;
  final String tipo;        // 'ingreso' | 'gasto'
  final double monto;
  final String categoria;   // libre: 'sueldo', 'alimentacion', etc.
  final String? descripcion;
  final String metodoPago;  // 'efectivo' | 'transferencia'
  final String? referencia;
  final DateTime fecha;

  Movimiento({
    this.id,
    required this.usuarioId,
    required this.tipo,
    required this.monto,
    required this.categoria,
    this.descripcion,
    required this.metodoPago,
    this.referencia,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'tipo': tipo,
        'monto': monto,
        'categoria': categoria,
        'descripcion': descripcion,
        'metodoPago': metodoPago,
        'referencia': referencia,
        'fecha': fecha.toIso8601String().substring(0, 10),
      };
}
