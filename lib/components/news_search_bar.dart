import 'package:flutter/material.dart';

class NewsSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final String? initialValue;
  const NewsSearchBar({super.key, required this.onSearch, this.initialValue});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar noticias...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
      ),
    );
  }
}
