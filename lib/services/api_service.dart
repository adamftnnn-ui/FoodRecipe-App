import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com';

  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '734e974423msh0deb8b81bbb0357p102b61jsnb747e22182e7',
    'X-RapidAPI-Host': 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
  };

  static Future<Map<String, dynamic>?> getData(String endpoint) async {
    final Uri uri = Uri.parse('$baseUrl/$endpoint');

    try {
      await Future.delayed(const Duration(milliseconds: 350));

      final http.Response response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return <String, dynamic>{'data': decoded};
        }
      } else {
        throw Exception(
          'Failed to load data (status: ${response.statusCode}) from $endpoint',
        );
      }
    } on Exception {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> converseWithSpoonacular(
    String text,
    String contextId,
  ) async {
    final String encodedText = Uri.encodeQueryComponent(text);
    final String endpoint =
        'food/converse?text=$encodedText&contextId=$contextId';

    return getData(endpoint);
  }

  static Future<Map<String, dynamic>?> sendGeminiMessage(String message) async {
    return null;
  }

  static Future<Map<String, dynamic>?> getRecipeDetail(int recipeId) async {
    final String endpoint =
        'recipes/$recipeId/information?includeNutrition=true';

    return getData(endpoint);
  }
}
