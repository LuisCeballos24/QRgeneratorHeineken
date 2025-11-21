import 'package:flutter/material.dart';
import '../models/chemical_model.dart';
import '../services/api_service.dart';

class ChemicalScannerScreen extends StatefulWidget {
  const ChemicalScannerScreen({super.key});

  @override
  State<ChemicalScannerScreen> createState() => _ChemicalScannerScreenState();
}

class _ChemicalScannerScreenState extends State<ChemicalScannerScreen> {
  final QrApiService _apiService = QrApiService();
  Chemical? _chemicalData;
  String _scanInput = 'SODA-CAUSTICA-005'; // ID de ejemplo para simulación
  bool _isLoading = false;
  String? _error;

  // Función simulada de escaneo
  void _scanAndFetchData() async {
    if (_scanInput.isEmpty) return;

    setState(() {
      _isLoading = true;
      _chemicalData = null;
      _error = null;
    });

    try {
      final data = await _apiService.getChemicalByQrId(_scanInput);
      setState(() {
        _chemicalData = data;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget para mostrar un módulo de información
  Widget _buildInfoCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  // Widget para simular la visualización de pictogramas
  Widget _buildGhsPictograms(List<String> codes) {
    // Nota: En la vida real, usarías imágenes reales de los pictogramas.
    final iconMap = {
      'Tóxico': Icons.dangerous,
      'Inflamable': Icons.local_fire_department,
      'Corrosivo': Icons.science,
      'Peligro Ambiental': Icons.eco,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: codes.map((code) {
        return Column(
          children: [
            Icon(
              iconMap[code] ?? Icons.warning,
              size: 40,
              color: Colors.red,
            ),
            const SizedBox(height: 4),
            Text(code, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema 5S Químicos - Heineken'),
        backgroundColor: const Color(0xFF004D40), // Color corporativo verde oscuro
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SIMULACIÓN DEL ESCÁNER ---
            TextField(
              onChanged: (value) => _scanInput = value,
              controller: TextEditingController(text: _scanInput),
              decoration: InputDecoration(
                labelText: 'Simular QR ID Escaneado',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanAndFetchData,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _scanAndFetchData,
              icon: const Icon(Icons.download_for_offline),
              label: Text(_isLoading ? 'Cargando Datos...' : 'Cargar Datos del Químico'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.amber[700], // Amarillo Heineken
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),

            // --- RESULTADO DEL ESCANEO ---
            if (_isLoading && _chemicalData == null)
              const Center(child: CircularProgressIndicator()),
            
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text('ERROR: $_error', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),

            if (_chemicalData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _chemicalData!.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Ubicación: ${_chemicalData!.location}', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 16),
                  
                  // Módulo de Peligros GHS
                  _buildInfoCard(
                    'PELIGROS GHS (Sistema Globalmente Armonizado)',
                    _buildGhsPictograms(_chemicalData!.ghsCodes),
                  ),

                  // Módulo de EPP
                  _buildInfoCard(
                    'EQUIPO DE PROTECCIÓN PERSONAL (EPP) REQUERIDO',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _chemicalData!.requiredEpp.map((epp) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('• $epp', style: const TextStyle(fontSize: 16)),
                      )).toList(),
                    ),
                  ),

                  // Módulo de Procedimientos
                  _buildInfoCard(
                    'PROCEDIMIENTOS SEGUROS DE MANIPULACIÓN',
                    Text(_chemicalData!.safeProcedure, textAlign: TextAlign.justify),
                  ),

                  const SizedBox(height: 20),

                  // Botón de Realidad Aumentada (RA)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implementación de RA: Abrir un paquete como ar_flutter_plugin
                      // o un reproductor de video con la URL: _chemicalData!.raVideoUrl
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Iniciando Video de RA: ${_chemicalData!.raVideoUrl}')),
                      );
                    },
                    icon: const Icon(Icons.videocam, size: 28),
                    label: const Text('VER INSTRUCCIONES EN REALIDAD AUMENTADA (RA)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF00796B), // Un verde más claro
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}