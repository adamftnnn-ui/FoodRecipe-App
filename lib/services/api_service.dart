import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service utama untuk berkomunikasi dengan Spoonacular melalui RapidAPI.
/// Semua request HTTP ke API resep lewat sini supaya terpisah dari UI.
class ApiService {
  static const String baseUrl =
      'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com';

  /// TODO: Ganti key ini dengan key kamu sendiri jika berbeda.
  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '734e974423msh0deb8b81bbb0357p102b61jsnb747e22182e7',
    'X-RapidAPI-Host': 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
  };

  /// GET umum ke endpoint Spoonacular.
  /// [endpoint] HANYA path setelah baseUrl, misal:
  ///  - recipes/random?number=6
  ///  - recipes/complexSearch?query=chicken&number=10
  ///
  /// Return:
  ///  - Map<String,dynamic> jika sukses
  ///  - null jika gagal (biar controller/repository bisa handle error state)
  static Future<Map<String, dynamic>?> getData(String endpoint) async {
    final Uri uri = Uri.parse('$baseUrl/$endpoint');

    try {
      // Throttle: beri jeda kecil agar tidak menembus rate limit BASIC
      await Future.delayed(const Duration(milliseconds: 350));

      final http.Response response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          // Kalau suatu saat API mengembalikan List, kita bungkus sebagai map
          return <String, dynamic>{'data': decoded};
        }
      } else {
        // Lempar exception supaya bisa ditangkap di repository/controller
        throw Exception(
          'Gagal memuat data (status: ${response.statusCode}) dari $endpoint',
        );
      }
    } on Exception {
      // Di sini tidak di-throw lagi supaya UI tetap stabil
      // dan repository bisa bedakan antara null vs exception spesifik.
      return null;
    }
  }

  /// Endpoint khusus untuk fitur chat AI Spoonacular.
  /// Dokumentasi: /food/converse
  static Future<Map<String, dynamic>?> converseWithSpoonacular(
    String text,
    String contextId,
  ) async {
    final String encodedText = Uri.encodeQueryComponent(text);
    final String endpoint =
        'food/converse?text=$encodedText&contextId=$contextId';

    return getData(endpoint);
  }

  /// Placeholder kalau suatu saat kamu pakai Gemini atau model lain.
  /// Saat ini dikembalikan null supaya tidak mengganggu alur aplikasi.
  static Future<Map<String, dynamic>?> sendGeminiMessage(String message) async {
    return null;
  }

  /// Ambil detail resep lengkap (termasuk nutrition) berdasarkan [recipeId].
  static Future<Map<String, dynamic>?> getRecipeDetail(int recipeId) async {
    final String endpoint =
        'recipes/$recipeId/information?includeNutrition=true';

    return getData(endpoint);
  }
}
