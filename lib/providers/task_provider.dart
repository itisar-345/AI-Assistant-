import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void updateTask(Task task) {
    state = [
      for (final t in state)
        if (t.id == task.id) task else t
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void toggleTaskStatus(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(
            status: task.status == TaskStatus.completed
                ? TaskStatus.pending
                : TaskStatus.completed,
          )
        else
          task
    ];
  }
}