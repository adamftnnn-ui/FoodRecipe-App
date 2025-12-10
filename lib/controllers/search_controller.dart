import '../repositories/recipe_repository.dart';

class SearchControllerr {
  final RecipeRepository _recipeRepository = RecipeRepository();

  /// Mencari resep berdasarkan keyword.
  /// Hasilnya sudah dalam bentuk Map yang konsisten
  /// dengan `fetchRecipesByFilter`:
  /// { id, title, image, country, isHalal, readyInMinutes, servings, rating, original_data, ... }
  Future<List<dynamic>> searchRecipes(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return [];

    // ✅ gunakan repository agar field `country`, `isHalal`, dll terisi konsisten
    final results = await _recipeRepository.fetchRecipesByFilter(trimmed);
    return results;
  }
}
