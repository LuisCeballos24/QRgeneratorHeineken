import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chemical_model.dart';

// URL base de tu servicio Spring Boot
const String _baseUrl = 'http://localhost:8080';

class QrApiService {
  // Función que simula el escaneo del QR y obtiene los datos del químico
  Future<Chemical> getChemicalByQrId(String qrId) async {
    final uri = Uri.parse('$_baseUrl/chemicals/$qrId');
    
    // Simulación de Exponential Backoff para manejo de throttling (mejor práctica)
    const maxRetries = 3;
    const initialDelay = Duration(seconds: 1);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
        });

        if (response.statusCode == 200) {
          // Si la respuesta es exitosa (200 OK), parseamos el JSON a nuestro modelo Chemical
          final data = json.decode(utf8.decode(response.bodyBytes));
          return Chemical.fromJson(data);
        } else if (response.statusCode == 404) {
          // El QR ID no fue encontrado
          throw Exception('Químico con ID $qrId no encontrado (Error 404)');
        } else if (response.statusCode >= 500 && attempt < maxRetries) {
          // Error de servidor, reintentar
          await Future.delayed(initialDelay * (1 << (attempt - 1)));
          print('Error de servidor: ${response.statusCode}. Reintentando...');
          continue;
        } else {
          // Otros errores o último intento fallido
          throw Exception('Fallo al cargar el químico. Código: ${response.statusCode}');
        }
      } catch (e) {
        // Error de red, reintentar
        if (attempt < maxRetries) {
           await Future.delayed(initialDelay * (1 << (attempt - 1)));
           print('Error de red: $e. Reintentando...');
           continue;
        }
        throw Exception('Fallo de conexión: $e');
      }
    }
    // Debe ser inalcanzable si maxRetries > 0, pero por seguridad
    throw Exception('Fallo al obtener el químico después de múltiples reintentos.');
  }

  // En una aplicación real, aquí también se pondría el método para obtener
  // la lista de químicos o buscar.
}