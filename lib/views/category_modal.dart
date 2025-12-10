import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CategoryModal extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const CategoryModal({
    super.key,
    required this.title,
    required this.items,
    required this.onSelected,
  });

  IconData _getIcon(String title, String item) {
    switch (title) {
      case 'Negara':
        return HugeIcons.strokeRoundedEarth;
      case 'Halal':
        return HugeIcons.strokeRoundedHalal;
      case 'Diet':
        switch (item.toLowerCase()) {
          case 'vegetarian':
            return HugeIcons.strokeRoundedLeaf01;
          case 'vegan':
            return HugeIcons.strokeRoundedBalanceScale;
          case 'keto':
            return HugeIcons.strokeRoundedDrink;
          default:
            return HugeIcons.strokeRoundedHealth;
        }
      case 'Hidangan':
        switch (item.toLowerCase()) {
          case 'utama':
            return HugeIcons.strokeRoundedPlate;
          case 'pembuka':
            return HugeIcons.strokeRoundedSpoonAndFork;
          case 'penutup':
            return HugeIcons.strokeRoundedCheeseCake01;
          default:
            return HugeIcons.strokeRoundedPlate;
        }
      case 'Acara':
        return HugeIcons.strokeRoundedCalendar01;
      default:
        return HugeIcons.strokeRoundedCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                        size: 17,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 34),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey[500], height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getIcon(title, item),
                            size: 20,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Icon(
                            HugeIcons.strokeRoundedArrowRight01,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
