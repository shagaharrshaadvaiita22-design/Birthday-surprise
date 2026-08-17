import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';

class FiveThingsScreen extends StatelessWidget {
  final BirthdayConfig config;

  const FiveThingsScreen({super.key, required this.config});

  static const List<Map<String, dynamic>> _traits = [
    {
      'number': '1',
      'emoji': '🌸',
      'title': 'Incredibly Kind',
      'desc':
          'Your kindness is not just an action — it\'s who you are. You give warmth to everyone around you without even trying, and that is one of the rarest gifts a person can have.',
      'gradientColors': [Color(0xFFFF85A1), Color(0xFFFF4D7D)],
      'bgColor': Color(0xFF3D0A1E),
    },
    {
      'number': '2',
      'emoji': '🦁',
      'title': 'Brave at Heart',
      'desc':
          'You face life\'s challenges with a quiet, steady courage. Even when things get tough, you stand tall — and that inspires everyone lucky enough to know you.',
      'gradientColors': [Color(0xFFFFB347), Color(0xFFFF6B00)],
      'bgColor': Color(0xFF2A1500),
    },
    {
      'number': '3',
      'emoji': '🥰',
      'title': 'Adorable & Lovable',
      'desc':
          'Your sweetness and sparkle make everyone smile. You are adorable in every way, and your gentle heart lights up every room you enter.',
      'gradientColors': [Color(0xFFBA68C8), Color(0xFF7B1FA2)],
      'bgColor': Color(0xFF1A0A2E),
    },
    {
      'number': '4',
      'emoji': '✨',
      'title': 'Childlike Around Close Ones',
      'desc':
          'That pure, unfiltered playfulness you show around people you love? It\'s the most beautiful thing. You remind everyone that it\'s okay to just be yourself.',
      'gradientColors': [Color(0xFF64B5F6), Color(0xFF1565C0)],
      'bgColor': Color(0xFF0A1A2E),
    },
    {
      'number': '5',
      'emoji': '🧠',
      'title': 'Top Scorer & Dream Achiever',
      'desc':
          'You are always at the top in exams because of your hard work and dedication. Every dream you chase is one step closer to becoming your reality.',
      'gradientColors': [Color(0xFF81C784), Color(0xFF1B5E20)],
      'bgColor': Color(0xFF0A1E0A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C101B),
                      Color(0xFF4A182D),
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70),
                          tooltip: 'Back',
                        ),
                        Column(
                          children: [
                            Text(
                              '5 Things About You',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'What makes you truly one of a kind 🌟',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                        const MusicControlButton(size: 36),
                      ],
                    ),
                  ),

                  // Trait Cards
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _traits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, i) {
                        final trait = _traits[i];
                        final colors = trait['gradientColors'] as List<Color>;
                        return _buildTraitCard(trait, colors, i);
                      },
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

  Widget _buildTraitCard(
      Map<String, dynamic> trait, List<Color> colors, int index) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: (trait['bgColor'] as Color).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors[0].withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number + Emoji Stack
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    trait['number'] as String,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                trait['emoji'] as String,
                style: const TextStyle(fontSize: 26),
              ),
            ],
          ),

          const SizedBox(width: 18),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: colors,
                  ).createShader(bounds),
                  child: Text(
                    trait['title'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  trait['desc'] as String,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12.5,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (200 + index * 150).ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOut);
  }
}
