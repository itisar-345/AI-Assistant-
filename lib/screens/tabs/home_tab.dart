import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart'; 
import '../../widgets/chat_message_list.dart';
import '../../widgets/chat_input.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatProvider); 

    return Column(
      children: [
        Expanded(
          child: ChatMessageList(messages: messages), 
        ),
        ChatInput(messages: messages),
      ],
    );
  }
}
