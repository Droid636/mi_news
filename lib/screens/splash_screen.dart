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
            // Arco superior
            const CustomPaint(size: Size(180, 60), painter: _ArcPainter()),
            SizedBox(height: 8),
            // Logo de noticiero como imagen
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            SizedBox(height: 16),
            Text(
              'NovaPress',
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

// Dibuja el arco superior tipo Disney+
class _ArcPainter extends CustomPainter {
  const _ArcPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.splashArc, AppTheme.splashLogoWhite],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, 3.14, -3.14, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
