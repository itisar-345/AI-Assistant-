import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/navigation_provider.dart';
import 'chat_history_list.dart';
import 'task_list.dart';
import 'health_list.dart';

class DynamicSidebarContent extends ConsumerWidget {
  const DynamicSidebarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildContent(selectedTab),
    );
  }

  Widget _buildContent(int tab) {
    switch (tab) {
      case 0:
        return const ChatHistoryList();
      case 1:
        return const TaskList();
      case 2:
        return const HealthList();
      default:
        return const SizedBox.shrink();
    }
  }
}