import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/speech_service.dart';

final isListeningProvider = StateProvider<bool>((ref) => false);
final isSpeakingProvider = StateProvider<bool>((ref) => false);

final speechServiceProvider = Provider((ref) {
  return SpeechService(ref);
});
