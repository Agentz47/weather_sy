import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherAnimation extends StatelessWidget {
  final String weatherCondition;
  final double size;

  const WeatherAnimation({
    super.key,
    required this.weatherCondition,
    this.size = 150,
  });

  String _getAnimationUrl(String condition) {
    final lowerCondition = condition.toLowerCase();
    
    // Using free Lottie animations from LottieFiles CDN
    if (lowerCondition.contains('clear') || lowerCondition.contains('sunny')) {
      return 'https://lottie.host/4f2002d3-9c2e-4c3f-85b7-6efcb8c0f780/JeH1uRBQAB.json';
    } else if (lowerCondition.contains('cloud')) {
      return 'https://lottie.host/aa1f0d66-8d54-42fb-b2c7-c34c27f5a1bf/6qFb8fKPvb.json';
    } else if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return 'https://lottie.host/caa736f0-a2aa-4253-a722-3b6e27e6a34b/8QQH9HKWgh.json';
    } else if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return 'https://lottie.host/3c560dfd-8fa2-4e92-9e02-d4d65c9c8e49/JcREO9Vn2I.json';
    } else if (lowerCondition.contains('snow')) {
      return 'https://lottie.host/89bb371f-7e16-4eef-bc8d-7ae4da17f3db/7TgJQCXHqr.json';
    } else if (lowerCondition.contains('mist') || lowerCondition.contains('fog') || lowerCondition.contains('haze')) {
      return 'https://lottie.host/c5c7aa1d-18ca-4849-83e2-45efe3e1f7c9/tVKe1HqoK2.json';
    } else if (lowerCondition.contains('wind')) {
      return 'https://lottie.host/f3e1c90d-6d6f-4c9e-b8e5-7d9e3c1f2a4b/WindAnimation.json';
    }
    
    // Default to partly cloudy
    return 'https://lottie.host/aa1f0d66-8d54-42fb-b2c7-c34c27f5a1bf/6qFb8fKPvb.json';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        _getAnimationUrl(weatherCondition),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if animation fails to load
          return Icon(
            _getFallbackIcon(weatherCondition),
            size: size * 0.6,
            color: Theme.of(context).primaryColor,
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
