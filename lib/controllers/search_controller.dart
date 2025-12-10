import '../repositories/recipe_repository.dart';

class SearchControllerr {
  final RecipeRepository _recipeRepository = RecipeRepository();

  Future<List<dynamic>> searchRecipes(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return [];
    final results = await _recipeRepository.fetchRecipesByFilter(trimmed);
    return results;
  }
}
