import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/post_detail_screen.dart';

class PostDetailModal extends StatelessWidget {
  final Post post;
  const PostDetailModal({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 16,
                right: 8,
                bottom: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Detalle de noticia',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF22306C),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 28,
                      color: Color(0xFF3578C6),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Cerrar',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E6ED)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: PostDetailScreen(post: post),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
