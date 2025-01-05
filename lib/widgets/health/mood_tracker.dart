import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/health_provider.dart';
import '../../models/emotion_data.dart';

final recommendationProvider = StateProvider<String>((ref) => '');

class MoodTracker extends ConsumerWidget {
  const MoodTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MoodInput(),
        const Expanded(child: MoodHistory()),
      ],
    );
  }
}

class MoodInput extends ConsumerWidget {
  const MoodInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendation = ref.watch(recommendationProvider);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: EmotionType.values.map((type) {
                return ElevatedButton.icon(
                  onPressed: () {
                    _recordMood(context, ref, type);
                  },
                  icon: _getEmotionIcon(type),
                  label: Text(type.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Display the recommendation
            if (recommendation.isNotEmpty)
              Card(
                color: const Color.fromARGB(255, 100, 0, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    recommendation,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _recordMood(BuildContext context, WidgetRef ref, EmotionType type) {
    final emotion = EmotionData(
      type: type,
      confidence: 1.0,
      notes: 'User-reported mood',
    );

    ref.read(emotionDataProvider.notifier).addEmotionData(emotion);
    
    // Get the recommendation for the recorded mood
    String recommendation = _getRecommendation(type);

    // Update the recommendation state
    ref.read(recommendationProvider.notifier).state = recommendation;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood recorded: ${type.name}\n$recommendation')),
    );
  }

  // Function to get a recommendation based on the emotion type
  String _getRecommendation(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return 'Great to see you happy! Keep it up!';
      case EmotionType.sad:
        return 'You seem sad. Try talking to a friend or listening to uplifting music.';
      case EmotionType.angry:
        return 'Feeling angry? Take deep breaths or go for a short walk.';
      case EmotionType.surprised:
        return 'Surprised? Reflect on the positive surprises!';
      case EmotionType.fearful:
        return 'You seem anxious. Try relaxation exercises.';
      case EmotionType.disgusted:
        return 'Feeling disgusted? Take a break and get fresh air.';
      case EmotionType.neutral:
      default:
        return 'You seem calm. Keep up the balanced mindset!';
    }
  }

  Icon _getEmotionIcon(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return const Icon(Icons.sentiment_very_satisfied);
      case EmotionType.sad:
        return const Icon(Icons.sentiment_very_dissatisfied);
      case EmotionType.angry:
        return const Icon(Icons.mood_bad);
      case EmotionType.surprised:
        return const Icon(Icons.sentiment_satisfied_alt);
      case EmotionType.fearful:
        return const Icon(Icons.warning);
      case EmotionType.disgusted:
        return const Icon(Icons.sick);
      case EmotionType.neutral:
        return const Icon(Icons.sentiment_neutral);
    }
  }
}

class MoodHistory extends ConsumerWidget {
  const MoodHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emotions = ref.watch(emotionDataProvider);

    if (emotions.isEmpty) {
      return const Center(
        child: Text('No mood data available. Start by recording your mood!'),
      );
    }

    return ListView.builder(
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        final emotion = emotions[index];
        return ListTile(
          leading: _getEmotionIcon(emotion.type),
          title: Text(emotion.type.name),
          subtitle: Text(_formatTimestamp(emotion.timestamp)),
          trailing: emotion.notes != null ? const Icon(Icons.note) : null,
        );
      },
    );
  }

  Icon _getEmotionIcon(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return const Icon(Icons.sentiment_very_satisfied);
      case EmotionType.sad:
        return const Icon(Icons.sentiment_very_dissatisfied);
      case EmotionType.angry:
        return const Icon(Icons.mood_bad);
      case EmotionType.surprised:
        return const Icon(Icons.sentiment_satisfied_alt);
      case EmotionType.fearful:
        return const Icon(Icons.warning);
      case EmotionType.disgusted:
        return const Icon(Icons.sick);
      case EmotionType.neutral:
        return const Icon(Icons.sentiment_neutral);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.month}/${timestamp.day} ${timestamp.hour}:${timestamp.minute}';
  }
}
