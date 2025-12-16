import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarks_provider.dart';
import '../components/post_card.dart';
import '../app_theme.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Favoritos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<BookmarksProvider>(
          builder: (context, bookmarksProvider, _) {
            final bookmarks = bookmarksProvider.bookmarks;
            if (bookmarks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: AppTheme.bookmarksEmptyIcon,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aquí aparecerán tus noticias guardadas.',
                      style: TextStyle(
                        color: AppTheme.splashBackgroundTop,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Guarda tus artículos favoritos para leerlos después!',
                      style: TextStyle(
                        color: AppTheme.navSelected,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return PostCard(post: bookmarks[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
