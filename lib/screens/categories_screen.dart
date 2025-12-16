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

  // ===============================
  // OBTENER CATEGORÍAS
  // ===============================
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
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
        _fetchPosts(_selectedCategoryId!);
      }
    });
  }

  // ===============================
  // OBTENER POSTS POR CATEGORÍA
  // ===============================
  Future<void> _fetchPosts(int categoryId) async {
    setState(() {
      _loadingPosts = true;
      _error = null;
      _posts.clear();
    });

    final cacheKey = 'cat_posts_$categoryId';

    try {
      final response = await _dio.get(
        'posts',
        queryParameters: {
          if (categoryId != -1) 'categories': categoryId,
          '_embed': 1,
          'per_page': 10,
        },
      );

      final List data = response.data;

      _posts = data.map((json) {
        return Post.fromJson({
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
        });
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      final cache = _posts.map((post) => jsonEncode(post.toJson())).toList();

      await prefs.setStringList(cacheKey, cache);
    } catch (e) {
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

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    if (_loadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _categories.isEmpty) {
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
          child: Center(
            child: Text(
              _error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // TÍTULO
            // ===============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Center(
                child: Text(
                  'Categorías',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ===============================
            // CHIPS DE CATEGORÍAS
            // ===============================
            SizedBox(
              height: 54,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = cat.id == _selectedCategoryId;

                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategoryId = cat.id;
                      });
                      _fetchPosts(cat.id);
                    },
                    selectedColor: AppTheme.navSelected,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.bookmarksTitle,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: selected
                            ? AppTheme.navSelected
                            : AppTheme.searchBorder,
                        width: selected ? 2 : 1,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ===============================
            // LISTA DE NOTICIAS
            // ===============================
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _loadingPosts
                    ? const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(),
                      )
                    : _posts.isEmpty && _selectedCategoryId != null
                    ? Center(
                        key: ValueKey('empty'),
                        child: Text(
                          _error ?? 'No hay noticias en esta categoría.',
                          style: TextStyle(color: AppTheme.navUnselected),
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey('list_${_selectedCategoryId ?? 'none'}'),
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(post: _posts[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
