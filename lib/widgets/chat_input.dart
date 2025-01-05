import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../providers/speech_provider.dart';
import '../providers/file_provider.dart';
import '../models/chat_message.dart';
import 'attachment_list.dart';
import 'glowing_circle.dart';
import 'greeting_header.dart'; 

class ChatInput extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;

  const ChatInput({super.key, required this.messages});

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  String _feedbackMessage = '';
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _playGreetingIfNeeded(); 
  }

  Future<void> _playGreetingIfNeeded() async {
    if (widget.messages.isEmpty) { 
      final speechService = ref.read(speechServiceProvider);
      await speechService.speak("Hello! How can I assist you today?");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    
    final attachments = ref.read(attachmentsProvider);
    ref.read(chatProvider.notifier).sendMessage(
      text,
      attachments: attachments,
    );
    ref.read(attachmentsProvider.notifier).clearAttachments();
  }

  Future<void> _startListening() async {
    final speechService = ref.read(speechServiceProvider);
    final isListening = ref.read(isListeningProvider.notifier);
    
    final success = await speechService.startListening((text) {
      _controller.text = text;
      setState(() {
        _isComposing = text.isNotEmpty;
      });
      isListening.state = false;
    });

    if (success) {
      isListening.state = true;
      setState(() {
        _feedbackMessage = 'Listening...';
      });
    } else {
      setState(() {
        _feedbackMessage = 'Speech recognition unavailable.';
      });
    }
  }

  Future<void> _stopListening() async {
    final speechService = ref.read(speechServiceProvider);
    final isListening = ref.read(isListeningProvider.notifier);
    
    await speechService.stopListening();
    isListening.state = false;
  }

  Future<void> _pickFiles() async {
    final fileService = ref.read(fileServiceProvider);
    final attachments = await fileService.pickFiles();
    
    if (attachments.isNotEmpty) {
      ref.read(attachmentsProvider.notifier).addAttachments(attachments);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(chatLoadingProvider);
    final isListening = ref.watch(isListeningProvider);
    final isSpeaking = ref.watch(isSpeakingProvider);

    return Column(
      children: [
        if (widget.messages.isEmpty) const GreetingHeader(), 

        if (_feedbackMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _feedbackMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (isListening || isSpeaking)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlowingCircle(isActive: isListening || isSpeaking),
          ),
        const AttachmentList(),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  color: isListening
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color,
                ),
                onPressed: !isLoading
                    ? (isListening ? _stopListening : _startListening)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: !isLoading ? _pickFiles : null,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  enabled: !isLoading,
                ),
              ),
              IconButton(
                icon: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      )
                    : Icon(
                        Icons.send,
                        color: _isComposing
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                onPressed: _isComposing && !isLoading
                    ? () => _handleSubmitted(_controller.text)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}