import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/chemical_model.dart';

class ChemicalDetailScreen extends StatelessWidget {
  final Chemical chemical;

  // Colores del prototipo
  final Color _darkBlue = const Color(0xFF0D2C54);
  final Color _greenButton = const Color(0xFF2E7D32);
  final Color _yellowButton = const Color(0xFFFFC107);

  const ChemicalDetailScreen({Key? key, required this.chemical}) : super(key: key);

  // Función para abrir links
  Future<void> _launchURL(BuildContext context, String urlString) async {
    if (urlString.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay enlace disponible')));
       return;
    }
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al abrir: $e')));
    }
  }

  // Widget para las filas de iconos (EPP y Peligros)
  Widget _buildIconRow(List<String> codes) {
    if (codes.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: codes.map((code) {
        String imagePath = Chemical.getImagePath(code);
        if (imagePath.isEmpty) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 2),
             // Para EPPs redondos en el prototipo
            shape: code.startsWith('epp') ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: ClipRRect(
             borderRadius: code.startsWith('epp') ? BorderRadius.circular(40) : BorderRadius.zero,
             child: Image.asset(imagePath, fit: BoxFit.contain)
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBlue,
      appBar: AppBar(
        backgroundColor: _darkBlue,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.yellow), onPressed: (){}),
        title: Text(chemical.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2, color: Colors.white),
            onPressed: () {
              // Mostrar QR en diálogo simple
               showDialog(context: context, builder: (_) => SimpleDialog(
                 children: [
                   SizedBox(height: 200, width: 200, child: QrImageView(data: chemical.qrId))
                 ]
               ));
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Ubicación (XY-12)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          const Spacer(flex: 1),
          
          // Fila de EPPs
          _buildIconRow(chemical.requiredEpp),
          
          const SizedBox(height: 30),
          
          // Botón SDS
          InkWell(
            onTap: () => _launchURL(context, chemical.sdsUrl),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _greenButton,
                 border: Border.all(color: Colors.lightGreenAccent, width: 3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text('SDS', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          
           const SizedBox(height: 30),

          // Fila de Peligros GHS
           _buildIconRow(chemical.ghsCodes),

          const Spacer(flex: 2),

          // Botón Amarillo Inferior (RA Video)
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _yellowButton,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Rectangular
              ),
              onPressed: () => _launchURL(context, chemical.raVideoUrl),
              child: const Text('VER INSTRUCCIONES EN RA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}