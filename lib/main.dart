import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier();
});

class NewsState {
  final bool isLoading;
  final List<dynamic> news;
  final String category;
  final String searchQuery;

  NewsState({
    this.isLoading = false,
    this.news = const [],
    this.category = 'general',
    this.searchQuery = '',
  });

  NewsState copyWith({
    bool? isLoading,
    List<dynamic>? news,
    String? category,
    String? searchQuery,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      news: news ?? this.news,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(NewsState()) {
    fetchNews();
  }

  Future<void> fetchNews() async {
    state = state.copyWith(isLoading: true);
    final response = await http.get(
      Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=${state.category}&q=${state.searchQuery}&apiKey=YOUR_API_KEY',
      ),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    state = state.copyWith(
      isLoading: false,
      news: data['articles'] as List<dynamic>,
    );
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
    fetchNews();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchNews();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: '新闻2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewsPage(),
    );
  }
}

class NewsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('新闻'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog<AlertDialog>(
                context: context,
                builder: (context) => SearchDialog(),
              );
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                final article = state.news[index];
                return ListTile(
                  title: Text(article['title'].toString()),
                  subtitle: Text(article['description'].toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class SearchDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('搜索新闻'),
      content: TextField(
        onSubmitted: (value) {
          ref.read(newsProvider.notifier).setSearchQuery(value);
          Navigator.pop(context);
        },
        decoration: InputDecoration(
          hintText: '输入关键词',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
      ],
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final dynamic article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'].toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(article['urlToImage'].toString()),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(article['content'].toString()),
            ),
          ],
        ),
      ),
    );
  }
}
