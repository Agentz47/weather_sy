// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      date: (json['date'] as num).toInt(),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'tempMin': instance.tempMin,
      'tempMax': instance.tempMax,
      'description': instance.description,
      'icon': instance.icon,
    };
