import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/news_service.dart';

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
      } else {
        _posts.addAll(newPosts);
      }
      _hasMore = newPosts.length == 10;
      _status = _posts.isEmpty ? PostStatus.empty : PostStatus.success;
      _page++;
    } catch (e) {
      _errorMessage = e.toString();
      _status = PostStatus.error;
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
