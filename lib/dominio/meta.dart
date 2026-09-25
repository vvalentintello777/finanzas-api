class Meta {
  final int? id;
  final int usuarioId;
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final DateTime? fechaLimite;
  final String? descripcion;
  final bool completada;

  Meta({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.montoObjetivo,
    this.montoActual = 0,
    this.fechaLimite,
    this.descripcion,
    this.completada = false,
  });

  bool get estaCompletada => montoActual >= montoObjetivo;

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nombre': nombre,
        'montoObjetivo': montoObjetivo,
        'montoActual': montoActual,
        'fechaLimite': fechaLimite?.toIso8601String().substring(0, 10),
        'descripcion': descripcion,
        'completada': completada,
      };
}
