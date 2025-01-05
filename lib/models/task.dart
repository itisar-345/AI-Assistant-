import 'package:uuid/uuid.dart';

enum TaskStatus { pending, completed }

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final DateTime? reminderTime;
  final TaskStatus status;

  Task({
    String? id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.status = TaskStatus.pending,
  }) : id = id ?? const Uuid().v4();

  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? reminderTime,
    TaskStatus? status,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      status: status ?? this.status,
    );
  }
}