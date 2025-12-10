import '../repositories/recipe_repository.dart';

class RecipeController {
  final RecipeRepository repository = RecipeRepository();

  /// Mencari resep berdasarkan keyword (akan memanggil API).
  Future<List<dynamic>> searchRecipes(String keyword) async {
    if (keyword.trim().isEmpty) return [];
    return await repository.fetchRecipesByFilter(keyword.trim());
  }
}
