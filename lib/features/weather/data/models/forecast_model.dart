import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_model.g.dart';

@JsonSerializable()
class ForecastModel {
  final int date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;

  ForecastModel({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) => _$ForecastModelFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);

  Forecast toEntity() {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(date * 1000),
      tempMin: tempMin,
      tempMax: tempMax,
      description: description,
      icon: icon,
    );
  }
}
