import 'dart:convert';
import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/tasks.json');
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await localFile;
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List<dynamic>;
      return jsonData
          .map((task) => Task.fromJson(task as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<File> saveTasks(List<Task> tasks) async {
    final file = await localFile;
    return file
        .writeAsString(jsonEncode(tasks.map((task) => task.toJson()).toList()));
  }
}
