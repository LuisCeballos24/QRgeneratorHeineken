class Chemical {
  final String qrId;
  final String name;
  final String sdsUrl; // NUEVO: Link al PDF MSDS
  final List<String> ghsCodes;
  final List<String> requiredEpp;
  final String raVideoUrl;

  Chemical({
    required this.qrId,
    required this.name,
    this.sdsUrl = '', // Por defecto vacío
    required this.ghsCodes,
    required this.requiredEpp,
    required this.raVideoUrl,
  });

  factory Chemical.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Chemical(
      qrId: documentId,
      name: data['name'] ?? 'Sin nombre',
      sdsUrl: data['sdsUrl'] ?? '', // Leer de Firebase
      ghsCodes: List<String>.from(data['ghsCodes'] ?? []),
      requiredEpp: List<String>.from(data['requiredEpp'] ?? []),
      raVideoUrl: data['raVideoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sdsUrl': sdsUrl, // Guardar en Firebase
      'ghsCodes': ghsCodes,
      'requiredEpp': requiredEpp,
      'raVideoUrl': raVideoUrl,
    };
  }

  // --- HELPER PARA IMÁGENES ---
  // Esta función estática nos dice qué imagen local usar según el código
  static String getImagePath(String code) {
    // Normalizamos el código a minúsculas y sin espacios para comparar
    final normalizedCode = code.toLowerCase().trim();

    // MAPEO: Asocia tus códigos (nombre del archivo renombrado)
    const Map<String, String> imageMap = {
      // Códigos de Peligro (GHS)
      'ghs_oxidacion': 'assets/images/ghs_oxidacion.jpg',
      'ghs_corrosion': 'assets/images/ghs_corrosion.jpg',
      'ghs_peligro': 'assets/images/ghs_peligro.jpg',
      'ghs_ambiente': 'assets/images/ghs_ambiente.jpg',
      // Códigos de EPP
      'epp_gafas': 'assets/images/epp_gafas.jpg',
      'epp_guantes': 'assets/images/epp_guantes.jpg',
      'epp_mascara': 'assets/images/epp_mascara.jpg',
    };

    // Devuelve la ruta si existe, o un placeholder si no (puedes crear una imagen de error)
    return imageMap[normalizedCode] ?? ''; 
  }
}