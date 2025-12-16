import 'package:flutter/material.dart';

class AppTheme {
  // =====================
  // Colores de navegación (BottomNavigationBar)
  // =====================
  static const Color navBackground = Color(0xFF141A32);
  static const Color navSelected = Color(0xFF3578C6);
  static const Color navUnselected = Color(0xFFB0B8C1);
  static const Color navIconSelected = Color(0xFF3578C6);
  static const Color navIconUnselected = Color(0xFFB0B8C1);

  // =====================
  // Colores del SplashScreen
  // =====================
  static const Color splashBackgroundTop = Color(0xFF141A32);
  static const Color splashBackgroundBottom = Color(0xFF22306C);
  static const Color splashArc = Color(0xFF1EC6FF);
  static const Color splashLogoWhite = Colors.white;
  static const Color splashLogoGlow = Color(0xFFB2E6FF);
  static const Color splashText = Colors.white;
  static const Color splashSubtitle = Color(0xFFB2E6FF);

  // =====================
  // Colores del Buscador
  // =====================
  static const Color searchBackground = Color(0xFFF6FAFD);
  static const Color searchBorder = Color(0xFFE0E6ED);
  static const Color searchIconBg = Color(0xFF3578C6);
  static const Color searchIconColor = Colors.white;
  static const Color searchHint = Color(0xFFB0B8C1);

  // =====================
  // Colores de Categorías
  // =====================
  static const Color categoryBackground = Color(0xFFF6FAFD); // fondo general
  static const Color categoryChipBackground = Colors.white; // chip normal
  static const Color categoryChipBorder = Color(0xFFE0E6ED); // borde chip
  static const Color categoryChipText = Color(0xFF22306C); // texto chip

  // Chip seleccionado
  static const Color categorySelectedGradientStart = Color(
    0xFF3578C6,
  ); // azul rey
  static const Color categorySelectedGradientEnd = Color(
    0xFF22306C,
  ); // azul oscuro
  static const Color categorySelectedText = Colors.white;
  static const Color categorySelectedShadow = Color(0x223578C6); // sombra suave

  // =====================
  // Colores de Bookmarks
  // =====================
  static const Color bookmarksBackground = Color(0xFFF6FAFD);
  static const Color bookmarksCard = Colors.white;
  static const Color bookmarksTitle = Color(0xFF22306C);
  static const Color bookmarksSubtitle = Color(0xFF3578C6);
  static const Color bookmarksEmptyIcon = Color.fromARGB(255, 133, 182, 237);

  // =====================
  // ThemeData base (opcional)
  // =====================
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: categoryBackground,
      primaryColor: navSelected,
      fontFamily: 'Roboto',
    );
  }
}
