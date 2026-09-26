import 'dart:async';

import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pink = Color(0xFFD77FA3);
  static const Color purple = Color(0xFF8B6DEB);
  static const Color blue = Color(0xFF83CFE3);
  static const Color darkText = Color(0xFF29243A);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // Pindah ke Login setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            // ==================================================
            // BACKGROUND DECORATION
            // ==================================================

            Positioned(
              top: -130,
              left: -100,
              child: _decorativeCircle(
                size: 330,
                color: pink.withValues(alpha: 0.25),
              ),
            ),

            Positioned(
              bottom: -150,
              right: -100,
              child: _decorativeCircle(
                size: 360,
                color: purple.withValues(alpha: 0.22),
              ),
            ),

            Positioned(
              top: 120,
              right: -60,
              child: _decorativeCircle(
                size: 190,
                color: blue.withValues(alpha: 0.22),
              ),
            ),

            Positioned(
              bottom: 120,
              left: 70,
              child: _decorativeCircle(
                size: 90,
                color: pink.withValues(alpha: 0.15),
              ),
            ),

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==================================================
                    // LOGO DIGIMART
                    // SAMA DENGAN LOGO DI PAGE BERIKUTNYA
                    // ==================================================

                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            purple,
                            pink,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: purple.withValues(alpha: 0.22),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // NAMA DIGIMART
                    // ==================================================

                    const Text(
                      'DIGIMART',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      'Digital products, made beautifully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkText.withValues(alpha: 0.62),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // LOADING
                    // ==================================================

                    SizedBox(
                      width: 27,
                      height: 27,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // COPYRIGHT
            // ==================================================

            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Text(
                'DIGIMART © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkText.withValues(alpha: 0.42),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DECORATIVE CIRCLE
  // ============================================================

  Widget _decorativeCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}