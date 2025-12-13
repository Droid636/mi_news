import 'package:dio/dio.dart';
import '../models/post.dart';

class NewsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://news.freepi.io/wp-json/wp/v2/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Post>> fetchPosts({int page = 1, int perPage = 10, String? search, int? categoryId}) async {
    try {
      final response = await _dio.get('posts', queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null) 'categories': categoryId,
        '_embed': 1, // Para obtener imágenes destacadas y autor
      });
      final List data = response.data;
      return data.map((json) => Post.fromJson(_mapPostJson(json))).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mapea el JSON de WordPress a nuestro modelo Post
  Map<String, dynamic> _mapPostJson(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'title': json['title']?['rendered'] ?? '',
      'excerpt': json['excerpt']?['rendered'] ?? '',
      'content': json['content']?['rendered'] ?? '',
      'link': json['link'] ?? '',
      'date': json['date'],
      'featuredImage': json['_embedded']?['wp:featuredmedia'] != null &&
              (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty
          ? json['_embedded']['wp:featuredmedia'][0]['source_url']
          : null,
      'categories': (json['categories'] as List?)?.map((e) => e.toString()).toList(),
    };
  }
}
