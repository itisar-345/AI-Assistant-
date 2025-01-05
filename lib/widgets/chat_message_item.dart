import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../providers/speech_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessageItem extends ConsumerWidget {
  final ChatMessage message;

  const ChatMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final speechService = ref.read(speechServiceProvider);

    return Card(
      color: isUser ? theme.colorScheme.primaryContainer : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isUser ? Icons.person : Icons.smart_toy,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isUser ? 'You' : 'ChatGPT',
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  timeago.format(message.timestamp),
                  style: theme.textTheme.bodySmall,
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 16),
                  onPressed: () => speechService.speak(message.content),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message.content),
          ],
        ),
      ),
    );
  }
}