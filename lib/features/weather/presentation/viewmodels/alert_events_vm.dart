import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert_event.dart';
import '../../data/repositories/alert_event_repository.dart';

class AlertEventsVm extends StateNotifier<AsyncValue<List<AlertEvent>>> {
  final AlertEventRepository _repository;

  AlertEventsVm(this._repository) : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = const AsyncValue.loading();
    try {
      final events = _repository.getAllEvents();
      state = AsyncValue.data(events);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _repository.deleteEvent(id);
      await loadEvents();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearAll() async {
    try {
      await _repository.clear();
      await loadEvents();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteOldEvents({int daysToKeep = 30}) async {
    try {
      await _repository.deleteOldEvents(daysToKeep: daysToKeep);
      await loadEvents();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
