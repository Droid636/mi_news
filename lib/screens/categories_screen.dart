import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post.dart';
import '../components/post_card.dart';
import '../app_theme.dart';

class Category {
  final int id;
  final String name;
  Category({required this.id, required this.name});
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://news.freepi.io/wp-json/wp/v2/'),
  );
  List<Category> _categories = [];
  List<Post> _posts = [];
  int? _selectedCategoryId;
  bool _loadingCategories = true;
  bool _loadingPosts = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loadingCategories = true;
      _error = null;
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
      _error = 'Error al cargar categorías';
    }
    setState(() {
      _loadingCategories = false;
    });
  }

  Future<void> _fetchPosts(int categoryId) async {
    setState(() {
      _loadingPosts = true;
      _error = null;
      _posts = [];
    });
    final cacheKey = 'cat_posts_[0m$categoryId';
    try {
      final response = await _dio.get(
        'posts',
        queryParameters: {
          'categories': categoryId,
          '_embed': 1,
          'per_page': 10,
        },
      );
      final List data = response.data;
      _posts = data
          .map(
            (json) => Post.fromJson({
              'id': json['id'],
              'title': json['title']?['rendered'] ?? '',
              'excerpt': json['excerpt']?['rendered'] ?? '',
              'content': json['content']?['rendered'] ?? '',
              'link': json['link'] ?? '',
              'date': json['date'],
              'featuredImage':
                  json['_embedded']?['wp:featuredmedia'] != null &&
                      (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty
                  ? json['_embedded']['wp:featuredmedia'][0]['source_url']
                  : null,
              'categories': (json['categories'] as List?)
                  ?.map((e) => e.toString())
                  .toList(),
            }),
          )
          .toList();
      // Guardar cache
      final prefs = await SharedPreferences.getInstance();
      final dataCache = _posts.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(cacheKey, dataCache);
    } catch (e) {
      // Leer cache si hay error
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getStringList(cacheKey) ?? [];
      if (cached.isNotEmpty) {
        _posts = cached.map((e) => Post.fromJson(jsonDecode(e))).toList();
        _error = 'Sin conexión. Mostrando noticias guardadas.';
      } else {
        _error = 'No hay conexión y no hay noticias guardadas.';
      }
    }
    setState(() {
      _loadingPosts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.splashBackgroundTop,
            AppTheme.splashBackgroundBottom,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bookmarksTitle,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final selected = cat.id == _selectedCategoryId;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = cat.id;
                        });
                        _fetchPosts(cat.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? LinearGradient(
                                  colors: [
                                    AppTheme.navSelected,
                                    AppTheme.splashBackgroundBottom,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: selected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: selected
                                ? AppTheme.navSelected
                                : AppTheme.searchBorder,
                            width: selected ? 2.2 : 1.2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.navSelected.withOpacity(
                                      0.13,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          cat.name,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppTheme.bookmarksTitle,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _loadingPosts
                    ? const Center(child: CircularProgressIndicator())
                    : _posts.isEmpty && _selectedCategoryId != null
                    ? Center(
                        child: Text(
                          _error ?? 'No hay noticias en esta categoría.',
                          style: TextStyle(color: AppTheme.navUnselected),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return PostCard(post: post);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
