// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  city: json['city'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  temperature: (json['temperature'] as num).toDouble(),
  description: json['description'] as String,
  icon: json['icon'] as String,
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  timestamp: (json['timestamp'] as num).toInt(),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'city': instance.city,
      'lat': instance.lat,
      'lon': instance.lon,
      'temperature': instance.temperature,
      'description': instance.description,
      'icon': instance.icon,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'timestamp': instance.timestamp,
    };
