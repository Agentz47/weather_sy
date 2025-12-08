import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/ui/components/app_card.dart';
import '../../domain/entities/weather.dart';
import 'weather_animation.dart';

class WeatherSummaryCard extends StatelessWidget {
  final Weather weather;

  final bool usedLastKnownLocation;

  const WeatherSummaryCard({super.key, required this.weather, this.usedLastKnownLocation = false});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City name and location info
          Row(
            children: [
              // Different color in dark mode
              Icon(Icons.location_on, color: Theme.of(context).brightness == Brightness.dark
      ? Colors.limeAccent
      : Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.city,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (usedLastKnownLocation)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          'Using last known location. Enable location for up-to-date weather.',
                          style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Animated weather icon
          Center(
            child: WeatherAnimation(
              weatherCondition: weather.description,
              size: 180, // 180 looks good
            ),
          ),
          const SizedBox(height: 16),
          
          // Temperature - Large and centered
          Center(
            child: Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 64,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Weather description
          Center(
            child: Text(
              weather.description.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                letterSpacing: 1.2,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Weather details in a grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                context,
                icon: Icons.water_drop,
                
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
              _buildWeatherDetail(
                context,
                icon: Icons.air,
                label: 'Wind Speed',
                value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Last updated
          Center(
            child: Text(
              'Updated: ${DateFormat('MMM dd, yyyy • hh:mm a').format(weather.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeatherDetail(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 32),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
