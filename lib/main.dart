import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const MyApp());
}


@JsonSerializable()
class Favorites {
  List<String> titles;

  Favorites({required this.titles});

  factory Favorites.fromJson(Map<String, dynamic> json) =>
      _$FavoritesFromJson(json);
  Map<String, dynamic> toJson() => _$FavoritesToJson(this);
}


/// MyApp 是一个无状态的小部件，用于初始化应用程序的根。
class MyApp extends StatelessWidget {
  /// MyApp 构造函数
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新闻1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewsPage(title: '新闻1'),
    );
  }
}

// 新闻列表组件
class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.title});

  /// 标题
  final String title;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

// 新闻列表状态
class _NewsPageState extends State<NewsPage> {
  List<dynamic> _news = [];
  List<String> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
    loadFavorites().then((loadedFavorites) {
      setState(() {
        _favorites = loadedFavorites;
      });
    });
  }

  // 异步加载新闻数据
  Future<void> _loadNews() async {
    await Future.delayed(const Duration(seconds: 1));
    final String response = await rootBundle.loadString('assets/news.json');
    final data = await json.decode(response);
    setState(() {
      _news = data['articles'];
    });
  }

  // 保存收藏列表
  Future<void> saveFavorites(List<String> favorites) async {
    if (kIsWeb) {
      // 兼容web环境，便于使用 chrome 调试
      html.window.localStorage['favorites'] = json.encode(favorites);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/favorites.json');
      final favoritesModel = Favorites(titles: favorites);
      await file.writeAsString(json.encode(favoritesModel.toJson()));
    }
  }

  // 加载收藏列表
  Future<List<String>> loadFavorites() async {
    if (kIsWeb) {
      String? favoritesStr = html.window.localStorage['favorites'];
      if (favoritesStr != null) {
        return List<String>.from(json.decode(favoritesStr));
      }
      return [];
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/favorites.json');
      if (await file.exists()) {
        String contents = await file.readAsString();
        final favoritesModel = Favorites.fromJson(json.decode(contents));
        return favoritesModel.titles;
      }
      return [];
    }
  }

  // 切换收藏状态
  void _toggleFavorite(String title) {
    setState(() {
      if (_favorites.contains(title)) {
        _favorites.remove(title);
      } else {
        _favorites.add(title);
      }
      saveFavorites(_favorites);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
          )
        ],
      ),
      body: _news.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _news.length,
              itemBuilder: (context, index) {
                final article = _news[index];
                final isFavorite = _favorites.contains(article['title']);
                return ListTile(
                  title: Text(article['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    article['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                    onPressed: () => _toggleFavorite(article['title']),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          _loadNews().then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        },
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Icon(Icons.refresh),
      ),
    );
  }
}
