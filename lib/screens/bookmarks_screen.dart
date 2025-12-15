import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí se mostrarán los posts guardados como bookmarks
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: const Center(
        child: Text('Aquí aparecerán tus noticias guardadas.'),
      ),
    );
  }
}
