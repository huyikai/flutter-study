import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('任务管理')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Checkbox(
              value: task.completed,
              onChanged: (bool? value) {
                ref.read(taskProvider.notifier).toggleComplete(task.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加任务逻辑
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
