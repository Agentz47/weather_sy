import 'package:hive/hive.dart';
import '../../domain/entities/alert_event.dart';

class AlertEventRepository {
  static const String _boxName = 'alert_events';
  Box<AlertEvent>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<AlertEvent>(_boxName);
  }

  Future<void> addEvent(AlertEvent event) async {
    await _box?.put(event.id, event);
  }

  AlertEvent? getEvent(String id) {
    return _box?.get(id);
  }

  List<AlertEvent> getAllEvents() {
    final events = _box?.values.toList() ?? [];
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return events;
  }

  List<AlertEvent> getEventsByRule(String ruleId) {
    return _box?.values
        .where((event) => event.ruleId == ruleId)
        .toList() ?? [];
  }

  List<AlertEvent> getTodayEvents() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    
    return _box?.values
        .where((event) => event.timestamp >= todayStart)
        .toList() ?? [];
  }

  Future<void> markAsNotified(String id) async {
    final event = _box?.get(id);
    if (event != null) {
      event.notified = true;
      await event.save();
    }
  }

  Future<void> deleteEvent(String id) async {
    await _box?.delete(id);
  }

  Future<void> deleteOldEvents({int daysToKeep = 30}) async {
    final cutoffTime = DateTime.now()
        .subtract(Duration(days: daysToKeep))
        .millisecondsSinceEpoch;
    
    final oldEvents = _box?.values
        .where((event) => event.timestamp < cutoffTime)
        .toList() ?? [];
    
    for (var event in oldEvents) {
      await event.delete();
    }
  }

  Future<void> clear() async {
    await _box?.clear();
  }
}
