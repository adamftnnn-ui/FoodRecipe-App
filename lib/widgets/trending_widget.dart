import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import '../views/recipe_list_view.dart';

class TrendingWidget extends StatelessWidget {
  final List<RecipeModel> recipes;

  const TrendingWidget({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Resep Trending",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // ✅ ubah List<RecipeModel> → List<Map<String, dynamic>>
                  final mapped = recipes.map((r) {
                    return {
                      'id': r.id,
                      'image': r.image,
                      'title': r.title,
                      'isHalal': r.isHalal,
                      'country': r.country,
                      'readyInMinutes': r.readyInMinutes,
                      'servings': r.servings,
                      'rating': r.rating,
                      'original': r.original,
                    };
                  }).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeListView(
                        initialKeyword: '',
                        title: 'Resep Trending',
                        recipes: mapped,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Lihat semua",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[500],
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final item = recipes[index];
                return RecipeCard(
                  recipe: item, // biar Detail pakai RecipeModel
                  image: item.image,
                  title: item.title,
                  isHalal: item.isHalal,
                  country: item.country,
                  readyInMinutes: item.readyInMinutes,
                  servings: item.servings,
                  rating: item.rating,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
