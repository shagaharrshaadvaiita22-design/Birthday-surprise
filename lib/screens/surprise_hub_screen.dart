import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';
import 'brother_letter_screen.dart';
import 'five_things_screen.dart';
import 'friend_memories_screen.dart';
import 'birthday_game_screen.dart';
import 'login_screen.dart';
import 'surprise_end_screen.dart';
import 'core_memories_screen.dart';


class SurpriseHubScreen extends StatelessWidget {
  final BirthdayConfig config;

  const SurpriseHubScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Dark Soft Ambient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C101B),
                      Color(0xFF4A182D),
                      Color(0xFF6B1D3D),
                      Color(0xFF1E0A17),
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
                  // App Bar Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          icon: const Icon(Icons.lock_outline_rounded, color: Colors.white70),
                          tooltip: 'Lock Portal',
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded,
                                  color: Color(0xFFFFB6C1), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${config.girlName}\'s Surprise World',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const MusicControlButton(size: 38),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Header Greeting
                  Text(
                    'Happy Birthday',
                    style: GoogleFonts.greatVibes(
                      fontSize: 38,
                      color: const Color(0xFFFFD1DC),
                    ),
                  ),
                  Text(
                    config.girlName.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFF69B4).withValues(alpha: 0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 20),

                  // 4 Interactive Feature Cards List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      children: [
                        // Card 1 (TOP): Best Moments with Forever Friends 🎬 (Videos)
                        _buildFeatureCard(
                          context,
                          title: 'Best Moments with Forever Friends 🎬',
                          subtitle: 'Video compilations & memories created by your lifelong squad',
                          icon: Icons.video_library_rounded,
                          accentColor: const Color(0xFFBA68C8),
                          delayMs: 100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendMemoriesScreen(config: config),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Card 2: 5 Things About You ✨
                        _buildFeatureCard(
                          context,
                          title: '5 Things About You ✨',
                          subtitle: 'Discover the special qualities that make you truly amazing',
                          icon: Icons.star_rounded,
                          accentColor: const Color(0xFF80D8FF),
                          delayMs: 250,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FiveThingsScreen(config: config),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Card 3 (MIDDLE): Birthday Girl's Fun Game (Pop the Wishes 🎈)
                        _buildFeatureCard(
                          context,
                          title: 'Birthday Girl\'s Fun Game 🎮🎈',
                          subtitle: 'Pop floating balloons & catch hearts to win your 21st Crown!',
                          icon: Icons.sports_esports_rounded,
                          accentColor: const Color(0xFFFFB300),
                          delayMs: 400,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BirthdayGameScreen(config: config),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Card 4 (BOTTOM): Letter from Your Brother 📜 (Letter)
                        _buildFeatureCard(
                          context,
                          title: 'Letter from Your Brother 📜',
                          subtitle: 'A heartfelt milestone letter & wishes written just for you',
                          icon: Icons.mark_email_read_rounded,
                          accentColor: const Color(0xFFFF85A1),
                          delayMs: 550,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrotherLetterScreen(config: config),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Card 5: Core Memories 📸💖
                        _buildFeatureCard(
                          context,
                          title: 'Core Memories 📸💖',
                          subtitle: 'A beautiful visual collection of your precious life moments',
                          icon: Icons.photo_library_rounded,
                          accentColor: const Color(0xFF1DE9B6),
                          delayMs: 700,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoreMemoriesScreen(config: config),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Card 6 (LAST): Final Birthday Splash 🎉
                        _buildFeatureCard(
                          context,
                          title: 'Final Birthday Splash 🎉',
                          subtitle: 'A cheerful send-off screen with a birthday message and next actions',
                          icon: Icons.celebration_rounded,
                          accentColor: const Color(0xFFFF6E40),
                          delayMs: 850,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurpriseEndScreen(config: config),
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required int delayMs,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Icon Pill
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),

            const SizedBox(width: 16),

            // Card Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delayMs.ms).slideY(begin: 0.1, end: 0);
  }
}
