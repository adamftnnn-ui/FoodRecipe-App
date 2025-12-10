import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/recipe_model.dart';

class HeaderSection extends StatelessWidget {
  final RecipeModel recipe;

  const HeaderSection({super.key, required this.recipe});

  Widget _buildNoImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[50],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedImage01,
            color: Colors.grey[500],
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada gambar',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String cleanImage = recipe.image.trim();
    final bool isNetworkImage = cleanImage.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: cleanImage.isNotEmpty
                ? (isNetworkImage
                      ? Image.network(
                          cleanImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildNoImagePlaceholder();
                          },
                        )
                      : Image.asset(
                          cleanImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildNoImagePlaceholder();
                          },
                        ))
                : _buildNoImagePlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recipe.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (recipe.isHalal)
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          HugeIcons.strokeRoundedHalal,
                          color: Colors.green[500],
                          size: 14,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.country,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InfoItem(
                      icon: HugeIcons.strokeRoundedClock01,
                      text: '${recipe.readyInMinutes} Menit',
                    ),
                    const SizedBox(width: 8),
                    _InfoItem(
                      icon: HugeIcons.strokeRoundedRiceBowl01,
                      text: '${recipe.servings} Porsi',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _RatingStars(rating: recipe.rating),
                    const Spacer(),
                    Icon(
                      HugeIcons.strokeRoundedShare01,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      HugeIcons.strokeRoundedBookmark01,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey[500]),
        ),
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  final double rating;
  const _RatingStars({required this.rating});

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
