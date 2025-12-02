import '../../../../core/services/notification_service.dart';
import '../../domain/entities/alert_event.dart';
import '../../domain/entities/alert_rule.dart';
import '../../domain/entities/weather.dart';
import '../repositories/alert_event_repository.dart';
import '../repositories/alert_rule_repository.dart';

class AlertEvaluationService {
  final AlertRuleRepository _ruleRepo;
  final AlertEventRepository _eventRepo;
  final NotificationService _notificationService;

  AlertEvaluationService(
    this._ruleRepo,
    this._eventRepo,
    this._notificationService,
  );

  Future<List<AlertEvent>> evaluateRules(Weather weather) async {
    final enabledRules = _ruleRepo.getEnabledRules();
    final triggeredEvents = <AlertEvent>[];

    for (var rule in enabledRules) {
      double? value;
      
      switch (rule.ruleType) {
        case 'temperature':
          value = weather.temperature;
          break;
        case 'humidity':
          value = weather.humidity.toDouble();
          break;
        case 'windSpeed':
          value = weather.windSpeed;
          break;
        case 'rainProbability':
          // For rain probability, we'll use a simple check:
          // If description contains rain, assume 100%, otherwise 0%
          value = weather.description.toLowerCase().contains('rain') ? 100.0 : 0.0;
          break;
      }

      if (value != null && rule.evaluate(value)) {
        final event = AlertEvent(
          id: '${rule.id}_${DateTime.now().millisecondsSinceEpoch}',
          ruleId: rule.id,
          ruleName: rule.name,
          message: _generateMessage(rule, value),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          triggeredValue: value,
          notified: false,
        );

        await _eventRepo.addEvent(event);
        triggeredEvents.add(event);

        // Send notification if enabled
        if (rule.notifyOnTrigger) {
          await _notificationService.showRuleAlertNotification(
            id: event.timestamp ~/ 1000,
            title: rule.name,
            body: event.message,
          );
          await _eventRepo.markAsNotified(event.id);
        }
      }
    }

    return triggeredEvents;
  }

  String _generateMessage(AlertRule rule, double value) {
    String unit = '';
    String conditionName = '';
    
    switch (rule.ruleType) {
      case 'temperature':
        unit = '°C';
        conditionName = 'Temperature';
        break;
      case 'humidity':
        unit = '%';
        conditionName = 'Humidity';
        break;
      case 'windSpeed':
        unit = 'm/s';
        conditionName = 'Wind speed';
        break;
      case 'rainProbability':
        unit = '%';
        conditionName = 'Rain probability';
        break;
    }
    
    String operatorText = '';
    switch (rule.operator) {
      case '>':
        operatorText = 'above';
        break;
      case '<':
        operatorText = 'below';
        break;
      case '>=':
        operatorText = 'at or above';
        break;
      case '<=':
        operatorText = 'at or below';
        break;
      case '==':
        operatorText = 'equal to';
        break;
    }
    
    return '$conditionName is ${value.toStringAsFixed(1)}$unit ($operatorText your limit of ${rule.threshold}$unit)';
  }

  Future<void> scheduleDailySummary({int hour = 18}) async {
    final todayEvents = _eventRepo.getTodayEvents();
    
    if (todayEvents.isEmpty) {
      await _notificationService.scheduleDailySummary(
        hour: hour,
        summary: 'No weather alerts triggered today.',
      );
    } else {
      final summary = 'Today: ${todayEvents.length} alert(s) triggered. '
          '${todayEvents.map((e) => e.ruleName).toSet().join(', ')}';
      
      await _notificationService.scheduleDailySummary(
        hour: hour,
        summary: summary,
      );
    }
  }
}
