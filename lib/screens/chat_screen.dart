import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart'; 
import '../widgets/chat_message_list.dart';
import '../widgets/chat_input.dart';
import '../widgets/greeting_header.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // Show GreetingHeader only if there are no messages
            if (messages.isEmpty) const GreetingHeader(),
            Expanded(
              child: ChatMessageList(messages: messages), 
            ),
            ChatInput(messages: messages), 
          ],
        ),
      ),
    );
  }
}
