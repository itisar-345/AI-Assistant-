import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chat_message_item.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';

class ChatMessageList extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const ChatMessageList({super.key, required this.messages});

  @override
  ChatMessageListState createState() => ChatMessageListState();
}

class ChatMessageListState extends ConsumerState<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet. Start the conversation!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return ChatMessageItem(message: message);
      },
    );
  }
}
