import 'package:flutter/material.dart';

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
      title: 'Study Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Study Flutter'),
    );
  }
}

/// MyHomePage 是一个有状态的小部件，用于显示主页。
class MyHomePage extends StatefulWidget {
  /// MyHomePage 构造函数
  const MyHomePage({required this.title, super.key});

  /// 标题
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('该项目为学习 Flutter 而创建， '
            '当前的 `main` 分支提供了基本的项目结构。 '
            '学习内容共有 8 个 `Issue`， '
            '每个 `Issue` 将会在一个独立分支中进行开发。 '
            '请切换分支查看所有 `Issue`。'),
      ),
    );
  }
}
