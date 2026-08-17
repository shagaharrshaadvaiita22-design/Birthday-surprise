import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../services/audio_manager.dart';
import '../widgets/music_control_button.dart';
import 'cake_customizer_screen.dart';

class SplashSequenceScreen extends StatefulWidget {
  final BirthdayConfig config;

  const SplashSequenceScreen({super.key, required this.config});

  @override
  State<SplashSequenceScreen> createState() => _SplashSequenceScreenState();
}

class _SplashSequenceScreenState extends State<SplashSequenceScreen> {
  int _currentPhase = 0; // 0: Happy Birthday (3s), 1: liki (3s)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AudioManager.instance.playHappyBirthday();
    _startSequence();
  }

  void _startSequence() {
    // Phase 0: "Happy Birthday" for 3 seconds -> move to Phase 1 ("liki")
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _currentPhase = 1;
      });

      // Phase 1: "liki" for 3 seconds -> move to CakeCustomizerScreen
      _timer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        _navigateToCakeCustomizer();
      });
    });
  }

  void _navigateToCakeCustomizer() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: CakeCustomizerScreen(config: widget.config),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1E0B15),
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Ambient Gradient Backdrop
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getBackgroundColors(),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Center Content displaying each 3-second phase
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: _buildPhaseWidget(size),
                  ),
                ),
              ),
            ),

            // Progress Indicator at top (2 dots representing 3-second stages)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      final isActive = index == _currentPhase;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFFB6C1)
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: const MusicControlButton(size: 38),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getBackgroundColors() {
    switch (_currentPhase) {
      case 0:
        return const [Color(0xFF2C101B), Color(0xFF5D1225), Color(0xFF2B0C18)];
      case 1:
        return const [Color(0xFF3B1223), Color(0xFF8B264E), Color(0xFF3B1223)];
      default:
        return const [Color(0xFF2C101B), Color(0xFF5D1225), Color(0xFF2B0C18)];
    }
  }

  Widget _buildPhaseWidget(Size size) {
    switch (_currentPhase) {
      // 0 to 3 seconds: "Happy Birthday"
      case 0:
        return Column(
          key: const ValueKey(0),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFFFD1DC),
              size: 40,
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(
              'Happy Birthday',
              textAlign: TextAlign.center,
              style: GoogleFonts.greatVibes(
                fontSize: size.width > 600 ? 72 : 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: const Color(0xFFFFB6C1).withValues(alpha: 0.9),
                    offset: const Offset(0, 0),
                  ),
                  const Shadow(
                    blurRadius: 10.0,
                    color: Colors.black45,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          ],
        );

      // 3 to 6 seconds: "liki"
      case 1:
        return Column(
          key: const ValueKey(1),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🦋',
              style: TextStyle(fontSize: 44),
            ).animate().slideY(begin: -0.3, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            Text(
              'likitha',
              textAlign: TextAlign.center,
              style: GoogleFonts.sacramento(
                fontSize: size.width > 600 ? 84 : 68,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD1DC),
                shadows: [
                  Shadow(
                    blurRadius: 25.0,
                    color: const Color(0xFFFF69B4).withValues(alpha: 0.95),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
