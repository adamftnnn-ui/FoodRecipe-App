import '../models/event_model.dart';
import '../services/api_service.dart';

class EventRepository {
  List<EventModel>? _eventCache;

  Future<List<EventModel>> fetchEvents() async {
    if (_eventCache != null) return _eventCache!;

    final List<Map<String, dynamic>> configs = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Special Ramadan',
        'subtitlePrefix': 'Middle Eastern special collection',
        'query': 'middle eastern',
        'colorValue': 0xFFFFF8E1,
      },
      <String, dynamic>{
        'title': 'Weekend Menu',
        'subtitlePrefix': 'Comfort food for your weekend',
        'query': 'comfort food',
        'colorValue': 0xFFE3F2FD,
      },
      <String, dynamic>{
        'title': 'Healthy & Diet',
        'subtitlePrefix': 'Healthy and low-calorie options',
        'query': 'healthy',
        'colorValue': 0xFFE8F5E9,
      },
      <String, dynamic>{
        'title': 'Quick & Practical',
        'subtitlePrefix': 'Ready-to-serve recipes for busy days',
        'query': 'quick',
        'colorValue': 0xFFFFEBEE,
      },
    ];

    final List<EventModel> events = <EventModel>[];

    for (final Map<String, dynamic> cfg in configs) {
      final String query = cfg['query'] as String;
      final String subtitlePrefix = cfg['subtitlePrefix'] as String;

      try {
        final Map<String, dynamic>? result = await ApiService.getData(
          'recipes/complexSearch'
          '?query=${Uri.encodeQueryComponent(query)}'
          '&number=1',
        );

        final int totalResults = (result?['totalResults'] as int?) ?? 0;

        final String subtitle = totalResults > 0
            ? '$subtitlePrefix • $totalResults+ recipes available'
            : subtitlePrefix;

        events.add(
          EventModel(
            title: cfg['title'] as String,
            subtitle: subtitle,
            image: '',
            colorValue: cfg['colorValue'] as int,
          ),
        );
      } catch (_) {
        events.add(
          EventModel(
            title: cfg['title'] as String,
            subtitle: subtitlePrefix,
            image: '',
            colorValue: cfg['colorValue'] as int,
          ),
        );
      }
    }

    _eventCache = events;
    return events;
  }
}
