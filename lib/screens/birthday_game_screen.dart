import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';

class BalloonItem {
  final int id;
  final String emoji;
  final Color color;
  final int points;
  double x; // 0.1 to 0.8
  double y; // 1.1 (bottom) to -0.2 (top)
  final double speed;
  bool isPopped;

  BalloonItem({
    required this.id,
    required this.emoji,
    required this.color,
    required this.points,
    required this.x,
    required this.y,
    required this.speed,
    this.isPopped = false,
  });
}

class BirthdayGameScreen extends StatefulWidget {
  final BirthdayConfig config;

  const BirthdayGameScreen({super.key, required this.config});

  @override
  State<BirthdayGameScreen> createState() => _BirthdayGameScreenState();
}

class _BirthdayGameScreenState extends State<BirthdayGameScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  Timer? _animationTimer;

  int _score = 0;
  int _timeLeft = 30;
  bool _isPlaying = false;
  int _nextBalloonId = 0;

  final List<BalloonItem> _balloons = [];
  final math.Random _random = math.Random();

  final List<Map<String, dynamic>> _balloonTypes = [
    {'emoji': '🎈', 'color': const Color(0xFFFF69B4), 'points': 10},
    {'emoji': '💖', 'color': const Color(0xFFFFB6C1), 'points': 15},
    {'emoji': '⭐', 'color': const Color(0xFFFFD700), 'points': 20},
    {'emoji': '🍓', 'color': const Color(0xFFE05688), 'points': 15},
    {'emoji': '🧁', 'color': const Color(0xFFBA68C8), 'points': 25},
    {'emoji': '👑', 'color': const Color(0xFFFFC107), 'points': 30},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));

    // Show Rules Dialog automatically on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRulesDialog();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A1B28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Color(0xFFFFB6C1)),
              const SizedBox(width: 8),
              Text(
                'How to Play Game 📜',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRuleItem('🎈 Rule 1', 'Tap floating balloons & hearts to pop them and reveal birthday wishes!'),
                const SizedBox(height: 10),
                _buildRuleItem('💖 Rule 2', 'Popping golden crowns 👑 & sweet treats 🧁 awards combo bonus points!'),
                const SizedBox(height: 10),
                _buildRuleItem('⏱️ Rule 3', 'You have 30 seconds! Pop as many as you can before time runs out.'),
                const SizedBox(height: 10),
                _buildRuleItem('👑 Rule 4', 'Reach 100+ points to win the Princess Crown & Confetti Explosion 🎉!'),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE05688),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _startGame();
                },
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                label: Text(
                  'Start Birthday Game 🚀',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRuleItem(String tag, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag,
          style: GoogleFonts.poppins(
            color: const Color(0xFFFFD1DC),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _isPlaying = true;
      _balloons.clear();
    });

    // 30-Second Countdown
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endGame();
      }
    });

    // Spawn Balloons every 600ms
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted || !_isPlaying) return;
      _spawnBalloon();
    });

    // Update balloon positions (float up)
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted || !_isPlaying) return;
      setState(() {
        for (var b in _balloons) {
          if (!b.isPopped) {
            b.y -= b.speed;
          }
        }
        _balloons.removeWhere((b) => b.y < -0.25 || (b.isPopped && b.y < -0.3));
      });
    });
  }

  void _spawnBalloon() {
    final type = _balloonTypes[_random.nextInt(_balloonTypes.length)];
    final balloon = BalloonItem(
      id: _nextBalloonId++,
      emoji: type['emoji'] as String,
      color: type['color'] as Color,
      points: type['points'] as int,
      x: 0.1 + _random.nextDouble() * 0.75,
      y: 1.1,
      speed: 0.008 + _random.nextDouble() * 0.008,
    );
    setState(() {
      _balloons.add(balloon);
    });
  }

  void _popBalloon(BalloonItem balloon) {
    if (balloon.isPopped || !_isPlaying) return;
    setState(() {
      balloon.isPopped = true;
      _score += balloon.points;
    });

    // Floating snackbar wish
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        backgroundColor: balloon.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(balloon.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              '+${balloon.points} pts! Happy Birthday ${widget.config.girlName}! ✨',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _animationTimer?.cancel();

    setState(() {
      _isPlaying = false;
    });

    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A1B28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Center(
            child: Text(
              _score >= 100 ? '👑 Birthday Champion! 👑' : '🎉 Great Game Princess! 🎉',
              textAlign: TextAlign.center,
              style: GoogleFonts.greatVibes(
                fontSize: 34,
                color: const Color(0xFFFFD1DC),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(
                'Final Score: $_score Points!',
                style: GoogleFonts.outfit(
                  color: Colors.amberAccent,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _score >= 100
                    ? 'Amazing! You unlocked the 21st Birthday Princess Crown! All your birthday wishes are officially granted ✨'
                    : 'You did super great! May your 21st year be filled with endless joy and happiness 💖',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startGame();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFB6C1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Play Again 🔄', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE05688),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Done 💖', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Ambient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C101B),
                      Color(0xFF5D1225),
                      Color(0xFF1E0A17),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Confetti Cannon Overlay
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
                ],
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // App Bar with Rules & Score
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                        ),

                        // Score & Timer Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Score: $_score',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Icon(Icons.timer_rounded, color: Color(0xFFFFB6C1), size: 20),
                              const SizedBox(width: 6),
                              Text(
                                '${_timeLeft}s',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFFFD1DC),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            const MusicControlButton(size: 36),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: () async {
                                if (_isPlaying) {
                                  final restart = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: const Color(0xFF2A1B28),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: Text('Restart Game?', style: GoogleFonts.poppins(color: Colors.white)),
                                        content: Text('A game is currently in progress. Do you want to restart and lose current progress?', style: GoogleFonts.poppins(color: Colors.white70)),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE05688)),
                                            child: Text('Restart', style: GoogleFonts.poppins(color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (restart == true) {
                                    _startGame();
                                  }
                                } else {
                                  _startGame();
                                }
                              },
                              icon: const Icon(Icons.replay_rounded, color: Color(0xFFFFB6C1)),
                              tooltip: 'Play Again',
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _showRulesDialog,
                              icon: const Icon(Icons.help_outline_rounded, color: Color(0xFFFFB6C1)),
                              tooltip: 'Rules',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Floating Balloons Game Field Area
                  Expanded(
                    child: Stack(
                      children: [
                        // Hint Overlay when starting
                        if (_score == 0 && _isPlaying)
                          Center(
                            child: Text(
                              'Tap the floating balloons! 🎈✨',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 16,
                              ),
                            ).animate().fadeIn(duration: 500.ms),
                          ),

                        // Floating Balloons Stack
                        for (var balloon in _balloons)
                          if (!balloon.isPopped)
                            Positioned(
                              left: balloon.x * (size.width - 70),
                              top: balloon.y * size.height,
                              child: GestureDetector(
                                onTap: () => _popBalloon(balloon),
                                child: Container(
                                  width: 64,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: balloon.color.withValues(alpha: 0.85),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(32),
                                      bottom: Radius.circular(24),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: balloon.color.withValues(alpha: 0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      balloon.emoji,
                                      style: const TextStyle(fontSize: 28),
                                    ),
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
          ],
        ),
      ),
    );
  }
}
