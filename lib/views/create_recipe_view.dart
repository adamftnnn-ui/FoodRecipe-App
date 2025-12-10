import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/create_recipe_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/multi_line_section.dart';
import '../widgets/nutrition_editable.dart';
import '../widgets/info_box.dart';
import '../controllers/detail_recipe_controller.dart';
import 'detail_recipe_view.dart';

class CreateRecipeView extends StatefulWidget {
  final CreateRecipeController controller;
  final ProfileController profileController;
  final VoidCallback? onRecipePosted;
  final bool isEditMode;
  final int? editIndex;

  const CreateRecipeView({
    super.key,
    required this.controller,
    required this.profileController,
    this.onRecipePosted,
    this.isEditMode = false,
    this.editIndex,
  });

  @override
  State<CreateRecipeView> createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<CreateRecipeView> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _timeC = TextEditingController();
  final TextEditingController _servingC = TextEditingController();

  String? _selectedCountry;
  bool _isHalal = false;
  String? _selectedImage;

  final List<String> _ingredients = [];
  final List<String> _steps = [];
  final List<Map<String, String>> _nutritions = [];

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.editIndex != null) {
      final recipe =
          widget.profileController.userRecipes.value[widget.editIndex!];

      widget.controller.setTitle(recipe['title'] ?? '');
      widget.controller.setCountry(recipe['country'] ?? '');
      widget.controller.setHalal(recipe['isHalal'] ?? false);
      widget.controller.setTime(recipe['readyInMinutes'] ?? '');
      widget.controller.setServing(recipe['servings'] ?? '');
      widget.controller.setIngredients(
        List<String>.from(recipe['ingredients'] ?? const <String>[]),
      );
      widget.controller.setSteps(
        List<String>.from(recipe['steps'] ?? const <String>[]),
      );
      widget.controller.setNutritions(
        List<Map<String, String>>.from(
          recipe['nutritions'] ?? const <Map<String, String>>[],
        ),
      );

      _titleC.text = widget.controller.title;
      _timeC.text = widget.controller.time;
      _servingC.text = widget.controller.serving;
      _selectedCountry = widget.controller.country;
      _isHalal = widget.controller.isHalal;
      _ingredients.addAll(widget.controller.ingredients);
      _steps.addAll(widget.controller.steps);
      _nutritions.addAll(widget.controller.nutritions);
      _selectedImage = recipe['image']?.toString();
    }
  }

  void _postRecipe() {
    final recipe = <String, dynamic>{
      'title': widget.controller.title,
      'country': widget.controller.country,
      'isHalal': widget.controller.isHalal,
      'readyInMinutes': widget.controller.time,
      'servings': widget.controller.serving,

      // PENTING: copy list, jangan referensi langsung
      'ingredients': List<String>.from(widget.controller.ingredients),
      'steps': List<String>.from(widget.controller.steps),
      'nutritions': List<Map<String, String>>.from(
        widget.controller.nutritions,
      ),

      'image': _selectedImage ?? '',
    };

    if (widget.isEditMode && widget.editIndex != null) {
      // 🔹 UPDATE resep lama di ProfileController
      widget.profileController.updateRecipeAt(widget.editIndex!, recipe);
    } else {
      // 🔹 CREATE resep baru
      widget.profileController.addRecipe(recipe);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditMode
              ? 'Resep berhasil diperbarui!'
              : 'Resep berhasil diposting!',
        ),
      ),
    );

    // Reset controller & state lokal (optional, biar bersih)
    widget.controller.clearAll();
    setState(() {
      _titleC.clear();
      _timeC.clear();
      _servingC.clear();
      _selectedCountry = null;
      _isHalal = false;
      _ingredients.clear();
      _steps.clear();
      _nutritions.clear();
      _selectedImage = null;
    });

    if (widget.isEditMode) {
      // 🔻 MODE EDIT:
      // ganti halaman Edit dengan Detail Resep yang baru di-update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DetailRecipeView(
            controller: DetailRecipeController(
              recipeData: recipe, // kirim map hasil edit
            ),
          ),
        ),
      );
    } else {
      // 🔻 MODE CREATE:
      // tetap pakai flow lama → parent (HomeView) yang direct ke Profil → Resepku
      widget.onRecipePosted?.call();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.isEditMode ? 'Edit Resep' : 'Buat Resep',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InfoBox(
                titleController: _titleC,
                timeController: _timeC,
                servingController: _servingC,
                selectedCountry: _selectedCountry,
                isHalal: _isHalal,
                selectedImage: _selectedImage,
                onImageTap: () {
                  // TODO: implementasi pilih gambar (opsional)
                },
                onCountryChanged: (v) {
                  setState(() => _selectedCountry = v);
                  widget.controller.setCountry(v ?? '');
                },
                onHalalChanged: (v) {
                  setState(() => _isHalal = v);
                  widget.controller.setHalal(v);
                },
                onTitleChanged: widget.controller.setTitle,
                onTimeChanged: widget.controller.setTime,
                onServingChanged: widget.controller.setServing,
              ),
              const SizedBox(height: 20),
              MultiLineSection(
                title: 'Bahan-bahan',
                items: _ingredients,
                bullet: true,
                onAdd: (lines) {
                  setState(() => _ingredients.addAll(lines));
                  widget.controller.setIngredients(_ingredients);
                },
              ),
              const SizedBox(height: 20),
              MultiLineSection(
                title: 'Langkah-langkah',
                items: _steps,
                isNumbered: true,
                onAdd: (lines) {
                  setState(() => _steps.addAll(lines));
                  widget.controller.setSteps(_steps);
                },
              ),
              const SizedBox(height: 20),
              NutritionEditable(
                nutritions: _nutritions,
                onAdd: (label, value) {
                  setState(() {
                    _nutritions.add({'label': label, 'value': value});
                  });
                  widget.controller.setNutritions(_nutritions);
                },
                onRemove: (index) {
                  setState(() => _nutritions.removeAt(index));
                  widget.controller.setNutritions(_nutritions);
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _postRecipe,
                  child: Text(
                    widget.isEditMode ? 'Perbarui Resep' : 'Posting Resep',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
