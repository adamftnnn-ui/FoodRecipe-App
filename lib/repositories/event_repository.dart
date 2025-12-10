import '../models/event_model.dart';
import '../services/api_service.dart';

/// Repository untuk "event" yang tampil di beranda.
///
/// Setiap event adalah semacam kampanye/koleksi resep
/// (misal: Spesial Ramadan, Menu Akhir Pekan, dll).
/// Di sini kita kombinasikan:
///  - konfigurasi lokal (judul, warna, query),
///  - data real-time dari Spoonacular (jumlah resep).
class EventRepository {
List<EventModel>? _eventCache;

  Future<List<EventModel>> fetchEvents() async {
    if (_eventCache != null) return _eventCache!;

    final List<Map<String, dynamic>> configs = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Spesial Ramadan',
        'subtitlePrefix': 'Koleksi masakan khas Middle Eastern',
        'query': 'middle eastern',
        'colorValue': 0xFFFFF8E1,
      },
      <String, dynamic>{
        'title': 'Menu Akhir Pekan',
        'subtitlePrefix': 'Comfort food untuk santai akhir pekan',
        'query': 'comfort food',
        'colorValue': 0xFFE3F2FD,
      },
      <String, dynamic>{
        'title': 'Sehat & Diet',
        'subtitlePrefix': 'Pilihan menu sehat & rendah kalori',
        'query': 'healthy',
        'colorValue': 0xFFE8F5E9,
      },
      <String, dynamic>{
        'title': 'Cepat & Praktis',
        'subtitlePrefix': 'Resep siap saji untuk hari sibuk',
        'query': 'quick',
        'colorValue': 0xFFFFEBEE,
      },
    ];

    final List<EventModel> events = <EventModel>[];

    for (final Map<String, dynamic> cfg in configs) {
      final String query = cfg['query'] as String;
      final String subtitlePrefix = cfg['subtitlePrefix'] as String;

      // Panggil API untuk mengetahui total resep yang tersedia untuk query ini.
      try {
        final Map<String, dynamic>? result = await ApiService.getData(
          'recipes/complexSearch'
          '?query=${Uri.encodeQueryComponent(query)}'
          '&number=1',
        );

        final int totalResults = (result?['totalResults'] as int?) ?? 0;

        final String subtitle = totalResults > 0
            ? '$subtitlePrefix • $totalResults+ resep tersedia'
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
        // Jika terjadi error jaringan, gunakan subtitle default saja,
        // sehingga UI tetap tampil dan aplikasi tidak crash.
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

    return events;
  }
}
