import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';
import 'surprise_hub_screen.dart';

class AnimeGirlCakeScreen extends StatefulWidget {
  final BirthdayConfig config;
  final String selectedCakeTitle;
  final String imageLitPath;
  final String imageBlownPath;

  const AnimeGirlCakeScreen({
    super.key,
    required this.config,
    this.selectedCakeTitle = 'Heart Strawberry Cream 🍓',
    this.imageLitPath = 'assets/images/anime_holding_strawberry_21.png',
    this.imageBlownPath = 'assets/images/anime_holding_strawberry_blown_21.png',
  });

  @override
  State<AnimeGirlCakeScreen> createState() => _AnimeGirlCakeScreenState();
}

class _AnimeGirlCakeScreenState extends State<AnimeGirlCakeScreen> {
  late ConfettiController _confettiController;
  bool _candlesLit = true;
  bool _showNextButton = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _blowOutCandles() {
    if (!_candlesLit) return;

    setState(() {
      _candlesLit = false;
      _showNextButton = true;
    });

    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE05688),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '🎉 Make a Wish! Happy 21st Birthday ${widget.config.girlName}! ✨',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSurpriseHub() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: SurpriseHubScreen(config: widget.config),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Ambient Glow Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E0A17),
                      Color(0xFF4A182D),
                      Color(0xFF2C101B),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFFFFB6C1),
                  Color(0xFFFFD700),
                  Color(0xFFFF69B4),
                  Colors.white,
                  Color(0xFFDA70D6),
                ],
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

                  // Header Greeting (responsive, enforced single-line)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            'Happy 21st Birthday! ✨',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.greatVibes(
                              fontSize: size.width > 600 ? 44 : 36,
                              color: const Color(0xFFFFD1DC),
                              shadows: const [
                                Shadow(color: Color(0xFFFF69B4), blurRadius: 15),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 600.ms),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            widget.selectedCakeTitle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Photorealistic Anime Girl Holding Cake with Real 21 Candles
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: _blowOutCandles,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: size.height * 0.58,
                              maxWidth: size.width * 0.9,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF69B4).withValues(alpha: 0.35),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 700),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Image.asset(
                                  _candlesLit ? widget.imageLitPath : widget.imageBlownPath,
                                  key: ValueKey(_candlesLit),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ).animate().scale(duration: 700.ms, curve: Curves.easeOutBack),
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Blow Out Candles Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _candlesLit ? _blowOutCandles : null,
                            icon: Icon(
                              _candlesLit ? Icons.air_rounded : Icons.celebration_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              _candlesLit
                                  ? 'Blow Out Number 21 Candles 🌬️'
                                  : 'Candles Extinguished! 🎂✨',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _candlesLit ? const Color(0xFFE05688) : Colors.green,
                              disabledBackgroundColor: Colors.green.withValues(alpha: 0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Step Into Wishing World Button
                        if (_showNextButton || !_candlesLit)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToSurpriseHub,
                              icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                              label: Text(
                                'Step Into Surprise World 💖',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC73E6A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                elevation: 8,
                                shadowColor: const Color(0xFFFF69B4).withValues(alpha: 0.5),
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
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
}
