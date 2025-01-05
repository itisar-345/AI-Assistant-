import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/navigation_provider.dart';

class NavItems extends ConsumerWidget {
  const NavItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    Theme.of(context);

    return ListView(
      shrinkWrap: true,
      children: [
        _buildNavItem(
          context: context,
          icon: Icons.home,
          title: 'Home',
          isSelected: selectedTab == 0,
          onTap: () => ref.read(selectedTabProvider.notifier).state = 0,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.task,
          title: 'Tasks',
          isSelected: selectedTab == 1,
          onTap: () => ref.read(selectedTabProvider.notifier).state = 1,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.favorite,
          title: 'Health',
          isSelected: selectedTab == 2,
          onTap: () => ref.read(selectedTabProvider.notifier).state = 2,
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected ? theme.colorScheme.primary : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        selected: isSelected,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}