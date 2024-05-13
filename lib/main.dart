import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

/// MyApp 是一个无状态的小部件，用于初始化应用程序的根。
class MyApp extends StatelessWidget {
  /// MyApp 构造函数
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub 仓库搜索',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RepositorySearchPage(),
    );
  }
}

// 状态组件
class RepositorySearchPage extends StatefulWidget {
  const RepositorySearchPage({super.key});

  @override
  State<RepositorySearchPage> createState() => _RepositorySearchPageState();
}

// 状态管理
class _RepositorySearchPageState extends State<RepositorySearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  // 搜索方法
  Future<void> _searchRepositories() async {
    final response = await http.get(
      Uri.parse(
        'https://api.github.com/search/repositories?q=${_controller.text}',
      ),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _searchResults =
            List<Map<String, dynamic>>.from(data['items'] as List<dynamic>);
      });
    } else {
      throw Exception('Failed to load repository data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub 仓库搜索'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '请输入要搜索的仓库名称',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) => _searchRepositories(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _searchResults[index]['name'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _searchResults[index]['description'].toString(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<RepositoryDetailPage>(
                        builder: (context) => RepositoryDetailPage(
                          repository: _searchResults[index],
                        ),
                      ),
                    );
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

// 仓库详细信息页面的无状态组件
class RepositoryDetailPage extends StatelessWidget {
  const RepositoryDetailPage({
    required this.repository,
    super.key,
  });

  final Map<String, dynamic> repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repository['name'].toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '仓库名: ${repository['full_name']}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Stars: ${repository['stargazers_count']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Forks: ${repository['forks_count']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Open Issues: ${repository['open_issues_count']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${repository['description']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Repository URL: ${repository['html_url']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
