import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import 'post_detail_modal.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarks_provider.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(post.date);

    return Consumer<BookmarksProvider>(
      builder: (context, bookmarksProvider, _) {
        final isBookmarked = bookmarksProvider.isBookmarked(post);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            leading: post.featuredImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      post.featuredImage!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  )
                : const Icon(Icons.image, size: 40),
            title: Text(post.title),
            subtitle: Text('Publicado: $dateStr'),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.amber : null,
              ),
              onPressed: () {
                if (isBookmarked) {
                  bookmarksProvider.removeBookmark(post);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Eliminado de favoritos.')),
                  );
                } else {
                  bookmarksProvider.addBookmark(post);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agregado a favoritos.')),
                  );
                }
              },
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => PostDetailModal(post: post),
              );
            },
          ),
        );
      },
    );
  }
}
