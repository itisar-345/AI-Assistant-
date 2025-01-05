import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/health/mood_tracker.dart';
import '../../widgets/health/health_summary.dart';

class HealthTab extends ConsumerWidget {
  const HealthTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'Mood'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                HealthSummary(),
                MoodTracker(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}