import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/attachment.dart';
import '../services/chat_service.dart';
import '../services/storage_service.dart';

final chatLoadingProvider = StateProvider<bool>((ref) => false);

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(
    chatService: ChatService(),
    storageService: StorageService(),
    ref: ref,
  );
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatService chatService;
  final StorageService storageService;
  final Ref ref;
  final _uuid = const Uuid();

  ChatNotifier({
    required this.chatService,
    required this.storageService,
    required this.ref,
  }) : super([]) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await storageService.loadMessages();
    state = messages;
  }

  Future<void> sendMessage(String content, {List<Attachment>? attachments}) async {
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      isUser: true,
      attachments: attachments ?? [],
    );

    state = [...state, userMessage];
    await storageService.saveMessages(state);

    ref.read(chatLoadingProvider.notifier).state = true;

    try {
      final response = await chatService.sendMessage(content);
      
      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        content: response,
        isUser: false,
      );

      state = [...state, aiMessage];
      await storageService.saveMessages(state);
    } catch (e) {
      // Handle error
    } finally {
      ref.read(chatLoadingProvider.notifier).state = false;
    }
  }

  Future<void> clearChat() async {
    state = [];
    await storageService.saveMessages(state);
  }
}
