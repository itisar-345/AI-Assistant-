import 'package:flutter/material.dart';
import 'top_nav_bar.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final bool isSidebarOpen;
  final TabController tabController;
  final bool showTopNavBar;

  const AppHeader({
    super.key,
    required this.onMenuPressed,
    required this.isSidebarOpen,
    required this.tabController,
    this.showTopNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSidebarOpen ? Icons.menu_open : Icons.menu,
            key: ValueKey(isSidebarOpen),
          ),
        ),
        onPressed: onMenuPressed,
        tooltip: isSidebarOpen ? 'Close menu' : 'Open menu',
      ),
      title: Row(
        children: [
          const Icon(Icons.psychology, size: 24),
          const SizedBox(width: 12),
          Text(
            'Blair',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      bottom: showTopNavBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: TopNavBar(controller: tabController),
            )
          : null, // Hide TopNavBar if `showTopNavBar` is false
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);
}