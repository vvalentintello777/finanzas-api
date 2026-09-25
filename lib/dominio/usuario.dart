class Usuario {
  final int? id;
  final String email;
  final String nombre;
  final String passwordHash;
  final bool onboardingCompletado;

  Usuario({
    this.id,
    required this.email,
    required this.nombre,
    required this.passwordHash,
    this.onboardingCompletado = false,
  });

  Map<String, dynamic> toPublicJson() => {
        'id': id,
        'email': email,
        'nombre': nombre,
        'onboardingCompletado': onboardingCompletado,
      };

  Usuario copyWith({
    int? id,
    String? email,
    String? nombre,
    String? passwordHash,
    bool? onboardingCompletado,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      passwordHash: passwordHash ?? this.passwordHash,
      onboardingCompletado:
          onboardingCompletado ?? this.onboardingCompletado,
    );
  }
}
