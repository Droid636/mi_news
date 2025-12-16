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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Contenido principal scrollable
            // Botón cerrar flotante

            // Contenido principal scrollable
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: PostDetailScreen(post: post),
              ),
            ),

            // Botón cerrar flotante
          ],
        ),
      ),
    );
  }
}
