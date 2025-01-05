import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopNavBar extends ConsumerWidget {
  final TabController controller;

  const TopNavBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: const [
          Tab(icon: Icon(Icons.chat), text: 'Chat'),
          Tab(icon: Icon(Icons.task), text: 'Tasks'),
          Tab(icon: Icon(Icons.health_and_safety), text: 'Health'),
        ],
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurface,
        indicatorColor: theme.colorScheme.primary,
      ),
    );
  }
}