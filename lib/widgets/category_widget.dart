import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../controllers/category_controller.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  IconData _getIcon(String title) {
    switch (title) {
      case 'Halal':
        return HugeIcons.strokeRoundedHalal;
      case 'Diet':
        return HugeIcons.strokeRoundedHealth;
      case 'Hidangan':
        return HugeIcons.strokeRoundedPlate;
      case 'Acara':
        return HugeIcons.strokeRoundedSpoonAndFork;
      case 'Negara':
        return HugeIcons.strokeRoundedEarth;
      default:
        return HugeIcons.strokeRoundedCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Halal', 'Diet', 'Hidangan', 'Acara', 'Negara'];

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((label) {
                return GestureDetector(
                  onTap: () => CategoryController.showCategoryModal(
                    context,
                    title: label,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getIcon(label),
                          color: Colors.green[50],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
