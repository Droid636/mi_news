import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../components/post_card.dart';
import '../components/news_search_bar.dart';
import '../components/news_bottom_nav_bar.dart';
import 'bookmarks_screen.dart';
import 'categories_screen.dart';
import '../app_theme.dart';

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

  // ---------------- HOME TAB ----------------
  Widget _buildHomeTab() {
    return Container(
      color: AppTheme.splashBackgroundTop.withOpacity(0.03),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              // Título
              Text(
                'NovaExpress',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bookmarksTitle,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Subtítulo
              Text(
                'Noticias relevantes y actuales',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.bookmarksSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              // 🔍 Buscador (ANTES de la imagen)
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
              const SizedBox(height: 14),
              // 🖼 Imagen header
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/news_header.jpg',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // 📰 Lista de noticias
              Consumer<PostProvider>(
                builder: (context, provider, _) {
                  if (provider.status == PostStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (provider.status == PostStatus.error) {
                    return Column(
                      children: [
                        Text(
                          provider.errorMessage ?? 'Error desconocido',
                          style: TextStyle(color: AppTheme.navSelected),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.navSelected,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Provider.of<PostProvider>(
                              context,
                              listen: false,
                            ).fetchPosts(refresh: true, search: _lastSearch);
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    );
                  }
                  if (provider.posts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        _lastSearch != null && _lastSearch!.isNotEmpty
                            ? 'No se encontraron noticias para "${_lastSearch!}".'
                            : 'No hay noticias disponibles.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.navUnselected,
                        ),
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TABS ----------------
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
      appBar: null,
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
