import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final String city;
  final double lat;
  final double lon;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int timestamp;

  WeatherModel({
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

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  Weather toEntity() {
    return Weather(
      city: city,
      lat: lat,
      lon: lon,
      temperature: temperature,
      description: description,
      icon: icon,
      humidity: humidity,
      windSpeed: windSpeed,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
    );
  }
}
