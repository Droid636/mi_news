import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarks_provider.dart';
import '../components/post_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Consumer<BookmarksProvider>(
        builder: (context, bookmarksProvider, _) {
          final bookmarks = bookmarksProvider.bookmarks;
          if (bookmarks.isEmpty) {
            return const Center(
              child: Text('Aquí aparecerán tus noticias guardadas.'),
            );
          }
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return PostCard(post: bookmarks[index]);
            },
          );
        },
      ),
    );
  }
}
