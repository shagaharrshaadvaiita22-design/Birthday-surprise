import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import 'login_screen.dart';
import 'cake_customizer_screen.dart';

class BlankScreen extends StatelessWidget {
  final BirthdayConfig config;

  const BlankScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Dark Aesthetic Ambient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1F0B17),
                      Color(0xFF381124),
                      Color(0xFF1E0A17),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Top Bar with Lock / Back option to return to Portal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(config: config),
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock_outline_rounded, color: Colors.white54),
                      tooltip: 'Return to Portal',
                    ),
                    Text(
                      'Princess Liki✨',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Blank Screen Placeholder Center Content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clean aesthetic blank canvas ready for next features
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFFFB6C1),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Birthday Surprise Workbench',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Craft your custom cake & blow out candles ✨',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CakeCustomizerScreen(config: config),
                          ),
                        );
                      },
                      icon: const Icon(Icons.cake_rounded, color: Colors.white),
                      label: Text(
                        'Open Cake Studio 🎂',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE05688),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
