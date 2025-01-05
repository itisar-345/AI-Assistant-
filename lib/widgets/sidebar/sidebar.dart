import 'package:flutter/material.dart';
import 'profile_section.dart';
import 'dynamic_sidebar_content.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;

  const Sidebar({
    super.key,
    this.isCollapsed = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        elevation: 2,
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Expanded(child: DynamicSidebarContent()),
            ProfileSection(isCollapsed: isCollapsed),
          ],
        ),
      ),
    );
  }
}