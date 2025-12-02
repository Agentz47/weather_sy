class Weather {
  final String city;
  final double lat;
  final double lon;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final DateTime timestamp;

  Weather({
    required this.city,
    required this.lat,
    required this.lon,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
  });
}
