import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';
import 'birthday_game_screen.dart';
import 'login_screen.dart';

class SurpriseEndScreen extends StatelessWidget {
  final BirthdayConfig config;

  const SurpriseEndScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C101B),
                      Color(0xFF4A1B2F),
                      Color(0xFF6C1E43),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70),
                          tooltip: 'Back',
                        ),
                        Text(
                          'Final Wishes',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const MusicControlButton(size: 38),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cake_rounded,
                            color: Color(0xFFFFD1DC),
                            size: 60,
                          ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 24),
                          Text(
                            'Happiest Birthday, ${config.girlName}!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.greatVibes(
                              color: Colors.white,
                              fontSize: 46,
                              shadows: [
                                Shadow(
                                  blurRadius: 22,
                                  color: const Color(0xFFFFB6C1).withValues(alpha: 0.85),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms),
                          const SizedBox(height: 14),
                          Text(
                            'Hope you liked my app!😁 Give ratings at the end, and always keep smiling 💖😄, my sweet sister🥰.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ).animate().fadeIn(duration: 900.ms, delay: 120.ms),
                          const SizedBox(height: 26),
                          Text(
                            'Your joy means everything. Choose where to go next and keep the celebration going!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ).animate().fadeIn(duration: 900.ms, delay: 220.ms),
                          const SizedBox(height: 40),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BirthdayGameScreen(config: config),
                                ),
                              );
                            },
                            icon: const Icon(Icons.videogame_asset_rounded, size: 20),
                            label: const Text('Go to Game'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB300),
                              foregroundColor: Colors.black,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 320.ms),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(config: config),
                                ),
                              );
                            },
                            icon: const Icon(Icons.login_rounded, size: 20),
                            label: const Text('Return to Login'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.7), width: 1.5),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 420.ms),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
