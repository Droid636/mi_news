import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import 'dart:convert';

class BookmarksProvider extends ChangeNotifier {
  static const _key = 'bookmarked_posts';
  List<Post> _bookmarks = [];
  List<Post> get bookmarks => _bookmarks;

  BookmarksProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    _bookmarks = data.map((e) => Post.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }

  Future<void> addBookmark(Post post) async {
    if (!_bookmarks.any((p) => p.id == post.id)) {
      _bookmarks.add(post);
      await _save();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(Post post) async {
    _bookmarks.removeWhere((p) => p.id == post.id);
    await _save();
    notifyListeners();
  }

  bool isBookmarked(Post post) {
    return _bookmarks.any((p) => p.id == post.id);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _bookmarks.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, data);
  }
}
