import 'package:flutter/material.dart';
import 'navigation/main_wraper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Make sure to import your wrapper file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MineralReceiptsApp());
}

class MineralReceiptsApp extends StatelessWidget {
  const MineralReceiptsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mineral Receipts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F57A6)),
        useMaterial3: true,
      ),
      // Set MainWrapper as the home screen here:
      home: const MainWrapper(),
    );
  }
}
