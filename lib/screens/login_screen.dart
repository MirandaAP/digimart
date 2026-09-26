import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  // Warna utama DigiMart
  static const Color pink = Color(0xFFD77FA3);
  static const Color purple = Color(0xFF8B6DEB);
  static const Color darkText = Color(0xFF29243A);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // LOGIN
  // =========================

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _showMessage('Email wajib diisi!');
      return;
    }

    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
    ).hasMatch(email)) {
      _showMessage('Masukkan alamat Gmail yang valid!');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Password wajib diisi!');
      return;
    }

    // Object UserModel sebagai penerapan PBO
    final UserModel user = UserModel(
      name: 'DigiMart User',
      email: email,
      password: password,
    );

    // Contoh penggunaan method dari UserModel
    debugPrint(user.getUserInfo());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  // =========================
  // SNACKBAR
  // =========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkText,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE8F0),
              Color(0xFFE9E0FF),
              Color(0xFFDFF5FA),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Dekorasi blur kiri atas
            Positioned(
              top: -100,
              left: -80,
              child: _blurCircle(
                260,
                const Color(0xFFE5A5C0),
              ),
            ),

            // Dekorasi blur kanan bawah
            Positioned(
              bottom: -100,
              right: -60,
              child: _blurCircle(
                300,
                const Color(0xFF9D8AEF),
              ),
            ),

            // Dekorasi blur kanan tengah
            Positioned(
              top: 120,
              right: 100,
              child: _blurCircle(
                150,
                const Color(0xFF8EDBE8),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isMobile =
                            constraints.maxWidth < 800;

                        // =========================
                        // MOBILE
                        // =========================

                        if (isMobile) {
                          return Column(
                            children: [
                              _buildBrandSection(),
                              const SizedBox(height: 35),
                              _buildLoginCard(),
                            ],
                          );
                        }

                        // =========================
                        // DESKTOP / TABLET
                        // =========================

                        return Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildBrandSection(),
                            ),
                            const SizedBox(width: 70),
                            SizedBox(
                              width: 430,
                              child: _buildLoginCard(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BRAND SECTION
  // =========================

  Widget _buildBrandSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      purple,
                      pink,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: purple.withValues(alpha: 0.30),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'DIGIMART',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: darkText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 55),

          const Text(
            'Digital products,',
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w300,
              color: darkText,
              height: 1.1,
            ),
          ),

          const Text(
            'made beautifully.',
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w800,
              color: purple,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Discover digital products designed to make '
            'your work easier, smarter, and more creative.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: darkText.withValues(alpha: 0.70),
            ),
          ),

          const SizedBox(height: 35),

          // Feature chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _featureChip(
                Icons.auto_awesome_rounded,
                'Modern',
              ),
              _featureChip(
                Icons.download_rounded,
                'Instant Access',
              ),
              _featureChip(
                Icons.favorite_rounded,
                'Easy to Use',
              ),
            ],
          ),

          const SizedBox(height: 45),

          // Mini glass cards
          Row(
            children: [
              _miniGlassCard(
                Icons.description_outlined,
                'Templates',
              ),
              const SizedBox(width: 14),
              _miniGlassCard(
                Icons.palette_outlined,
                'Creative',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // LOGIN CARD
  // =========================

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.70),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: purple.withValues(alpha: 0.15),
                blurRadius: 35,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Login untuk melanjutkan ke DigiMart.',
                style: TextStyle(
                  color: darkText.withValues(alpha: 0.65),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller: emailController,
                hint: 'yourname@gmail.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // PASSWORD
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller: passwordController,
                hint: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                obscureText: isPasswordHidden,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordHidden =
                          !isPasswordHidden;
                    });
                  },
                  icon: Icon(
                    isPasswordHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: darkText.withValues(alpha: 0.55),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        purple,
                        pink,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: purple.withValues(
                          alpha: 0.28,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // OR
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: darkText.withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkText.withValues(
                          alpha: 0.50,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: darkText.withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // GOOGLE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showMessage(
                      'Google Sign-In akan kita aktifkan nanti.',
                    );
                  },
                  icon: const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        Colors.white.withValues(
                      alpha: 0.45,
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(
                        alpha: 0.80,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // SIGN UP
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: darkText.withValues(
                          alpha: 0.65,
                        ),
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(
        color: darkText,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: darkText.withValues(alpha: 0.40),
        ),
        prefixIcon: Icon(
          icon,
          color: purple,
          size: 21,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(
          alpha: 0.48,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.70),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.70),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: purple,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // =========================
  // FEATURE CHIP
  // =========================

  Widget _featureChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: purple,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // MINI GLASS CARD
  // =========================

  Widget _miniGlassCard(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: purple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: darkText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BLUR CIRCLE
  // =========================

  Widget _blurCircle(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.28),
      ),
    );
  }
}