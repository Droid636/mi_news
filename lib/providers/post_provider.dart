import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum PostStatus { initial, loading, success, empty, error }

class PostProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  PostStatus _status = PostStatus.initial;
  PostStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchPosts({
    bool refresh = false,
    String? search,
    int? categoryId,
  }) async {
    if (refresh) {
      _page = 1;
      _posts = [];
      _hasMore = true;
      _status = PostStatus.loading;
      notifyListeners();
    }
    if (!_hasMore && !refresh) return;
    _status = PostStatus.loading;
    notifyListeners();
    try {
      final newPosts = await _newsService.fetchPosts(
        page: _page,
        perPage: 10,
        search: search,
        categoryId: categoryId,
      );
      if (refresh) {
        _posts = newPosts;
        // Guardar en cache solo si no hay búsqueda ni categoría
        if ((search == null || search.isEmpty) && categoryId == null) {
          final prefs = await SharedPreferences.getInstance();
          final data = newPosts.map((e) => jsonEncode(e.toJson())).toList();
          await prefs.setStringList('cached_posts', data);
        }
      } else {
        _posts.addAll(newPosts);
      }
      _hasMore = newPosts.length == 10;
      _status = _posts.isEmpty ? PostStatus.empty : PostStatus.success;
      _page++;
    } catch (e) {
      // Intentar cargar del cache si es la lista principal
      if ((search == null || search.isEmpty) && categoryId == null) {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getStringList('cached_posts') ?? [];
        if (cached.isNotEmpty) {
          _posts = cached.map((e) => Post.fromJson(jsonDecode(e))).toList();
          _status = PostStatus.success;
          _errorMessage = 'Sin conexión. Mostrando noticias guardadas.';
        } else {
          _errorMessage = 'No hay conexión y no hay noticias guardadas.';
          _status = PostStatus.error;
        }
      } else {
        _errorMessage = e.toString();
        _status = PostStatus.error;
      }
    }
    notifyListeners();
  }

  void reset() {
    _posts = [];
    _page = 1;
    _hasMore = true;
    _status = PostStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
