import '../models/recipe_model.dart';
import '../services/api_service.dart';
import '../services/halal_checker.dart';

class RecipeRepository {
  List<String>? _suggestionCache;
  List<RecipeModel>? _trendingCache;

  Future<List<String>> fetchSuggestions() async {
    if (_suggestionCache != null) {
      return _suggestionCache!;
    }

    final Map<String, dynamic>? result = await ApiService.getData(
      'recipes/random?number=6',
    );

    if (result != null && result['recipes'] is List) {
      final List recipes = result['recipes'] as List;
      final suggestions = recipes
          .map((item) => (item['title'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toList();

      _suggestionCache = suggestions;
      return suggestions;
    }

    return <String>['Chicken', 'Pasta', 'Salad', 'Soup', 'Rice', 'Burger'];
  }

  Future<List<RecipeModel>> fetchTrendingRecipes() async {
    if (_trendingCache != null && _trendingCache!.isNotEmpty) {
      return _trendingCache!;
    }

    List<RecipeModel> parsed = <RecipeModel>[];

    const String endpoint =
        'recipes/complexSearch?sort=popularity&number=10&addRecipeInformation=true';

    final Map<String, dynamic>? result = await ApiService.getData(endpoint);

    if (result != null && result['results'] is List) {
      final List data = result['results'] as List;
      parsed = data.map<RecipeModel>((item) {
        return RecipeModel.fromMap(item as Map<String, dynamic>);
      }).toList();
    }

    if (parsed.isEmpty) {
      final Map<String, dynamic>? randomResult = await ApiService.getData(
        'recipes/random?number=10',
      );

      if (randomResult != null && randomResult['recipes'] is List) {
        final List data = randomResult['recipes'] as List;
        parsed = data.map<RecipeModel>((item) {
          return RecipeModel.fromMap(item as Map<String, dynamic>);
        }).toList();
      }
    }

    _trendingCache = parsed;
    return parsed;
  }

  Future<List<Map<String, dynamic>>> fetchRecipesByFilter(String filter) async {
    if (filter.trim().isEmpty) return <Map<String, dynamic>>[];

    final String q = Uri.encodeQueryComponent(filter);
    final String endpoint =
        'recipes/complexSearch?query=$q&number=20&addRecipeInformation=true&includeNutrition=true';

    final Map<String, dynamic>? result = await ApiService.getData(endpoint);

    if (result != null && result['results'] is List) {
      final List results = result['results'] as List;

      return results.map<Map<String, dynamic>>((item) {
        final cuisines = item['cuisines'];
        String country = 'Global';
        if (cuisines is List && cuisines.isNotEmpty) {
          country = cuisines.first.toString();
        }

        final List extIng = item['extendedIngredients'] as List? ?? <dynamic>[];
        final List<String> ingredientNames = extIng.map<String>((ing) {
          if (ing is Map) {
            return (ing['name'] ?? ing['original'] ?? '')
                .toString()
                .toLowerCase();
          }
          return ing.toString().toLowerCase();
        }).toList();

        final List<String> textsToCheck = <String>[
          ...ingredientNames,
          (item['title'] ?? '').toString(),
          (item['summary'] ?? '').toString(),
        ];

        final bool isHalal = checkHalalStatus(textsToCheck);

        final num? spoonScore = item['spoonacularScore'] as num?;
        final double rating = 4.0 + (spoonScore ?? 80) / 20.0;

        return <String, dynamic>{
          'id': item['id'],
          'title': item['title'] ?? 'Untitled Recipe',
          'image': item['image'] ?? '',
          'country': country,
          'isHalal': isHalal,
          'readyInMinutes': item['readyInMinutes'] ?? '-',
          'servings': item['servings'] ?? '-',
          'rating': rating,
          'original_data': item,
        };
      }).toList();
    }

    return <Map<String, dynamic>>[];
  }
}
