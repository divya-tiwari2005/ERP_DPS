import 'dart:async';
import 'package:flutter/material.dart';
import '../Services/storage_service.dart';
import 'auth/login__screens.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final token = await StorageService.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Splash background
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_background.png',
                fit: BoxFit.cover,
              ),
            ),

            // Logo + tagline
            Align(
              alignment: const Alignment(0, -0.18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.60,
                    child: Image.asset(
                      'assets/images/school_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Pathway to Wisdom',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Color(0xFF087F70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}