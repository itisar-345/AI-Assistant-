import 'package:dio/dio.dart';

class ChatService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.openai.com/v1',
    headers: {
      'Authorization': 'Bearer YOUR_API_KEY', // Replace with your real API key
      'Content-Type': 'application/json',
    },
     connectTimeout: Duration(seconds: 10), // 10 seconds
    receiveTimeout: Duration(seconds: 10), // 10 seconds
  ));

  Future<String> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': message,
            }
          ],
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final choices = response.data['choices'];
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'] ?? 'No response content';
        } else {
          throw Exception('No choices in response');
        }
      } else {
        throw Exception('Failed to get a valid response from OpenAI');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}
