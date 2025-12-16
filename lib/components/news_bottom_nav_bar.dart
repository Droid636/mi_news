import 'package:flutter/material.dart';
import '../app_theme.dart';

class NewsBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const NewsBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppTheme.navBackground,
      selectedItemColor: AppTheme.navSelected,
      unselectedItemColor: AppTheme.navUnselected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 0
                ? AppTheme.navIconSelected
                : AppTheme.navIconUnselected,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark,
            color: currentIndex == 1
                ? AppTheme.navIconSelected
                : AppTheme.navIconUnselected,
          ),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.category,
            color: currentIndex == 2
                ? AppTheme.navIconSelected
                : AppTheme.navIconUnselected,
          ),
          label: 'Categorías',
        ),
      ],
    );
  }
}
