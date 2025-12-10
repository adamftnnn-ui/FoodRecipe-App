import '../repositories/recipe_repository.dart';

class RecipeListController {
  final RecipeRepository recipeRepository;

  RecipeListController({RecipeRepository? repository})
    : recipeRepository = repository ?? RecipeRepository();

  Future<List<dynamic>> fetchRecipesByFilter(String filter) {
    return recipeRepository.fetchRecipesByFilter(filter);
  }
}
