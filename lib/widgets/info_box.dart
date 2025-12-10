import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class InfoBox extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController servingController;
  final String? selectedCountry;
  final bool isHalal;
  final String? selectedImage;
  final VoidCallback onImageTap;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<bool> onHalalChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onTimeChanged;
  final ValueChanged<String> onServingChanged;

  const InfoBox({
    super.key,
    required this.titleController,
    required this.timeController,
    required this.servingController,
    required this.selectedCountry,
    required this.isHalal,
    required this.selectedImage,
    required this.onImageTap,
    required this.onCountryChanged,
    required this.onHalalChanged,
    required this.onTitleChanged,
    required this.onTimeChanged,
    required this.onServingChanged,
  });

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13.5, color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.green[500]!, width: 1.2),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey[50],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedImage01,
            color: Colors.grey[500],
            size: 26,
          ),
          const SizedBox(height: 6),
          Text(
            'Belum ada gambar',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 2),
          Text(
            'Tap untuk tambah gambar',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String img = (selectedImage ?? '').trim();
    final bool hasImage = img.isNotEmpty;
    final bool isNetworkImage = img.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasImage
                  ? (isNetworkImage
                        ? Image.network(
                            img,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          )
                        : Image.asset(
                            img,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          ))
                  : _buildImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Judul Resep',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: titleController,
            decoration: _inputDecoration('Judul resep kamu...').copyWith(
              prefixIcon: Icon(
                HugeIcons.strokeRoundedBookOpen01,
                size: 18,
                color: Colors.grey[500],
              ),
            ),
            onChanged: onTitleChanged,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Negara
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Negara',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _inputDecoration('Negara').copyWith(
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedEarth,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                      items: const ['Indonesia', 'Italy', 'Japan', 'India']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.poppins(fontSize: 13.5),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: onCountryChanged,
                      value: selectedCountry,
                      borderRadius: BorderRadius.circular(14),
                      icon: Icon(
                        HugeIcons.strokeRoundedArrowDown01,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Label Halal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Label',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                HugeIcons.strokeRoundedTag01,
                                size: 18,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Halal',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isHalal,
                            activeColor: Colors.green[500],
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey[300],
                            onChanged: onHalalChanged,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Durasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Durasi',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('0').copyWith(
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedClock01,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                        suffixText: 'Menit',
                        suffixStyle: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 13.5,
                        ),
                      ),
                      onChanged: onTimeChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Porsi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Porsi',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: servingController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('0').copyWith(
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedRiceBowl01,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                        suffixText: 'Porsi',
                        suffixStyle: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 13.5,
                        ),
                      ),
                      onChanged: onServingChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
