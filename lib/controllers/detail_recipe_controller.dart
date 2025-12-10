import '../models/recipe_model.dart';
import '../services/api_service.dart';

class DetailRecipeController {
  RecipeModel recipe;
  bool isLoaded = false;

  final Map<String, dynamic>? _localRecipe;
  final bool _isLocal;

  DetailRecipeController({required dynamic recipeData})
    : _localRecipe =
          (recipeData is Map<String, dynamic> &&
              (recipeData['ingredients'] != null ||
                  recipeData['steps'] != null ||
                  recipeData['nutritions'] != null))
          ? Map<String, dynamic>.from(recipeData)
          : null,
      _isLocal =
          (recipeData is Map<String, dynamic> &&
          (recipeData['ingredients'] != null ||
              recipeData['steps'] != null ||
              recipeData['nutritions'] != null)),
      recipe = _initRecipe(recipeData);

  static RecipeModel _initRecipe(dynamic data) {
    if (data is RecipeModel) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final dynamic original = data['original_data'] ?? data['original'];

      if (original is Map<String, dynamic>) {
        return RecipeModel.fromMap(original);
      }

      return RecipeModel.fromMap(data);
    }

    return RecipeModel.fromMap(null);
  }

  Future<void> fetchRecipeFromApi() async {
    if (_isLocal) {
      isLoaded = true;
      return;
    }

    final int id = recipe.id;
    if (id == 0) {
      return;
    }

    final data = await ApiService.getRecipeDetail(id);
    if (data != null) {
      recipe = RecipeModel.fromMap(data);
      isLoaded = true;
    }
  }

  List<String> getIngredients() {
    if (_isLocal) {
      final List<dynamic> raw =
          _localRecipe?['ingredients'] as List<dynamic>? ?? const <dynamic>[];
      return raw
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    return recipe.ingredients;
  }

  List<String> getInstructions() {
    if (_isLocal) {
      final List<dynamic> raw =
          _localRecipe?['steps'] as List<dynamic>? ?? const <dynamic>[];
      return raw
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    return recipe.instructions;
  }

  Map<String, String> getNutrition() {
    if (_isLocal) {
      final List<dynamic> raw =
          _localRecipe?['nutritions'] as List<dynamic>? ?? const <dynamic>[];
      final Map<String, String> result = <String, String>{};

      for (final item in raw) {
        if (item is Map) {
          final String? label = item['label']?.toString();
          final String? value = item['value']?.toString();
          if (label != null &&
              label.trim().isNotEmpty &&
              value != null &&
              value.trim().isNotEmpty) {
            result[label] = value;
          }
        }
      }

      return result;
    }
    return recipe.nutrition;
  }
}
