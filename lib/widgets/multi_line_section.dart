import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'multi_line_dialog.dart';

class MultiLineSection extends StatefulWidget {
  final String title;
  final List<String> items;
  final bool isNumbered;
  final bool bullet;
  final void Function(List<String>) onAdd;

  const MultiLineSection({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    this.isNumbered = false,
    this.bullet = false,
  });

  @override
  State<MultiLineSection> createState() => _MultiLineSectionState();
}

class _MultiLineSectionState extends State<MultiLineSection> {
  void _handleAdd() {
    showDialog(
      context: context,
      builder: (_) => MultiLineDialog(
        title: 'Add ${widget.title}',
        hint: 'Write each item on a new line',
        onSave: widget.onAdd,
      ),
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
                  widget.title,
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
          if (widget.items.isEmpty)
            Text(
              'Belum ada item',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
            )
          else
            Column(
              children: List.generate(widget.items.length, (i) {
                final item = widget.items[i];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isNumbered)
                        Container(
                          height: 22,
                          width: 22,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      if (widget.bullet && !widget.isNumbered)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 10, top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => widget.items.removeAt(i)),
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
