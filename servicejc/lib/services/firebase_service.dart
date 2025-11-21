import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chemical_model.dart';

class FirebaseService {
  final CollectionReference _chemicalRef =
      FirebaseFirestore.instance.collection('quimicos');

  // 1. Obtener lista en tiempo real
  Stream<List<Chemical>> getChemicals() {
    return _chemicalRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Chemical.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // 2. Buscar por ID (cuando escaneas el QR)
  Future<Chemical?> getChemicalById(String id) async {
    try {
      DocumentSnapshot doc = await _chemicalRef.doc(id).get();
      if (doc.exists) {
        return Chemical.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
    } catch (e) {
      print("Error buscando químico: $e");
    }
    return null;
  }

  // 3. Agregar nuevo químico
  Future<void> addChemical(Chemical chemical) async {
    // Firestore genera un ID automático
    await _chemicalRef.add(chemical.toMap());
  }
  
  // 4. Eliminar
  Future<void> deleteChemical(String id) async {
    await _chemicalRef.doc(id).delete();
  }
}