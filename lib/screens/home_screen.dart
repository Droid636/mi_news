import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

import '../components/post_card.dart';

import '../components/news_search_bar.dart';
import '../components/news_bottom_nav_bar.dart';
import 'bookmarks_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Recientes')),
      drawer: NewsDrawer(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          Navigator.pop(context);
          if (index == 1) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BookmarksScreen()));
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
      body: Column(
        children: [
          NewsSearchBar(
            onSearch: (query) {
              _lastSearch = query;
              Provider.of<PostProvider>(
                context,
                listen: false,
              ).fetchPosts(refresh: true, search: query);
            },
            initialValue: _lastSearch,
          ),
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, provider, _) {
                if (provider.status == PostStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.status == PostStatus.error) {
                  return Center(
                    child: Text('Error: \\${provider.errorMessage}'),
                  );
                } else if (provider.status == PostStatus.empty) {
                  return const Center(child: Text('No hay noticias.'));
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
      ),
    );
  }
}
