import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/chemicals_list_screen_state.dart';
import 'firebase_options.dart'; // <--- 1. AGREGA ESTA LÍNEA

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. MODIFICA ESTE BLOQUE ASÍ:
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seguridad Química',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ChemicalsListScreen(),
    );
  }
}