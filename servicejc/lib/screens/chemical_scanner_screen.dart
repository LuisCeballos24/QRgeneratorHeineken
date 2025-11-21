import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/firebase_service.dart';
import '../models/chemical_model.dart';

class ChemicalScannerScreen extends StatefulWidget {
  const ChemicalScannerScreen({Key? key}) : super(key: key);

  @override
  State<ChemicalScannerScreen> createState() => _ChemicalScannerScreenState();
}

class _ChemicalScannerScreenState extends State<ChemicalScannerScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isScanning = true;

  void _handleBarcode(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;

    if (code != null) {
      setState(() => _isScanning = false);

      Chemical? chemical = await _firebaseService.getChemicalById(code);

      if (!mounted) return;

      if (chemical != null) {
        _showResultDialog(chemical);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Producto no encontrado')),
        );
        setState(() => _isScanning = true);
      }
    }
  }

  void _showResultDialog(Chemical chemical) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(chemical.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text('⚠️ Códigos GHS:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 6.0,
                children: chemical.ghsCodes.map((code) => Chip(label: Text(code))).toList(),
              ),
              const SizedBox(height: 10),
              const Text('🛡️ EPP Requerido:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 6.0,
                children: chemical.requiredEpp.map((epp) => Chip(label: Text(epp), backgroundColor: Colors.orange[100])).toList(),
              ),
              const SizedBox(height: 10),
              const Text('📋 Procedimiento Seguro:', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _isScanning = true);
            },
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Etiqueta QR')),
      body: MobileScanner(onDetect: _handleBarcode),
    );
  }
}