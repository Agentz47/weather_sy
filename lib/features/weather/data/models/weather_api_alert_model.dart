import '../../domain/entities/weather_api_alert.dart';

class WeatherApiAlertModel {
  final String senderName;
  final String event;
  final int start;
  final int end;
  final String description;
  final List<String> tags;

  WeatherApiAlertModel({
    required this.senderName,
    required this.event,
    required this.start,
    required this.end,
    required this.description,
    required this.tags,
  });

  factory WeatherApiAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherApiAlertModel(
      senderName: json['sender_name'] ?? 'Unknown',
      event: json['event'] ?? 'Weather Alert',
      start: json['start'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      end: json['end'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      description: json['description'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  WeatherApiAlert toEntity() {
    return WeatherApiAlert(
      senderName: senderName,
      event: event,
      start: start,
      end: end,
      description: description,
      tags: tags,
    );
  }
}
