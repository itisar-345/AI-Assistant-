import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class StorageService {
  static const String _key = 'chat_messages';

  Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(
      messages.map((message) => message.toJson()).toList(),
    );
    await prefs.setString(_key, data);
  }
}