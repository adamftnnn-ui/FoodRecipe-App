import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  /// items: [
  ///   {'icon': Icons.person, 'title': 'Akun', 'onTap': () {}},
  /// ]
  final List<Map<String, dynamic>> items;

  const ProfileOption({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final IconData? icon = item['icon'] as IconData?;
          final String title = item['title']?.toString() ?? '';
          final VoidCallback onTap = (item['onTap'] as VoidCallback?) ?? () {};

          return Column(
            children: [
              ListTile(
                leading: icon != null
                    ? Icon(icon, color: Colors.grey[500])
                    : null,
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: onTap,
              ),
              if (index != items.length - 1)
                Divider(height: 1, color: Colors.grey[200]),
            ],
          );
        }),
      ),
    );
  }
}
