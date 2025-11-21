class Chemical {
  // El ID que se codifica en el QR y se usa para la consulta
  final String qrId;
  final String name;
  final String location;
  final List<String> ghsCodes;
  final List<String> requiredEpp;
  final String raVideoUrl;
  final String safeProcedure;

  Chemical({
    required this.qrId,
    required this.name,
    required this.location,
    required this.ghsCodes,
    required this.requiredEpp,
    required this.raVideoUrl,
    required this.safeProcedure,
  });

  // Factory constructor para crear un objeto Chemical desde un JSON (respuesta de Spring Boot)
  factory Chemical.fromJson(Map<String, dynamic> json) {
    return Chemical(
      qrId: json['qrId'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      // Los códigos GHS y EPP vienen como listas de Strings
      ghsCodes: List<String>.from(json['ghsCodes']),
      requiredEpp: List<String>.from(json['requiredEpp']),
      raVideoUrl: json['raVideoUrl'] as String,
      safeProcedure: json['safeProcedure'] as String,
    );
  }
}