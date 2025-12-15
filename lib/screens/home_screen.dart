import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

import '../components/post_card.dart';

import '../components/news_search_bar.dart';
import '../components/news_bottom_nav_bar.dart';
import 'bookmarks_screen.dart';
import 'categories_screen.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _categories = [];
  int? _selectedCategoryId;
  bool _loadingCategories = true;
  String? _catError;
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://news.freepi.io/wp-json/wp/v2/'),
  );

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loadingCategories = true;
      _catError = null;
    });
    try {
      final response = await _dio.get(
        'categories',
        queryParameters: {'per_page': 20},
      );
      final List data = response.data;
      _categories = data
          .map((json) => Category(id: json['id'], name: json['name']))
          .toList();
    } catch (e) {
      _catError = 'Error al cargar categorías';
    }
    setState(() {
      _loadingCategories = false;
    });
  }

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
        NewsSearchBar(
          onSearch: (query) {
            _lastSearch = query;
            Provider.of<PostProvider>(context, listen: false).fetchPosts(
              refresh: true,
              search: query,
              categoryId: _selectedCategoryId,
            );
          },
          initialValue: _lastSearch,
        ),
        if (_loadingCategories)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_catError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(child: Text(_catError!)),
          )
        else
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat.id == _selectedCategoryId;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: ChoiceChip(
                    label: Text(cat.name),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategoryId = selected ? null : cat.id;
                      });
                      Provider.of<PostProvider>(
                        context,
                        listen: false,
                      ).fetchPosts(
                        refresh: true,
                        search: _lastSearch,
                        categoryId: selected ? null : cat.id,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: Consumer<PostProvider>(
            builder: (context, provider, _) {
              if (provider.status == PostStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.status == PostStatus.error) {
                return Center(child: Text('Error: \\${provider.errorMessage}'));
              } else if (provider.status == PostStatus.empty) {
                if (_lastSearch != null && _lastSearch!.isNotEmpty) {
                  return const Center(
                    child: Text('No se encontraron noticias para tu búsqueda.'),
                  );
                } else {
                  return const Center(child: Text('No hay noticias.'));
                }
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

  Widget _buildBookmarksTab() {
    return const BookmarksScreen();
  }

  Widget _buildCategoriesTab() {
    return const CategoriesScreen();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = _buildHomeTab();
        break;
      case 1:
        body = _buildBookmarksTab();
        break;
      case 2:
        body = _buildCategoriesTab();
        break;
      default:
        body = _buildHomeTab();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Recientes')),
      body: body,
      bottomNavigationBar: NewsBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
