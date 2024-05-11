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
      title: '待办事项列表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

// 待办事项页面的状态组件
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

// 待办事项页面的状态管理
class _TodoListPageState extends State<TodoListPage> {
  final List<String> _todos = []; // 待办事项列表
  final TextEditingController _textController =
      TextEditingController(); // 文本输入控制器
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // 表单的全局键

  // 修改待办事项的方法
  void _modifyTodoItem({String? newTask, int? index, bool isRemove = false}) {
    if (isRemove) {
      setState(() => _todos.removeAt(index!));
    } else {
      // 验证表单
      if (_formKey.currentState!.validate()) {
        setState(() {
          if (index != null) {
            _todos[index] = newTask!;
          } else {
            _todos.add(newTask!);
          }
          _textController.clear();
        });
      }
    }
  }

  // 构建待办事项列表的视图
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_todos[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 编辑待办事项
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showDialog(context, index),
              ),
              // 删除待办事项
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _modifyTodoItem(index: index, isRemove: true),
              ),
            ],
          ),
        );
      },
    );
  }

  // 显示编辑或添加待办事项的对话框
  void _showDialog(BuildContext context, int? index) {
    final isEdit = index != null;
    if (isEdit) {
      _textController.text = _todos[index];
    } else {
      _textController.clear();
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? '编辑待办事项' : '添加待办事项'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _textController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入待办事项';
                }
                if (_todos.contains(value) &&
                    (!isEdit || _todos[index] != value)) {
                  return '待办事项已存在';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(isEdit ? '保存' : '添加'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _modifyTodoItem(newTask: _textController.text, index: index);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待办事项列表'),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context, null),
        tooltip: '添加待办事项',
        child: const Icon(Icons.add),
      ),
    );
  }
}
