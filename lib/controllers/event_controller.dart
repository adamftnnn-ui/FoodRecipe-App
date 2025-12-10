import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../repositories/event_repository.dart';

class EventController {
  final EventRepository repository = EventRepository();
  final ValueNotifier<List<EventModel>> events = ValueNotifier([]);

  Future<void> fetchEventsFromSpoonacular() async {
    events.value = await repository.fetchEvents();
  }
}
