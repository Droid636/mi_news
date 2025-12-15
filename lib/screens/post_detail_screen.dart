import 'package:flutter/material.dart';
import '../models/post.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.featuredImage != null)
          Center(
            child: Image.network(
              post.featuredImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
            ),
          ),
        const SizedBox(height: 16),
        Text(post.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        HtmlWidget(post.content),
        const SizedBox(height: 16),
        Text('Publicado: \\${post.date.toLocal()}'),
      ],
    );
  }
}
