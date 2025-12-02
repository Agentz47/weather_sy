import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherAnimation extends StatelessWidget {
    // NOTE: If Lottie animations do not appear, check that the URLs are valid and the device has internet access.
    // Lottie host links may expire or be rate-limited. Replace with new URLs from lottiefiles.com if needed.
  final String weatherCondition;
  final double size;

  const WeatherAnimation({
    super.key,
    required this.weatherCondition,
    this.size = 150,
  });

  // Place these files in assets/animations/ and add to pubspec.yaml:
  // clear.json, cloudy.json, rain.json, thunder.json, snow.json, fog.json, wind.json, partly_cloudy.json
  String _getAnimationAsset(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('clear') || lowerCondition.contains('sunny')) {
      return 'assets/animations/clear.json';
    } else if (lowerCondition.contains('cloud')) {
      return 'assets/animations/cloudy.json';
    } else if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return 'assets/animations/rain.json';
    } else if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return 'assets/animations/thunder.json';
    } else if (lowerCondition.contains('snow')) {
      return 'assets/animations/snow.json';
    } else if (lowerCondition.contains('mist') || lowerCondition.contains('fog') || lowerCondition.contains('haze')) {
      return 'assets/animations/fog.json';
    } else if (lowerCondition.contains('wind')) {
      return 'assets/animations/wind.json';
    }
    // Default to partly cloudy
    return 'assets/animations/partly_cloudy.json';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        _getAnimationAsset(weatherCondition),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if animation fails to load
          return Icon(
            _getFallbackIcon(weatherCondition),
            size: size * 0.6,
            color: const Color.fromARGB(255, 73, 148, 245),
          );
        },
      ),
    );
  }

  IconData _getFallbackIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    
    if (lowerCondition.contains('clear') || lowerCondition.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (lowerCondition.contains('cloud')) {
      return Icons.cloud;
    } else if (lowerCondition.contains('rain')) {
      return Icons.water_drop;
    } else if (lowerCondition.contains('thunder')) {
      return Icons.flash_on;
    } else if (lowerCondition.contains('snow')) {
      return Icons.ac_unit;
    } else if (lowerCondition.contains('mist') || lowerCondition.contains('fog')) {
      return Icons.foggy;
    }
    
    return Icons.wb_cloudy;
  }
}
