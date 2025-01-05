import 'package:flutter/material.dart';
import '../chat_screen.dart';
import 'tasks_tab.dart';
import 'health_tab.dart';

class TabContent extends StatelessWidget {
  final int selectedIndex;

  const TabContent({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildContent(selectedIndex),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return const ChatScreen(key: ValueKey('chat'));
      case 1:
        return const TasksTab(key: ValueKey('tasks'));
      case 2:
        return const HealthTab(key: ValueKey('health'));
      default:
        return const SizedBox.shrink();
    }
  }
}