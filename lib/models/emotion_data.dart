import 'package:uuid/uuid.dart';

enum EmotionType {
  happy,
  sad,
  angry,
  surprised,
  fearful,
  disgusted,
  neutral
}

class EmotionData {
  final String id;
  final EmotionType type;
  final double confidence;
  final DateTime timestamp;
  final String? notes;

  EmotionData({
    String? id,
    required this.type,
    required this.confidence,
    DateTime? timestamp,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory EmotionData.fromJson(Map<String, dynamic> json) {
    try {
      return EmotionData(
        id: json['id'] ?? const Uuid().v4(),
        type: EmotionType.values.firstWhere(
          (e) => e.name == json['type'], 
          orElse: () => EmotionType.neutral, 
        ),
        confidence: (json['confidence'] as num).toDouble(),
        timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
        notes: json['notes'] as String?,
      );
    } catch (e) {
      throw Exception('Error parsing EmotionData: $e');
    }
  }
}