import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/detail_recipe_controller.dart';
import '../widgets/header_section.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/instruction_section.dart';
import '../widgets/nutrition_section.dart';

class DetailRecipeView extends StatefulWidget {
  final DetailRecipeController controller;

  const DetailRecipeView({super.key, required this.controller});

  @override
  State<DetailRecipeView> createState() => _DetailRecipeViewState();
}

class _DetailRecipeViewState extends State<DetailRecipeView> {
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    try {
      await widget.controller.fetchRecipeFromApi();
    } catch (e) {
      error = e.toString();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text("Gagal memuat: $error")));
    }

    final recipe = controller.recipe;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // ... header bar PUNYA KAMU TADI (tidak diubah)
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
                        'Detail Resep',
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

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    HeaderSection(recipe: recipe),
                    const SizedBox(height: 16),
                    IngredientsSection(
                      ingredients: controller.getIngredients(),
                    ),
                    const SizedBox(height: 16),
                    InstructionSection(
                      instructions: controller.getInstructions(),
                    ),
                    const SizedBox(height: 16),
                    NutritionSection(nutrition: controller.getNutrition()),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
