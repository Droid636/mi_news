import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../components/post_card.dart';
import '../components/news_search_bar.dart';
import '../components/news_bottom_nav_bar.dart';
import 'bookmarks_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;
  String? _lastSearch;
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
      _initialized = true;
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            // Imagen centrada
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/news_header.jpg',
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Título centrado
            Center(
              child: Text(
                'Mi News',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Subtítulo centrado
            Center(
              child: Text(
                'Noticias relevantes y actuales',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Buscador
            NewsSearchBar(
              initialValue: _lastSearch,
              onSearch: (query) {
                _lastSearch = query;
                Provider.of<PostProvider>(
                  context,
                  listen: false,
                ).fetchPosts(refresh: true, search: query);
              },
            ),
            const SizedBox(height: 18),
            // Lista de posts
            Consumer<PostProvider>(
              builder: (context, provider, _) {
                if (provider.status == PostStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.status == PostStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.errorMessage ?? 'Error desconocido'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<PostProvider>(
                              context,
                              listen: false,
                            ).fetchPosts(refresh: true, search: _lastSearch);
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                if (provider.posts.isEmpty) {
                  return Center(
                    child: Text(
                      _lastSearch != null && _lastSearch!.isNotEmpty
                          ? 'No se encontraron noticias para "${_lastSearch!}".'
                          : 'No hay noticias disponibles.',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: provider.posts[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarksTab() => const BookmarksScreen();
  Widget _buildCategoriesTab() => const CategoriesScreen();

  @override
  Widget build(BuildContext context) {
    final body = switch (_selectedIndex) {
      0 => _buildHomeTab(),
      1 => _buildBookmarksTab(),
      2 => _buildCategoriesTab(),
      _ => _buildHomeTab(),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Recientes')),
      body: body,
      bottomNavigationBar: NewsBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
