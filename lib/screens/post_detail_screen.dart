import 'package:flutter/material.dart';
import '../models/post.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.featuredImage != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    post.featuredImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 80),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 16,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close_rounded,
                          size: 26,
                          color: Color(0xFF3578C6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (post.featuredImage != null) const SizedBox(height: 18),
          Text(
            post.title,
            style: const TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFF22306C),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFF3578C6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          HtmlWidget(
            post.content,
            textStyle: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 17,
              color: Color(0xFF222222),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Publicado: ${post.date.day}/${post.date.month}/${post.date.year}',
              style: const TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 13,
                color: Color(0xFF3578C6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
