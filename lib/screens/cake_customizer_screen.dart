import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';
import 'anime_girl_cake_screen.dart';

class CakeCustomizerScreen extends StatefulWidget {
  final BirthdayConfig config;

  const CakeCustomizerScreen({super.key, required this.config});

  @override
  State<CakeCustomizerScreen> createState() => _CakeCustomizerScreenState();
}

class _CakeCustomizerScreenState extends State<CakeCustomizerScreen> {
  int _selectedCakeIndex = 0;

  final List<Map<String, String>> _cakes = [
    {
      'id': 'strawberry',
      'title': 'Heart Strawberry Cream 🍓',
      'subtitle': 'Romantic fresh strawberry & vanilla whip cream cake',
      'imagePreview': 'assets/images/anime_holding_strawberry_21.png',
      'imageLit': 'assets/images/anime_holding_strawberry_21.png',
      'imageBlown': 'assets/images/anime_holding_strawberry_blown_21.png',
      'tag': 'Most Popular 💖',
    },
    {
      'id': 'chocolate',
      'title': 'Royal Chocolate Drip 🍫',
      'subtitle': 'Rich Belgian dark chocolate with gold leaf',
      'imagePreview': 'assets/images/anime_holding_choco_21.png',
      'imageLit': 'assets/images/anime_holding_choco_21.png',
      'imageBlown': 'assets/images/anime_holding_choco_blown_21.png',
      'tag': 'Decadent Luxury ✨',
    },
    {
      'id': 'rose',
      'title': 'Pastel Pink Rose Bouquet 🌸',
      'subtitle': 'Elegant buttercream roses with pearl toppings',
      'imagePreview': 'assets/images/anime_holding_rose_21.png',
      'imageLit': 'assets/images/anime_holding_rose_21.png',
      'imageBlown': 'assets/images/anime_holding_rose_blown_21.png',
      'tag': 'Princess Favorite 👑',
    },
  ];

  void _proceedWithCake(Map<String, String> cake) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: AnimeGirlCakeScreen(
              config: widget.config,
              selectedCakeTitle: cake['title']!,
              imageLitPath: cake['imageLit']!,
              imageBlownPath: cake['imageBlown']!,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Dark Soft Aesthetic Background
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

            Positioned(
              top: 12,
              right: 16,
              child: SafeArea(
                child: const MusicControlButton(size: 38),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Header Title (responsive, enforced single-line)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            'Pick Your Birthday Cake 🎂',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.greatVibes(
                              fontSize: 38,
                              color: const Color(0xFFFFD1DC),
                              shadows: const [
                                Shadow(color: Color(0xFFFF69B4), blurRadius: 12),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 600.ms),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              'Select your favorite realistic cake — ${widget.config.girlName} ✨',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cake Selection Cards Gallery
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: _cakes.length,
                      itemBuilder: (context, index) {
                        final cake = _cakes[index];
                        final isSelected = _selectedCakeIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCakeIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE05688).withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFFB6C1) : Colors.white24,
                                width: isSelected ? 2.5 : 1,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Cake Image Card
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.vertical(top: Radius.circular(22)),
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          cake['imagePreview']!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // Tag Pill
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.white30),
                                        ),
                                        child: Text(
                                          cake['tag']!,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFFFFD1DC),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Card Details
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cake['title']!,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              cake['subtitle']!,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white.withValues(alpha: 0.7),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Selection Radio Indicator
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(0xFFE05688)
                                              : Colors.white.withValues(alpha: 0.15),
                                          border: Border.all(
                                            color: isSelected ? Colors.white : Colors.white54,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check_rounded,
                                                color: Colors.white, size: 20)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 500.ms, delay: (100 * index).ms),
                        );
                      },
                    ),
                  ),

                  // Choose Cake & Present Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () => _proceedWithCake(_cakes[_selectedCakeIndex]),
                        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                        label: Text(
                          'Choose This Cake & Present 🎁',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE05688),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFFFF69B4).withValues(alpha: 0.5),
                        ),
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
