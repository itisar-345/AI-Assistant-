import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/tasks/task_calendar.dart';
import '../../widgets/tasks/task_list_view.dart';
import '../../widgets/tasks/add_task_fab.dart';

class TasksTab extends ConsumerWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,  // Specify 2 tabs
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(text: 'Calendar'),
            Tab(text: 'Tasks'),
          ],
        ),
        body: const TabBarView(
          children: [
            TaskCalendar(),  
            TaskListView(),   
          ],
        ),
        floatingActionButton: const AddTaskFAB(),
      ),
    );
  }
}