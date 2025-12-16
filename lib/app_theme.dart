import 'package:flutter/material.dart';

class AppTheme {
  // =====================
  // Colores de navegación (BottomNavigationBar)
  // =====================
  static const Color navBackground = Color(
    0xFF141A32,
  ); // igual que splashBackgroundTop
  static const Color navSelected = Color(0xFF3578C6); // azul rey
  static const Color navUnselected = Color(0xFFB0B8C1); // gris azulado
  static const Color navIconSelected = Color(0xFF3578C6); // azul rey
  static const Color navIconUnselected = Color(0xFFB0B8C1); // gris azulado

  // =====================
  // Colores del SplashScreen
  // =====================
  static const Color splashBackgroundTop = Color(
    0xFF141A32,
  ); // azul oscuro superior
  static const Color splashBackgroundBottom = Color(
    0xFF22306C,
  ); // azul oscuro inferior
  static const Color splashArc = Color(0xFF1EC6FF); // arco degradado
  static const Color splashLogoWhite = Colors.white;
  static const Color splashLogoGlow = Color(0xFFB2E6FF); // brillo
  static const Color splashText = Colors.white;
  static const Color splashSubtitle = Color(0xFFB2E6FF);

  // =====================
  // Colores del Buscador
  // =====================
  static const Color searchBackground = Color(0xFFF6FAFD); // fondo claro
  static const Color searchBorder = Color(0xFFE0E6ED); // borde
  static const Color searchIconBg = Color(0xFF3578C6); // azul icono
  static const Color searchIconColor = Colors.white; // icono lupa
  static const Color searchHint = Color(0xFFB0B8C1); // hint text

  // =====================
  // Colores del HomeScreen
  // =====================
  // (Aquí puedes agregar colores para el home)

  // =====================
  // Colores de Bookmarks
  // =====================
  static const Color bookmarksBackground = Color(0xFFF6FAFD); // fondo claro
  static const Color bookmarksCard = Colors.white; // fondo de tarjeta
  static const Color bookmarksTitle = Color(0xFF22306C); // azul oscuro
  static const Color bookmarksSubtitle = Color(0xFF3578C6); // azul rey
  static const Color bookmarksEmptyIcon = Color.fromARGB(
    255,
    133,
    182,
    237,
  ); // gris azulado

  static ThemeData get lightTheme {
    return ThemeData(
      // Aquí se definirán los colores y estilos globales
      // Esperando instrucciones del usuario
    );
  }
}
