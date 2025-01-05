import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../utils/notification_helper.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    // Sort tasks by due date, showing tasks with less time left first
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListTile(task: task);
      },
    );
  }
}

class TaskListTile extends ConsumerWidget {
  final Task task;
  final NotificationHelper notificationHelper = NotificationHelper();

  TaskListTile({super.key, required this.task});

  String _getTimeRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days remaining';
    } else {
      final hours = (difference.inHours % 24).toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      return '$hours:$minutes hours remaining';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (_) {
            final updatedTask = task.copyWith(
              status: task.status == TaskStatus.completed
                  ? TaskStatus.pending
                  : TaskStatus.completed,
            );
            ref.read(taskProvider.notifier).updateTask(updatedTask);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description ?? 'No description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${task.dueDate.month}/${task.dueDate.day}/${task.dueDate.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Text(
                  _getTimeRemaining(task.dueDate),
                  style: TextStyle(
                    color: task.dueDate.isBefore(DateTime.now())
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (task.reminderTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            ref.read(taskProvider.notifier).deleteTask(task.id);
          },
        ),
      ),
    );
  }
}
