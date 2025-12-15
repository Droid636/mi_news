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
    return Column(
      children: [
        /// BUSCADOR
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

        /// LISTA DE POSTS
        Expanded(
          child: Consumer<PostProvider>(
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

              return ListView.builder(
                itemCount: provider.posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: provider.posts[index]);
                },
              );
            },
          ),
        ),
      ],
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
