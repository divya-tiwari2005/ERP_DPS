import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';

void main() {
  runApp(const SchoolERPApp());
}

class SchoolERPApp extends StatelessWidget {
  const SchoolERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School ERP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F70),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}