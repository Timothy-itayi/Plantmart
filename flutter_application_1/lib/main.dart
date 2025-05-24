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
        title: 'Plant Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const PlantStoreScreen(),
      ),
    );
  }
}
