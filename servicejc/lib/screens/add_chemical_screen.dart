import 'package:flutter/material.dart';
import '../models/chemical_model.dart';
import '../services/firebase_service.dart';

class AddChemicalScreen extends StatefulWidget {
  const AddChemicalScreen({Key? key}) : super(key: key);

  @override
  State<AddChemicalScreen> createState() => _AddChemicalScreenState();
}

class _AddChemicalScreenState extends State<AddChemicalScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sdsUrlController = TextEditingController();
  final TextEditingController _raVideoUrlController = TextEditingController();
  final TextEditingController _procedureController = TextEditingController();

  // LISTAS PARA LA SELECCIÓN MÚLTIPLE
  final List<String> _availableGhs = ['ghs_oxidacion', 'ghs_corrosion', 'ghs_peligro', 'ghs_ambiente'];
  final List<String> _availableEpp = ['epp_gafas', 'epp_guantes', 'epp_mascara'];

  // Listas de selección
  final List<String> _selectedGhs = [];
  final List<String> _selectedEpp = [];

  // Función para guardar
  void _saveChemical() async {
    // Aún mantenemos el save, pero ya no detiene el proceso si está vacío
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Si el nombre está vacío, ponemos uno por defecto para que no se rompa la lista visual
    String finalName = _nameController.text.trim();
    if (finalName.isEmpty) finalName = "Sin Nombre";

    final newChemical = Chemical(
      qrId: '', 
      name: finalName,// Puede ir vacío
      sdsUrl: _sdsUrlController.text,
      ghsCodes: _selectedGhs, // Puede ir vacío
      requiredEpp: _selectedEpp, // Puede ir vacío
      raVideoUrl: _raVideoUrlController.text, // Puede ir vacío
    );

    await _firebaseService.addChemical(newChemical);

    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Químico agregado correctamente')));
  }

  // Widget auxiliar para chips
  Widget _buildMultiSelect({
    required String title,
    required List<String> options,
    required List<String> selectedList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((option) {
            final isSelected = selectedList.contains(option);
            final imagePath = Chemical.getImagePath(option);

            return FilterChip(
              label: Text(option.replaceAll('_', ' ').toUpperCase()),
              avatar: imagePath.isNotEmpty 
                  ? CircleAvatar(backgroundImage: AssetImage(imagePath), backgroundColor: Colors.transparent)
                  : null,
              selected: isSelected,
              selectedColor: Colors.green[200],
              checkmarkColor: Colors.green[900],
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedList.add(option);
                  } else {
                    selectedList.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Químico')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DATOS BÁSICOS ---
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Químico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.science),
                      ),
                      // YA NO ES REQUERIDO (Validator eliminado)
                    ),
                    const SizedBox(height: 15),


                    // --- LINKS ---
                    TextFormField(
                      controller: _sdsUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Link PDF SDS',
                        hintText: 'https://...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.picture_as_pdf),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 15),
                    
                    TextFormField(
                      controller: _raVideoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Link Video RA',
                        hintText: 'https://...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.video_library),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    
                    const Divider(height: 40, thickness: 2),

                    // --- SELECCIÓN VISUAL (CHIPS) ---
                    // Pueden quedar vacíos sin problema
                    _buildMultiSelect(
                      title: 'Selecciona Peligros (GHS):',
                      options: _availableGhs,
                      selectedList: _selectedGhs,
                    ),
                    
                    const SizedBox(height: 20),

                    _buildMultiSelect(
                      title: 'Selecciona EPP Requerido:',
                      options: _availableEpp,
                      selectedList: _selectedEpp,
                    ),

                    const Divider(height: 40, thickness: 2),
                    
                    // BOTÓN GUARDAR
                    ElevatedButton.icon(
                      onPressed: _saveChemical,
                      icon: const Icon(Icons.save),
                      label: const Text('GUARDAR QUÍMICO'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _sdsUrlController.dispose();
    _raVideoUrlController.dispose();
    _procedureController.dispose();
    super.dispose();
  }
}