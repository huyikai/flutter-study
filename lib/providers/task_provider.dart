import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final StorageService storageService = StorageService();

  TaskNotifier() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await storageService.loadTasks();
  }

  void addTask(Task task) {
    state = [...state, task];
    storageService.saveTasks(state);
  }

  void toggleComplete(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          completed: !task.completed,
        );
      }
      return task;
    }).toList();
    storageService.saveTasks(state);
  }
}
