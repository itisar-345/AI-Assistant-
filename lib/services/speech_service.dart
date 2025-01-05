import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../providers/speech_provider.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  final Ref ref;
  bool _isInitialized = false;

  SpeechService(this.ref);

  Future<void> init() async {
    if (!_isInitialized) {
      bool available = await _stt.initialize();
      if (!available) {
        throw Exception("Speech recognition is not available");
      }
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.9);
      _isInitialized = true;
    }
  }

  Future<void> speak(String text) async {
    await init();
    final isSpeakingNotifier = ref.read(isSpeakingProvider.notifier);
    isSpeakingNotifier.state = true;
    await _tts.speak(text);
    isSpeakingNotifier.state = false;
  }


  Future<void> stop() async {
    await _tts.stop();
    final isSpeakingNotifier = ref.read(isSpeakingProvider.notifier);
    isSpeakingNotifier.state = false;
  }

  Future<bool> startListening(Function(String) onResult) async {
    await init();
    
    if (!_stt.isAvailable) {
      return false;
    }

    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'en-US',
    );
    
    return true;
  }

  Future<void> stopListening() async {
    await _stt.stop();
  }

  bool get isListening => _stt.isListening;
}