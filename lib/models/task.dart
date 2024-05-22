import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
