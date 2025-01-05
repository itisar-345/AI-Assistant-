import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  final bool isCollapsed;

  const LogoSection({
    super.key,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: isCollapsed 
            ? MainAxisAlignment.center 
            : MainAxisAlignment.start,
        children: [
          const Icon(Icons.psychology, size: 32),
          if (!isCollapsed) ...[
            const SizedBox(width: 16),
            Text(
              'Blair',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}