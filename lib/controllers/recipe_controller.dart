import '../repositories/recipe_repository.dart';

class RecipeController {
  final RecipeRepository repository = RecipeRepository();

  Future<List<dynamic>> searchRecipes(String keyword) async {
    if (keyword.trim().isEmpty) return [];
    return await repository.fetchRecipesByFilter(keyword.trim());
  }
}
