import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../components/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Recientes')),
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          if (provider.status == PostStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.status == PostStatus.error) {
            return Center(child: Text('Error: \\${provider.errorMessage}'));
          } else if (provider.status == PostStatus.empty) {
            return const Center(child: Text('No hay noticias.'));
          }
          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: provider.posts[index]);
            },
          );
        },
      ),
    );
  }
}
