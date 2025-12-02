import 'package:flutter/material.dart';
import '../../domain/entities/weather_alert.dart';

class AlertCard extends StatelessWidget {
  final WeatherAlert alert;

  const AlertCard({super.key, required this.alert});

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'extreme':
        return Colors.red.shade900;
      case 'severe':
        return Colors.red.shade700;
      case 'moderate':
        return Colors.orange.shade700;
      case 'minor':
        return Colors.yellow.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'temperature':
        return Icons.thermostat;
      case 'wind':
        return Icons.air;
      case 'condition':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = theme.colorScheme.primary;
    final cardBg = isDark ? theme.colorScheme.surface : theme.colorScheme.background;
    final borderColor = _getSeverityColor(alert.severity);
    final textColor = isDark ? Colors.white : Colors.black87;
    final recBoxBg = isDark ? Colors.blueGrey.shade900 : Colors.blue.shade50;
    final recTextColor = isDark ? Colors.white : Colors.black87;
    final recIconColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getTypeIcon(alert.type),
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: borderColor,
                        ),
                      ),
                      Text(
                        alert.severity.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              alert.description,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: recBoxBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: recIconColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Safety Recommendation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: recIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.recommendation,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: recTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Updated: ${_formatTime(alert.timestamp)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
