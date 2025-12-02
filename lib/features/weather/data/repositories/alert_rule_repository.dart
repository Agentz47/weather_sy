import 'package:hive/hive.dart';
import '../../domain/entities/alert_rule.dart';

class AlertRuleRepository {
  static const String _boxName = 'alert_rules';
  Box<AlertRule>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<AlertRule>(_boxName);
  }

  Future<void> addRule(AlertRule rule) async {
    await _box?.put(rule.id, rule);
  }

  Future<void> updateRule(AlertRule rule) async {
    await _box?.put(rule.id, rule);
  }

  Future<void> deleteRule(String id) async {
    await _box?.delete(id);
  }

  AlertRule? getRule(String id) {
    return _box?.get(id);
  }

  List<AlertRule> getAllRules() {
    return _box?.values.toList() ?? [];
  }

  List<AlertRule> getEnabledRules() {
    return _box?.values.where((rule) => rule.isEnabled).toList() ?? [];
  }

  Future<void> toggleRule(String id) async {
    final rule = _box?.get(id);
    if (rule != null) {
      rule.isEnabled = !rule.isEnabled;
      await rule.save();
    }
  }

  Future<void> clear() async {
    await _box?.clear();
  }
}
