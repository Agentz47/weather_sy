import 'package:hive/hive.dart';

part 'alert_rule.g.dart';

@HiveType(typeId: 4)
class AlertRule extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String ruleType; // 'temperature', 'humidity', 'windSpeed', 'rainProbability'

  @HiveField(3)
  String operator; // '>', '<', '>=', '<=', '=='

  @HiveField(4)
  double threshold;

  @HiveField(5)
  bool isEnabled;

  @HiveField(6)
  bool notifyOnTrigger;

  @HiveField(7)
  int createdAt;

  AlertRule({
    required this.id,
    required this.name,
    required this.ruleType,
    required this.operator,
    required this.threshold,
    this.isEnabled = true,
    this.notifyOnTrigger = true,
    required this.createdAt,
  });

  bool evaluate(double value) {
    if (!isEnabled) return false;
    
    switch (operator) {
      case '>':
        return value > threshold;
      case '<':
        return value < threshold;
      case '>=':
        return value >= threshold;
      case '<=':
        return value <= threshold;
      case '==':
        return value == threshold;
      default:
        return false;
    }
  }

  String get description {
    String unit = '';
    switch (ruleType) {
      case 'temperature':
        unit = '°C';
        break;
      case 'humidity':
        unit = '%';
        break;
      case 'windSpeed':
        unit = 'm/s';
        break;
      case 'rainProbability':
        unit = '%';
        break;
    }
    return '$name: ${ruleType.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')} $operator $threshold$unit';
  }
}
