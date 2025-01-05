import 'attachment.dart';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<Attachment>? attachments;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.attachments,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments?.map((attachment) => attachment.toJson()).toList(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: json['attachments'] != null
          ? List<Attachment>.from(json['attachments'].map((attachmentJson) => Attachment.fromJson(attachmentJson)))
          : null,
    );
  }
}