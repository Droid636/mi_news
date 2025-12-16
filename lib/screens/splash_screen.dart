import 'package:flutter/material.dart';
import '../app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.splashBackgroundTop,
              AppTheme.splashBackgroundBottom,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ...existing code...
            // Logo de noticiero como imagen
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            SizedBox(height: 16),
            Text(
              'NovaExpress',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 40,
                color: AppTheme.splashLogoWhite,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    blurRadius: 16,
                    color: AppTheme.splashLogoGlow,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Subtítulo
            Text(
              'Noticias de impacto global',
              style: TextStyle(
                color: AppTheme.splashSubtitle,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 32),
            // Loader
            CircularProgressIndicator(color: AppTheme.splashLogoGlow),
          ],
        ),
      ),
    );
  }
}

// (Clase _ArcPainter eliminada porque ya no se usa)
