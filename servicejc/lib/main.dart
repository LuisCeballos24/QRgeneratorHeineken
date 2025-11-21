import 'package:flutter/material.dart';
// Importación de la pantalla de escáner (asumiendo ruta local)
import 'screens/chemical_scanner_screen.dart'; 

// Importación del tema (asumiendo ruta local)
import 'theme/app_theme.dart';

// Paquetes necesarios para internacionalización
import 'package:flutter_localizations/flutter_localizations.dart';
// Si necesitas formatos de fecha/hora específicos, descomenta la siguiente línea y el código en main:
// import 'package:intl/date_symbol_data_local.dart'; 

// Función principal
void main() {
  // Si deseas inicializar formatos de fecha específicos, descomenta y ajusta:
  // WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting('es', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema 5S Químicos Heineken', // Título ajustado al proyecto
      debugShowCheckedModeBanner: false,
      
      // Aplicamos el tema
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Usamos el tema oscuro, ideal para entornos industriales

      // CONFIGURACIÓN DE LOCALIZACIÓN
      localizationsDelegates: const [
        // Delega la localización de Material Design
        GlobalMaterialLocalizations.delegate,
        // Delega la localización de Widgets (dirección de texto, etc.)
        GlobalWidgetsLocalizations.delegate,
        // Delega la localización de Cupertino (para iOS look)
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español (Necesario para el formato de fecha y texto)
      ],

      // CLAVE: Establecemos la pantalla del escáner como la pantalla de inicio
      home: const ChemicalScannerScreen(), 
      
      // NOTA: Se eliminan las rutas no existentes (LoginScreen, etc.) ya que no tenemos esos archivos.
      routes: {
        // Si necesitas otras rutas, agrégalas aquí una vez creadas.
        // '/scanner': (context) => const ChemicalScannerScreen(),
      },
    );
  }
}