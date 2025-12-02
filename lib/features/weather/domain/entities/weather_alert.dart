class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String severity; // minor, moderate, severe, extreme
  final String type; // temperature, wind, condition
  final String recommendation;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.severity,
    required this.type,
    required this.recommendation,
  });
}
