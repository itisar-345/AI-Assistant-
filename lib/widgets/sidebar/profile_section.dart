import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final bool isCollapsed;

  const ProfileSection({
    super.key,
    required this.isCollapsed,
  });

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sync Data'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showProfileOptions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: isCollapsed 
              ? MainAxisAlignment.center 
              : MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isCollapsed ? 14 : 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name',
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'user@example.com',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}