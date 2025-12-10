import '../models/recipe_model.dart';
import '../services/api_service.dart';

class DetailRecipeController {
  /// Recipe utama yang dipakai untuk header (judul, gambar, waktu, dsb).
  RecipeModel recipe;

  /// Menandakan apakah detail sudah dimuat (untuk API).
  bool isLoaded = false;

  /// Kalau ini resep buatan user ("Resepku"), field-field lengkapnya
  /// disimpan di sini sebagai map.
  final Map<String, dynamic>? _localRecipe;

  /// True jika data berasal dari resep lokal (Resepku), bukan dari API.
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

  /// Normalisasi data awal menjadi RecipeModel
  static RecipeModel _initRecipe(dynamic data) {
    // 1. Kalau sudah RecipeModel (mis. dari Trending) → pakai langsung
    if (data is RecipeModel) {
      return data;
    }

    // 2. Kalau Map, coba ambil original_data / original dari repository
    if (data is Map<String, dynamic>) {
      final dynamic original = data['original_data'] ?? data['original'];

      if (original is Map<String, dynamic>) {
        // Map lengkap dari API (punya extendedIngredients, dll)
        return RecipeModel.fromMap(original);
      }

      // Untuk resep lokal ("Resepku"), key seperti title, image, dsb
      // tetap bisa dibaca oleh RecipeModel.fromMap sebisanya.
      return RecipeModel.fromMap(data);
    }

    // 3. Fallback aman
    return RecipeModel.fromMap(null);
  }

  /// Ambil detail terbaru dari API berdasarkan recipe.id
  ///
  /// UNTUK RESEP LOKAL:
  /// - Tidak memanggil API sama sekali
  /// - Data full diambil dari _localRecipe
  Future<void> fetchRecipeFromApi() async {
    // 🔹 Mode Resepku → tidak perlu fetch API
    if (_isLocal) {
      isLoaded = true;
      return;
    }

    final int id = recipe.id;
    if (id == 0) {
      // Tidak ada id valid, cukup pakai data lokal saja
      return;
    }

    final data = await ApiService.getRecipeDetail(id);
    if (data != null) {
      recipe = RecipeModel.fromMap(data);
      isLoaded = true;
    } else {
      // Gagal fetch, biarkan pakai data lokal
    }
  }

  /// Bahan-bahan
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

  /// Langkah-langkah
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

  /// Nutrisi
  ///
  /// - Untuk API: pakai Map<String,String> dari RecipeModel.
  /// - Untuk Resepku: konversi List<Map{label,value}> menjadi Map<String,String>
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
