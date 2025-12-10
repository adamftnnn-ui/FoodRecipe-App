import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiLineDialog extends StatefulWidget {
  final String title;
  final String hint;
  final Function(List<String>) onSave;

  const MultiLineDialog({
    super.key,
    required this.title,
    required this.hint,
    required this.onSave,
  });

  @override
  State<MultiLineDialog> createState() => _MultiLineDialogState();
}

class _MultiLineDialogState extends State<MultiLineDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final lines = text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      widget.onSave(lines);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: GoogleFonts.poppins()),
      content: TextField(
        controller: _controller,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(),
        ),
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
