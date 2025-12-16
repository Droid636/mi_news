import 'package:flutter/material.dart';

class AppTheme {
  // =====================
  // Colores de navegación (BottomNavigationBar)
  // =====================
  static const Color navBackground = Color(0xFF1A2236); // azul oscuro uniforme
  static const Color navSelected = Color(0xFF3578C6); // azul principal
  static const Color navUnselected = Color(
    0xFF8CA6C6,
  ); // azul grisáceo para mejor contraste
  static const Color navIconSelected = navSelected;
  static const Color navIconUnselected = navUnselected;

  // =====================
  // Colores del SplashScreen
  // =====================
  static const Color splashBackgroundTop = navBackground;
  static const Color splashBackgroundBottom = navSelected;
  static const Color splashArc = Color(0xFF4FC3F7); // azul claro para acento
  static const Color splashLogoWhite = Colors.white;
  static const Color splashLogoGlow = Color(0xFFB2E6FF);
  static const Color splashText = Colors.white;
  static const Color splashSubtitle = Color(0xFFB2E6FF);

  // =====================
  // Colores del Buscador
  // =====================
  static const Color searchBackground = Color(0xFFF3F6FA); // fondo más neutro
  static const Color searchBorder = Color(0xFFD1D9E6); // borde más suave
  static const Color searchIconBg = navSelected;
  static const Color searchIconColor = Colors.white;
  static const Color searchHint = navUnselected;

  // =====================
  // Colores de Categorías
  // =====================
  static const Color categoryBackground = Color(0xFFF3F6FA); // fondo general
  static const Color categoryChipBackground = Colors.white; // chip normal
  static const Color categoryChipBorder = Color(0xFFD1D9E6); // borde chip
  static const Color categoryChipText = navBackground; // texto chip

  // Chip seleccionado
  static const Color categorySelectedGradientStart = navSelected; // azul rey
  static const Color categorySelectedGradientEnd = navBackground; // azul oscuro
  static const Color categorySelectedText = Colors.white;
  static const Color categorySelectedShadow = Color(0x223578C6); // sombra suave

  // =====================
  // Colores de Bookmarks
  // =====================
  static const Color bookmarksBackground = categoryBackground;
  static const Color bookmarksCard = Colors.white;
  static const Color bookmarksTitle = navBackground;
  static const Color bookmarksSubtitle = navSelected;
  static const Color bookmarksEmptyIcon = Color(0xFF8CA6C6); // azul grisáceo

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
