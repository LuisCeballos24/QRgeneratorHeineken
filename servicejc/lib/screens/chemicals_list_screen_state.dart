import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/firebase_service.dart';
import '../models/chemical_model.dart';
import 'chemical_scanner_screen.dart';
import 'add_chemical_screen.dart';
import 'chemical_detail_screen.dart';

class ChemicalsListScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  // Paleta de Colores
  final Color _darkBackground = const Color(0xFF0D2C54); // Azul Oscuro Fondo
  final Color _cardColor = const Color(0xFF153866);      // Azul Ligeramente más claro para tarjetas
  final Color _accentYellow = const Color(0xFFFFC107);   // Amarillo Industrial
  final Color _accentGreen = const Color(0xFF2E7D32);    // Verde Seguridad

  ChemicalsListScreen({Key? key}) : super(key: key);

  // Función para mostrar el QR en grande
  void _showQRCode(BuildContext context, Chemical chemical) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(chemical.name, style: const TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: QrImageView(
                data: chemical.qrId,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            const SizedBox(height: 10),
            Text("ID: ${chemical.qrId}", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  // Widget auxiliar para renderizar filas de iconos pequeños
  Widget _buildIconRow(List<String> codes, String label, Color labelColor) {
    if (codes.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(color: labelColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: codes.take(5).map((code) {
            String path = Chemical.getImagePath(code);
            if (path.isEmpty) return const SizedBox.shrink();
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(path, width: 28, height: 28), // Iconos más grandes
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground, // FONDO OSCURO
      appBar: AppBar(
        backgroundColor: _darkBackground,
        elevation: 0,
        title: const Text(
          'INVENTARIO HEINEKEN', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChemicalScannerScreen())),
          )
        ],
      ),
      body: StreamBuilder<List<Chemical>>(
        stream: _firebaseService.getChemicals(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error de carga', style: TextStyle(color: Colors.white)));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final chemicals = snapshot.data ?? [];

          if (chemicals.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.science_outlined, size: 80, color: Colors.white24),
                  SizedBox(height: 20),
                  Text('Sin registros', style: TextStyle(color: Colors.white54, fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chemicals.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final chem = chemicals[index];
              
              // --- DISEÑO DE LA TARJETA ---
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChemicalDetailScreen(chemical: chem)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)), // Borde sutil
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. CABECERA: Nombre y Botón QR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                chem.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _showQRCode(context, chem),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.qr_code_2, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // 2. UBICACIÓN (Etiqueta estilo Chip)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accentGreen),
                          ),
                        ),

                        const Divider(color: Colors.white24, height: 24),

                        // 3. ZONA VISUAL DE ICONOS
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna Izquierda: Peligros
                            Expanded(
                              child: _buildIconRow(chem.ghsCodes, 'PELIGROS (GHS)', Colors.redAccent),
                            ),
                            // Columna Derecha: EPP
                            Expanded(
                              child: _buildIconRow(chem.requiredEpp, 'EPP REQUERIDO', Colors.blueAccent),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        // Texto pequeño de instrucción
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Toca para ver detalles >',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _accentYellow,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text("NUEVO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddChemicalScreen()),
          );
        },
      ),
    );
  }
}