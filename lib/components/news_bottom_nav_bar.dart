import 'package:flutter/material.dart';

class NewsDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const NewsDrawer({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Mi News',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              onTap(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Bookmarks'),
            selected: selectedIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onTap(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            selected: selectedIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onTap(2);
            },
          ),
        ],
      ),
    );
  }
}
