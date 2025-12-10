import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/recipe_list_view.dart';

class SuggestionWidget extends StatelessWidget {
  final List<String> suggestions;

  const SuggestionWidget({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox(height: 30);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: SizedBox(
        height: 30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final label = suggestions[index];

            // Ambil hanya 2 kata pertama untuk chip
            final shortLabel = label
                .trim()
                .split(RegExp(r'\s+'))
                .take(2)
                .join(' ');

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeListView(initialKeyword: label),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  shortLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                    height: 1.1,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
