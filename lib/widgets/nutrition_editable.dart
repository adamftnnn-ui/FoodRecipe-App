import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'nutrition_dialog.dart';

class NutritionEditable extends StatefulWidget {
  final List<Map<String, String>> nutritions;
  final void Function(String label, String value) onAdd;
  final void Function(int index) onRemove;

  const NutritionEditable({
    super.key,
    required this.nutritions,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<NutritionEditable> createState() => _NutritionEditableState();
}

class _NutritionEditableState extends State<NutritionEditable> {
  void _handleAdd() {
    showDialog(
      context: context,
      builder: (_) => NutritionDialog(onSave: widget.onAdd),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nutrisi',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _handleAdd,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    HugeIcons.strokeRoundedAdd01,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.nutritions.isEmpty)
            Text(
              'Belum ada item',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
            )
          else
            Column(
              children: List.generate(widget.nutritions.length, (i) {
                final item = widget.nutritions[i];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['label'] ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['value'] ?? '',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => widget.onRemove(i),
                        child: Icon(
                          HugeIcons.strokeRoundedXVariableCircle,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
