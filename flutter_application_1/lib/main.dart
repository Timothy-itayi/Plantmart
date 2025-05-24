import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/plant_store_screen.dart';
import 'package:flutter/services.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize platform channels
    const platform = MethodChannel('plugins.flutter.io/path_provider');
    await platform.invokeMethod('getTemporaryDirectory');
  } catch (e) {
    print('DEBUG: Plugin initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'Plant Barn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // Deep forest green
            primary: const Color(0xFF2E7D32),
            secondary: const Color(0xFF81C784), // Light green
            tertiary: const Color(0xFF4CAF50), // Medium green
             // Very light green
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF1F8E9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
          ),
        ),
        home: const PlantStoreScreen(),
      ),
    );
  }
}
