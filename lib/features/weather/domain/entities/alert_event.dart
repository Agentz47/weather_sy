import 'package:hive/hive.dart';

part 'alert_event.g.dart';

@HiveType(typeId: 5)
class AlertEvent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String ruleId;

  @HiveField(2)
  String ruleName;

  @HiveField(3)
  String message;

  @HiveField(4)
  int timestamp;

  @HiveField(5)
  double triggeredValue;

  @HiveField(6)
  bool notified;

  AlertEvent({
    required this.id,
    required this.ruleId,
    required this.ruleName,
    required this.message,
    required this.timestamp,
    required this.triggeredValue,
    this.notified = false,
  });

  DateTime get time => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
