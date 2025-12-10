import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionDialog extends StatefulWidget {
  final Function(String label, String value) onSave;

  const NutritionDialog({super.key, required this.onSave});

  @override
  State<NutritionDialog> createState() => _NutritionDialogState();
}

class _NutritionDialogState extends State<NutritionDialog> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    final label = _labelController.text.trim();
    final value = _valueController.text.trim();
    if (label.isNotEmpty && value.isNotEmpty) {
      widget.onSave(label, value);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Nutrition', style: GoogleFonts.poppins()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _labelController,
            decoration: InputDecoration(
              hintText: 'Label (e.g., Calories)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _valueController,
            decoration: InputDecoration(
              hintText: 'Value (e.g., 200 kcal)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.poppins()),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text('Save', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}
