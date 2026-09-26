import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AboutDeveloperScreen extends StatefulWidget {
  const AboutDeveloperScreen({super.key});

  @override
  State<AboutDeveloperScreen> createState() =>
      _AboutDeveloperScreenState();
}

class _AboutDeveloperScreenState
    extends State<AboutDeveloperScreen> {
  final Color pink = const Color(0xFFD85C96);
  final Color purple = const Color(0xFF7656D8);
  final Color blue = const Color(0xFF4BB9D5);
  final Color darkText = const Color(0xFF29243A);
  final Color background = const Color(0xFFF8F7FF);

  String name = 'Jois Miranda Agunning Putri';
  String study = 'Teknik Informatika';
  String description =
      'Mahasiswa Teknik Informatika yang tertarik dengan teknologi, desain, dan pengembangan aplikasi digital.';

  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('developer_name') ??
          'Jois Miranda Agunning Putri';

      study = prefs.getString('developer_study') ??
          'Teknik Informatika';

      description = prefs.getString(
            'developer_description',
          ) ??
          'Mahasiswa Teknik Informatika yang tertarik dengan teknologi, desain, dan pengembangan aplikasi digital.';

      profileImagePath =
          prefs.getString('profile_image_path');
    });
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'profile_image_path',
      image.path,
    );

    setState(() {
      profileImagePath = image.path;
    });
  }

  Future<void> _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: name,
          currentStudy: study,
          currentDescription: description,
        ),
      ),
    );

    _loadProfile();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Keluar dari DigiMart?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Kamu akan kembali ke halaman login.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: darkText,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                pink,
                purple,
                blue,
              ],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'DIGIMART',
          style: TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _navItem({
    required String title,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active
              ? purple.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: active ? purple : darkText,
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: active ? purple : darkText,
                fontWeight:
                    active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: purple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: purple,
          size: 21,
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLogo(),

          const Spacer(),

          _navItem(
            title: 'Home',
            icon: Icons.home_outlined,
            active: false,
            onTap: _goHome,
          ),

          const SizedBox(width: 10),

          _navItem(
            title: 'About',
            icon: Icons.person_outline_rounded,
            active: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavbar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLogo(),

          const Spacer(),

          _smallNavButton(
            icon: Icons.home_outlined,
            onTap: _goHome,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImagePath != null &&
        profileImagePath!.isNotEmpty &&
        File(profileImagePath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.file(
          File(profileImagePath!),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.asset(
        'assets/images/jois miranda.jpeg',
        width: 150,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pink,
                  purple,
                  blue,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 75,
            ),
          );
        },
      ),
    );
  }
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildProfileImage(),

              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: _pickProfileImage,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          pink,
                          purple,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkText,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: purple.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              study,
              style: TextStyle(
                color: purple,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkText.withValues(alpha: 0.65),
              height: 1.6,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(
                Icons.edit_rounded,
                size: 18,
              ),
              label: const Text(
                'Edit Profile',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  text,
                  style: TextStyle(
                    color: darkText.withValues(alpha: 0.60),
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 25,
      ),
      color: darkText,
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'DIGIMART',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Digital Templates for Your Creative Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.60),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '© 2026 DigiMart',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.40),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop =
                constraints.maxWidth >= 800;

            return Column(
              children: [
                if (isDesktop)
                  _buildNavbar()
                else
                  _buildMobileNavbar(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                isDesktop ? 60 : 20,
                            vertical: 40,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'About Developer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkText,
                                  fontSize:
                                      isDesktop ? 38 : 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Kenalan lebih dekat dengan developer DigiMart',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkText.withValues(
                                    alpha: 0.55,
                                  ),
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 40),

                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(
                                  maxWidth: 1100,
                                ),
                                child: isDesktop
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          SizedBox(
                                            width: 380,
                                            child:
                                                _buildProfileCard(),
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                _buildInfoCard(
                                                  icon: Icons
                                                      .school_rounded,
                                                  title:
                                                      'Education',
                                                  text:
                                                      'Mahasiswa Program Studi Teknik Informatika yang sedang mengembangkan kemampuan di bidang teknologi dan aplikasi digital.',
                                                  color:
                                                      purple,
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                _buildInfoCard(
                                                  icon: Icons
                                                      .palette_rounded,
                                                  title:
                                                      'Interest',
                                                  text:
                                                      'Tertarik dengan teknologi, desain UI/UX, pengembangan aplikasi, dan berbagai produk digital.',
                                                  color:
                                                      pink,
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                _buildInfoCard(
                                                  icon: Icons
                                                      .auto_awesome_rounded,
                                                  title:
                                                      'DigiMart',
                                                  text:
                                                      'DigiMart dibuat sebagai platform sederhana untuk menyediakan berbagai template digital yang praktis dan menarik.',
                                                  color:
                                                      blue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _buildProfileCard(),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          _buildInfoCard(
                                            icon: Icons
                                                .school_rounded,
                                            title: 'Education',
                                            text:
                                                'Mahasiswa Program Studi Teknik Informatika yang sedang mengembangkan kemampuan di bidang teknologi dan aplikasi digital.',
                                            color: purple,
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          _buildInfoCard(
                                            icon: Icons
                                                .palette_rounded,
                                            title: 'Interest',
                                            text:
                                                'Tertarik dengan teknologi, desain UI/UX, pengembangan aplikasi, dan berbagai produk digital.',
                                            color: pink,
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          _buildInfoCard(
                                            icon: Icons
                                                .auto_awesome_rounded,
                                            title: 'DigiMart',
                                            text:
                                                'DigiMart dibuat sebagai platform sederhana untuk menyediakan berbagai template digital yang praktis dan menarik.',
                                            color: blue,
                                          ),
                                        ],
                                      ),
                              ),

                              const SizedBox(height: 45),

                              SizedBox(
                                width: 180,
                                child: OutlinedButton.icon(
                                  onPressed: _logout,
                                  icon: const Icon(
                                    Icons.logout_rounded,
                                  ),
                                  label: const Text(
                                    'Logout',
                                  ),
                                  style:
                                      OutlinedButton.styleFrom(
                                    foregroundColor: pink,
                                    side: BorderSide(
                                      color: pink,
                                    ),
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      vertical: 14,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}