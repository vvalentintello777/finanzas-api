class Deuda {
  final int? id;
  final int usuarioId;
  final String concepto;
  final String tipo;       // 'prestamo' | 'cuota' | 'tarjeta'
  final double montoTotal;
  final double montoPagado;
  final DateTime fechaInicio;
  final DateTime? fechaLimite;
  final double? interes;
  final String? descripcion;
  final bool saldada;

  Deuda({
    this.id,
    required this.usuarioId,
    required this.concepto,
    required this.tipo,
    required this.montoTotal,
    this.montoPagado = 0,
    required this.fechaInicio,
    this.fechaLimite,
    this.interes,
    this.descripcion,
    this.saldada = false,
  });

  bool get estaSaldada => montoPagado >= montoTotal;

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'concepto': concepto,
        'tipo': tipo,
        'montoTotal': montoTotal,
        'montoPagado': montoPagado,
        'fechaInicio': fechaInicio.toIso8601String().substring(0, 10),
        'fechaLimite': fechaLimite?.toIso8601String().substring(0, 10),
        'interes': interes,
        'descripcion': descripcion,
        'saldada': saldada,
      };
}
