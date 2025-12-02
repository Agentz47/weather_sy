import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert_rule.dart';
import '../../data/repositories/alert_rule_repository.dart';

class AlertRulesVm extends StateNotifier<AsyncValue<List<AlertRule>>> {
  final AlertRuleRepository _repository;

  AlertRulesVm(this._repository) : super(const AsyncValue.loading()) {
    loadRules();
  }

  Future<void> loadRules() async {
    state = const AsyncValue.loading();
    try {
      final rules = _repository.getAllRules();
      state = AsyncValue.data(rules);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addRule(AlertRule rule) async {
    try {
      await _repository.addRule(rule);
      await loadRules();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateRule(AlertRule rule) async {
    try {
      await _repository.updateRule(rule);
      await loadRules();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteRule(String id) async {
    try {
      await _repository.deleteRule(id);
      await loadRules();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleRule(String id) async {
    try {
      await _repository.toggleRule(id);
      await loadRules();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
