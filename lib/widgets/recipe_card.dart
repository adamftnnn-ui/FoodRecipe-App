import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../views/detail_recipe_view.dart';
import '../controllers/detail_recipe_controller.dart';
import '../models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final dynamic recipe;
  final String image;
  final String title;
  final bool isHalal;
  final String country;
  final String readyInMinutes;
  final String servings;
  final double rating;
  final bool showDelete;
  final VoidCallback? onDelete;
  final bool showEdit;
  final VoidCallback? onEdit;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.image,
    required this.title,
    required this.isHalal,
    required this.country,
    required this.readyInMinutes,
    required this.servings,
    required this.rating,
    this.showDelete = false,
    this.onDelete,
    this.showEdit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool halalBadge = false;

    if (recipe is Map) {
      final map = recipe as Map;
      final val =
          map['isHalal'] ?? map['halal'] ?? map['is_halal'] ?? map['IsHalal'];
      halalBadge = val == true || val == 'true' || val == 1;
    } else if (recipe is RecipeModel) {
      halalBadge = (recipe as RecipeModel).isHalal;
    } else {
      halalBadge = isHalal;
    }

    Widget _buildImagePlaceholder() {
      return Container(
        height: 110,
        width: double.infinity,
        color: Colors.grey[50],
        alignment: Alignment.center,
        child: Text(
          'Belum ada gambar',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailRecipeView(
              controller: DetailRecipeController(recipeData: recipe),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: image.isNotEmpty
                      ? (image.startsWith('http')
                            ? Image.network(
                                image,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder();
                                },
                              )
                            : Image.asset(
                                image,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder();
                                },
                              ))
                      : _buildImagePlaceholder(),
                ),
                if (showDelete)
                  Positioned(
                    top: 8,
                    right: showEdit ? 40 : 8, // <--- Jarak diperlebar (dulu 32)
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          HugeIcons.strokeRoundedDelete01,
                          color: Colors.red[600],
                          size: 14,
                        ),
                      ),
                    ),
                  ),

                if (showEdit)
                  Positioned(
                    top: 8,
                    right: 8, // <--- Tetap 8, tapi delete digeser
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          HugeIcons.strokeRoundedEdit01,
                          color: Colors.blue[600],
                          size: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (halalBadge)
                        Container(
                          height: 18,
                          width: 18,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedHalal,
                            color: Colors.green[500],
                            size: 13,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    country,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InfoItem(
                            HugeIcons.strokeRoundedClock01,
                            readyInMinutes,
                          ),
                          const SizedBox(width: 6),
                          InfoItem(HugeIcons.strokeRoundedRiceBowl01, servings),
                        ],
                      ),
                      RatingStars(rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoItem(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;

  const RatingStars(this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final half = index == rating.floor() && rating % 1 >= 0.5;
        return Icon(
          half ? Icons.star_half_rounded : Icons.star_rounded,
          size: 12,
          color: filled || half ? Colors.amber[500] : Colors.grey[300],
        );
      }),
    );
  }
}
