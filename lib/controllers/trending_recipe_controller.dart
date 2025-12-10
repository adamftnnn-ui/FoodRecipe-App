import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

class TrendingRecipeController {
  final RecipeRepository repository = RecipeRepository();

  /// List resep trending
  final ValueNotifier<List<RecipeModel>> trendingRecipes =
      ValueNotifier<List<RecipeModel>>([]);

  /// State tambahan agar rapi (opsional dipakai di UI)
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  Future<void> fetchTrendingRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await repository.fetchTrendingRecipes();
      trendingRecipes.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
