import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/create_recipe_controller.dart';
import '../controllers/recipe_list_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/detail_recipe_controller.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import 'create_recipe_view.dart';
import 'detail_recipe_view.dart';

class RecipeListView extends StatefulWidget {
  final String initialKeyword;
  final String title;
  final List<dynamic>? recipes;
  final bool showDelete;
  final ProfileController? profileController;

  const RecipeListView({
    super.key,
    required this.initialKeyword,
    this.title = 'Daftar Resep',
    this.recipes,
    this.showDelete = false,
    this.profileController,
  });

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeIn;
  late final RecipeListController controller;

  @override
  void initState() {
    super.initState();
    controller = RecipeListController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  Future<void> _deleteRecipe(int index) async {
    if (!(widget.showDelete && widget.profileController != null)) return;

    // Dialog konfirmasi
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus resep?'),
          content: const Text(
            'Yakin ingin menghapus resep ini? Tindakan ini tidak bisa dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      widget.profileController!.removeRecipeAt(index);
      // UI otomatis update karena pakai ValueListenableBuilder
    }
  }

  void _editRecipe(int index) {
    if (widget.profileController == null) return;

    // Ambil resep TERKINI dari ProfileController, bukan dari widget.recipes
    final List<Map<String, dynamic>> currentRecipes =
        widget.profileController!.userRecipes.value;
    if (index < 0 || index >= currentRecipes.length) return;

    final Map<String, dynamic> recipe = currentRecipes[index];

    final createController = CreateRecipeController();

    createController.setTitle(recipe['title']?.toString() ?? '');
    createController.setCountry(recipe['country']?.toString() ?? '');
    createController.setHalal(recipe['isHalal'] as bool? ?? false);
    createController.setTime(recipe['readyInMinutes']?.toString() ?? '');
    createController.setServing(recipe['servings']?.toString() ?? '');
    createController.setIngredients(
      List<String>.from(recipe['ingredients'] ?? const <String>[]),
    );
    createController.setSteps(
      List<String>.from(recipe['steps'] ?? const <String>[]),
    );
    createController.setNutritions(
      List<Map<String, String>>.from(
        recipe['nutritions'] ?? const <Map<String, String>>[],
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateRecipeView(
          controller: createController,
          profileController: widget.profileController!,
          isEditMode: true,
          editIndex: index,
        ),
      ),
    );
    // Tidak butuh then(setState) karena ProfileController pakai ValueNotifier
  }

  void _openDetail(dynamic raw) {
    final detailController = DetailRecipeController(recipeData: raw);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailRecipeView(controller: detailController),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildGrid(
    List<dynamic> recipes,
    ThemeData theme,
    double infoCardWidth,
    double spacing,
  ) {
    if (recipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                HugeIcons.strokeRoundedSearch01,
                color: Colors.grey[300],
                size: 60,
              ),
              const SizedBox(height: 14),
              Text(
                widget.initialKeyword.isEmpty
                    ? 'Belum ada resep'
                    : 'Tidak ada resep untuk "${widget.initialKeyword}"',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(recipes.length, (int index) {
            final dynamic raw = recipes[index];

            dynamic recipeForCard = raw;
            String image;
            String title;
            bool isHalal;
            String country;
            String readyInMinutes;
            String servings;
            double rating;

            if (raw is Map<String, dynamic>) {
              final map = raw;

              image = (map['image'] ?? '').toString();
              title = (map['title'] ?? 'Tanpa Judul').toString();

              // Halal dari map
              final dynamic halalVal =
                  map['isHalal'] ?? map['halal'] ?? map['is_halal'];
              if (halalVal is bool) {
                isHalal = halalVal;
              } else if (halalVal is String) {
                isHalal = halalVal.toLowerCase().trim() == 'true';
              } else if (halalVal is num) {
                isHalal = halalVal != 0;
              } else {
                isHalal = true;
              }

              // Country + fallback dari cuisines
              dynamic countryVal = map['country'];
              if (countryVal == null || countryVal.toString().trim().isEmpty) {
                final cuisines = map['cuisines'];
                if (cuisines is List && cuisines.isNotEmpty) {
                  countryVal = cuisines.first.toString();
                }
              }
              country = (countryVal ?? 'Tidak Diketahui').toString();

              readyInMinutes =
                  (map['readyInMinutes'] ?? map['ready_time'] ?? '-')
                      .toString();
              servings = (map['servings'] ?? map['servings_count'] ?? '-')
                  .toString();

              final dynamic ratingVal =
                  map['rating'] ?? map['spoonacularScore'];
              if (ratingVal is num) {
                rating = ratingVal.toDouble();
              } else {
                rating = 4.5;
              }
            } else if (raw is RecipeModel) {
              final r = raw;
              image = r.image;
              title = r.title;
              isHalal = r.isHalal;
              country = r.country;
              readyInMinutes = r.readyInMinutes;
              servings = r.servings;
              rating = r.rating;
            } else {
              image = '';
              title = 'Tanpa Judul';
              isHalal = true;
              country = 'Tidak Diketahui';
              readyInMinutes = '-';
              servings = '-';
              rating = 4.5;
            }

            return SizedBox(
              width: infoCardWidth,
              child: RecipeCard(
                recipe: recipeForCard,
                image: image,
                title: title,
                isHalal: isHalal,
                country: country,
                readyInMinutes: readyInMinutes,
                servings: servings,
                rating: rating,
                showDelete: widget.showDelete,
                onDelete: () => _deleteRecipe(index),
                showEdit: widget.showDelete,
                onEdit: () => _editRecipe(index),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double spacing = 14;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double infoCardWidth = (screenWidth - (20 * 2) - spacing) / 2;

    final bool isMyRecipes =
        widget.showDelete && widget.profileController != null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),
            SearchBarr(
              initialValue: widget.initialKeyword,
              enableNavigation: true,
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FadeTransition(
                opacity: _fadeIn,
                child: isMyRecipes
                    // 🔹 Mode "Resepku" → langsung dengar ke userRecipes
                    ? ValueListenableBuilder<List<Map<String, dynamic>>>(
                        valueListenable: widget.profileController!.userRecipes,
                        builder: (context, recipes, _) {
                          return _buildGrid(
                            recipes,
                            theme,
                            infoCardWidth,
                            spacing,
                          );
                        },
                      )
                    // 🔹 Mode normal (search / API)
                    : FutureBuilder<List<dynamic>>(
                        future: widget.recipes != null
                            ? Future.value(widget.recipes)
                            : controller.fetchRecipesByFilter(
                                widget.initialKeyword,
                              ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final List<dynamic> recipes =
                              snapshot.data ?? <dynamic>[];

                          return _buildGrid(
                            recipes,
                            theme,
                            infoCardWidth,
                            spacing,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
