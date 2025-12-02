import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/forecast.dart';

class ForecastDayTile extends StatelessWidget {
  final Forecast forecast;

  const ForecastDayTile({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.wb_sunny), // TODO: use network or Lottie icon
        title: Text(DateFormat.yMMMd().format(forecast.date)),
        subtitle: Text(forecast.description),
        trailing: Text('${forecast.tempMin.toStringAsFixed(0)}°/${forecast.tempMax.toStringAsFixed(0)}°'),
      ),
    );
  }
}
