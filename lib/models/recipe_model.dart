import '/services/halal_checker.dart';

class RecipeModel {
  final int id;
  final String image;
  final String title;
  final String country;
  final bool isHalal;
  final String readyInMinutes;
  final String servings;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
  final Map<String, String> nutrition;
  final Map<String, dynamic>? original;

  const RecipeModel({
    required this.id,
    required this.image,
    required this.title,
    required this.country,
    required this.isHalal,
    required this.readyInMinutes,
    required this.servings,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    this.original,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      image: (json['image'] as String?) ?? '',
      title: (json['title'] as String?) ?? 'Tanpa Judul',
      country: (json['country'] as String?) ?? 'Global',
      isHalal: (json['isHalal'] as bool?) ?? true,
      readyInMinutes: json['readyInMinutes']?.toString() ?? '-',
      servings: json['servings']?.toString() ?? '-',
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : 4.5,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
      nutrition: (json['nutrition'] as Map?) != null
          ? Map<String, String>.from(
              (json['nutrition'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : <String, String>{},
      original: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'country': country,
      'isHalal': isHalal,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'rating': rating,
      'ingredients': ingredients,
      'instructions': instructions,
      'nutrition': nutrition,
      'original': original,
    };
  }

  factory RecipeModel.fromMap(dynamic m) {
    if (m == null) {
      return const RecipeModel(
        id: 0,
        image: '',
        title: 'Tanpa Judul',
        country: 'Global',
        isHalal: true,
        readyInMinutes: '-',
        servings: '-',
        rating: 4.5,
        ingredients: <String>[],
        instructions: <String>[],
        nutrition: <String, String>{},
        original: null,
      );
    }

    final Map<String, dynamic> map = (m is Map<String, dynamic>)
        ? m
        : <String, dynamic>{};

    String extractImage() {
      final image = map['image'];
      if (image is String && image.isNotEmpty) return image;

      final images = map['images'];
      if (images is List && images.isNotEmpty) {
        return images.first.toString();
      }
      return '';
    }

    List<String> parseIngredients() {
      final extended = map['extendedIngredients'];
      if (extended is List) {
        return extended
            .map((e) {
              if (e is Map &&
                  (e['originalString'] != null || e['original'] != null)) {
                return (e['originalString'] ?? e['original'] ?? '').toString();
              }
              return e.toString();
            })
            .where((s) => s.isNotEmpty)
            .toList();
      }

      final basic = map['ingredients'];
      if (basic is List) {
        return basic.map((e) => e.toString()).toList();
      }
      return <String>[];
    }

    List<String> parseInstructions() {
      final analyzed = map['analyzedInstructions'];
      if (analyzed is List && analyzed.isNotEmpty) {
        final steps = <String>[];
        for (final part in analyzed) {
          if (part is Map && part['steps'] is List) {
            for (final s in part['steps'] as List) {
              if (s is Map && s['step'] != null) {
                steps.add(s['step'].toString());
              }
            }
          }
        }
        return steps;
      }

      final rawInstructions = map['instructions'];
      if (rawInstructions is String) {
        return rawInstructions
            .split(RegExp(r'\n+|(?<=\.)\s+'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }

      return <String>[];
    }

    Map<String, String> parseNutrition() {
      final result = <String, String>{};
      final nutrition = map['nutrition'];

      if (nutrition is Map && nutrition['nutrients'] is List) {
        for (final n in nutrition['nutrients'] as List) {
          if (n is Map &&
              n['name'] != null &&
              n['amount'] != null &&
              n['unit'] != null) {
            result[n['name'].toString()] =
                '${n['amount'].toString()} ${n['unit'].toString()}';
          }
        }
      } else if (nutrition is Map) {
        nutrition.forEach((key, value) {
          result[key.toString()] = value.toString();
        });
      }

      return result;
    }

    final cuisines = map['cuisines'];
    final country = (cuisines is List && cuisines.isNotEmpty)
        ? cuisines.first.toString()
        : (map['country']?.toString() ?? 'Global');

    final ingredients = parseIngredients();
    final isHalal = checkHalalStatus(ingredients);

    final ready =
        map['readyInMinutes']?.toString() ??
        map['ready_time']?.toString() ??
        '-';

    final servings =
        map['servings']?.toString() ?? map['servings_count']?.toString() ?? '-';

    final rating = map['spoonacularScore'] is num
        ? (map['spoonacularScore'] as num).toDouble() / 20.0 + 3.0
        : (map['rating'] is num ? (map['rating'] as num).toDouble() : 4.5);

    final id = map['id'] is int
        ? map['id'] as int
        : int.tryParse(map['id']?.toString() ?? '') ?? 0;

    return RecipeModel(
      id: id,
      image: extractImage(),
      title: map['title']?.toString() ?? 'Tanpa Judul',
      country: country,
      isHalal: isHalal,
      readyInMinutes: ready,
      servings: servings,
      rating: rating,
      ingredients: ingredients,
      instructions: parseInstructions(),
      nutrition: parseNutrition(),
      original: map,
    );
  }
}
