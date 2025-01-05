import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

// Chat Model
class Chat {
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final bool unread;

  Chat({
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.unread = false,
  });
}

// Chat History Provider
final chatHistoryProvider = StateProvider<List<Chat>>((ref) => []);

class ChatHistoryList extends ConsumerWidget {
  const ChatHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatHistoryProvider);

    return Scaffold(
      body: chats.isEmpty
          ? const Center(child: Text("No chats available. Start a new conversation!"))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatHistoryItem(chat: chat);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new chat
          ref.read(chatHistoryProvider.notifier).state = [
            ...chats,
            Chat(
              title: 'New Conversation ${chats.length + 1}',
              lastMessage: 'Start your conversation here...',
              timestamp: DateTime.now(),
              unread: true,
            ),
          ];
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatHistoryItem extends StatelessWidget {
  final Chat chat;

  const ChatHistoryItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: chat.unread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            timeago.format(chat.timestamp),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: chat.unread
              ? theme.colorScheme.primary
              : theme.textTheme.bodySmall?.color,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: const Icon(Icons.chat_bubble_outline),
      ),
      onTap: () {
        // Handle chat selection
      },
    );
  }
}
