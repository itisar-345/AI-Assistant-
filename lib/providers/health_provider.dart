import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/emotion_data.dart';

final emotionDataProvider = StateNotifierProvider<EmotionDataNotifier, List<EmotionData>>((ref) {
  return EmotionDataNotifier();
});


class EmotionDataNotifier extends StateNotifier<List<EmotionData>> {
  EmotionDataNotifier() : super([]);

  void addEmotionData(EmotionData data) {
    state = [...state, data];
  }

  List<EmotionData> getRecentEmotions([int limit = 10]) {
    final sorted = [...state]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }
}
