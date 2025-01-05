import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/health_provider.dart';
import '../../models/emotion_data.dart';

class HealthSummary extends ConsumerStatefulWidget {
  const HealthSummary({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthSummaryState createState() => _HealthSummaryState();
}

class _HealthSummaryState extends ConsumerState<HealthSummary> {
  int _selectedMonth = DateTime.now().month;

  final List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    final emotions = ref.watch(emotionDataProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecommendations(emotions),
          const SizedBox(height: 24),
          _buildDailyEmotionChart(emotions),
          const SizedBox(height: 24),
          _buildMonthlyEmotionChart(emotions),
          const SizedBox(height: 24),
          _buildYearlyEmotionChart(emotions),
        ],
      ),
    );
  }

  /// Builds the recommendations section
  Widget _buildRecommendations(List<EmotionData> emotions) {
    final yesterdayEmotion = _getPreviousDayEmotion(emotions);
    String recommendation = 'Stay healthy and balanced!';
    IconData icon = Icons.self_improvement;

    if (yesterdayEmotion != null) {
      switch (yesterdayEmotion.type) {
        case EmotionType.happy:
          recommendation = 'You were happy yesterday. Keep spreading positivity!';
          icon = Icons.sentiment_satisfied;
          break;
        case EmotionType.sad:
          recommendation = 'You seemed sad yesterday. Take some time for self-care.';
          icon = Icons.sentiment_dissatisfied;
          break;
        case EmotionType.angry:
          recommendation = 'Try to manage your anger with breathing exercises.';
          icon = Icons.sentiment_very_dissatisfied;
          break;
        case EmotionType.surprised:
          recommendation = 'Reflect on positive surprises and stay curious!';
          icon = Icons.sentiment_satisfied_alt;
          break;
        case EmotionType.fearful:
          recommendation = 'You seemed anxious. Relax with a calming activity.';
          icon = Icons.mood_bad;
          break;
        case EmotionType.disgusted:
          recommendation = 'A fresh start can help you feel better today.';
          icon = Icons.mood_bad;
          break;
        case EmotionType.neutral:
          recommendation = 'Keep maintaining your emotional balance!';
          icon = Icons.self_improvement;
          break;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                recommendation,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the chart for average emotion throughout the day
  Widget _buildDailyEmotionChart(List<EmotionData> emotions) {
    final dailyAverages = _calculateDailyAverages(emotions);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Average Emotion Throughout the Day',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Morning');
                            case 1:
                              return const Text('Afternoon');
                            case 2:
                              return const Text('Evening');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailyAverages.entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.orange,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the chart for monthly emotion trends with dropdown filter
  Widget _buildMonthlyEmotionChart(List<EmotionData> emotions) {
    final monthlyAverages = _calculateMonthlyAverages(emotions);
    final selectedMonthAverage = monthlyAverages[_selectedMonth] ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Average Monthly Emotion Trends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedMonth,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(_monthNames[index]),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Month Average: ${selectedMonthAverage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            Text(_monthNames[value.toInt()]),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyAverages.entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the chart for yearly average emotions
  Widget _buildYearlyEmotionChart(List<EmotionData> emotions) {
    final yearlyAverage = _calculateYearlyAverage(emotions);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yearly Average Emotion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            Text(_monthNames[value.toInt()]),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: yearlyAverage.entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: Calculate monthly averages
  Map<int, double> _calculateMonthlyAverages(List<EmotionData> emotions) {
    final Map<int, List<double>> monthlyEmotions = {};
    for (var emotion in emotions) {
      final month = emotion.timestamp.month;
      monthlyEmotions.putIfAbsent(month, () => []).add(emotion.confidence);
    }

    return monthlyEmotions.map((month, values) => MapEntry(
        month, values.reduce((a, b) => a + b) / values.length));
  }

  /// Helper: Calculate yearly averages
  Map<int, double> _calculateYearlyAverage(List<EmotionData> emotions) {
    final Map<int, List<double>> monthlyEmotions = {};
    for (var emotion in emotions) {
      final month = emotion.timestamp.month;
      monthlyEmotions.putIfAbsent(month, () => []).add(emotion.confidence);
    }

    return monthlyEmotions.map((month, values) => MapEntry(
        month, values.reduce((a, b) => a + b) / values.length));
  }

  /// Helper: Calculate daily averages by time of day
  Map<int, double> _calculateDailyAverages(List<EmotionData> emotions) {
    final Map<int, List<double>> dailyEmotions = {0: [], 1: [], 2: []};

    for (var emotion in emotions) {
      final hour = emotion.timestamp.hour;
      if (hour < 12) {
        dailyEmotions[0]!.add(emotion.confidence); // Morning
      } else if (hour < 18) {
        dailyEmotions[1]!.add(emotion.confidence); // Afternoon
      } else {
        dailyEmotions[2]!.add(emotion.confidence); // Evening
      }
    }

    return dailyEmotions.map((time, values) => MapEntry(
        time, values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length));
  }

  /// Helper: Get the dominant emotion from the previous day
  EmotionData? _getPreviousDayEmotion(List<EmotionData> emotions) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final filtered = emotions
        .where((e) =>
            e.timestamp.year == yesterday.year &&
            e.timestamp.month == yesterday.month &&
            e.timestamp.day == yesterday.day)
        .toList();
    if (filtered.isEmpty) return null;
    return filtered.reduce((a, b) => a.confidence > b.confidence ? a : b);
  }
}
