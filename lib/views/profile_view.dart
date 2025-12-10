import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/profile_controller.dart';
import 'recipe_list_view.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller;

  const ProfileView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: controller.userNotifier,
            builder: (context, user, _) {
              final avatarUrl = (user['avatarUrl'] as String?) ?? '';

              Widget avatarWidget;
              if (avatarUrl.isNotEmpty) {
                if (avatarUrl.startsWith('http')) {
                  avatarWidget = Image.network(
                    avatarUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  );
                } else {
                  avatarWidget = Image.asset(
                    avatarUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  );
                }
              } else {
                avatarWidget = Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[50],
                  alignment: Alignment.center,
                  child: Text(
                    'Tidak ada gambar',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Profil',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: avatarWidget,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name']?.toString() ?? '-',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user['country']?.toString() ?? '-',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        HugeIcons.strokeRoundedEdit01,
                                        color: Colors.green[500],
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        HugeIcons.strokeRoundedMan,
                                        size: 14,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        user['gender']?.toString() ?? '-',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        HugeIcons.strokeRoundedUploadCircle01,
                                        size: 14,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${controller.userRecipes.value.length} Posting',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Icon(
                                    HugeIcons.strokeRoundedShare01,
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
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Personalisasi'),
                  const SizedBox(height: 8),
                  _buildMenuCard(context, [
                    {
                      'icon': HugeIcons.strokeRoundedRiceBowl01,
                      'title': 'Resepku',
                      'onTap': () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeListView(
                              initialKeyword: '',
                              title: 'Daftar Resepku',
                              recipes: controller.userRecipes.value,
                              showDelete: true,
                              profileController: controller,
                            ),
                          ),
                        );
                      },
                    },
                    {
                      'icon': HugeIcons.strokeRoundedBookmark01,
                      'title': 'Simpanan',
                    },
                    {'icon': HugeIcons.strokeRoundedStar, 'title': 'Penilaian'},
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Pengaturan'),
                  const SizedBox(height: 8),
                  _buildMenuCard(context, [
                    {'icon': HugeIcons.strokeRoundedProfile, 'title': 'Akun'},
                    {'icon': HugeIcons.strokeRoundedEarth, 'title': 'Bahasa'},
                    {
                      'icon': HugeIcons.strokeRoundedNotification01,
                      'title': 'Notifikasi',
                    },
                    {
                      'icon': HugeIcons.strokeRoundedMoon01,
                      'title': 'Mode Gelap',
                    },
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Bantuan'),
                  const SizedBox(height: 8),
                  _buildMenuCard(context, [
                    {
                      'icon': HugeIcons.strokeRoundedHelpCircle,
                      'title': 'Pusat Bantuan',
                    },
                  ]),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedLogout01,
                            size: 24,
                            color: Colors.red[500],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keluar',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  size: 20,
                  color: Colors.grey[700],
                ),
                title: Text(
                  item['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[700],
                ),
                onTap: item['onTap'] as void Function()? ?? () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              if (index != items.length - 1)
                const Divider(height: 1, indent: 12, endIndent: 12),
            ],
          );
        }),
      ),
    );
  }
}
