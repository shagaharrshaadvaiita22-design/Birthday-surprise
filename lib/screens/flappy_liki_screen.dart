import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/birthday_config.dart';
import '../widgets/music_control_button.dart';
import '../widgets/sparkle_overlay.dart';

class FlappyLikiScreen extends StatefulWidget {
  final BirthdayConfig config;

  const FlappyLikiScreen({super.key, required this.config});

  @override
  State<FlappyLikiScreen> createState() => _FlappyLikiScreenState();
}

class _FlappyLikiScreenState extends State<FlappyLikiScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Timer? _gameTimer;
  final math.Random _random = math.Random();
  final List<_BirthdayPipe> _pipes = [];

  double _likiY = 0.5;
  double _velocity = 0;
  int _score = 0;
  int _nextPipeId = 0;
  bool _playing = false;
  bool _gameOver = false;
  String _funnyMessage = 'Tap to flap, birthday bird!';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showStartDialog());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _showStartDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF42182D),
        title: Text(
          'Flappy Liki 🐥',
          style: GoogleFonts.greatVibes(
            fontSize: 32,
            color: const Color(0xFFFFD1DC),
          ),
        ),
        content: Text(
          'Tap anywhere to flap through the birthday pipes. Avoid the cake, the candles, and Liki\'s dramatic bonks!',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text(
              'Let her flap!',
              style: TextStyle(color: Color(0xFFFFD54F)),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    setState(() {
      _likiY = 0.5;
      _velocity = 0;
      _score = 0;
      _nextPipeId = 0;
      _pipes
        ..clear()
        ..add(_makePipe(1.0));
      _playing = true;
      _gameOver = false;
      _funnyMessage = 'Liki has entered the runway!';
    });

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => _tick(),
    );
  }

  _BirthdayPipe _makePipe(double x) {
    return _BirthdayPipe(
      id: _nextPipeId++,
      x: x,
      gapCenter: 0.30 + _random.nextDouble() * 0.40,
    );
  }

  void _flap() {
    if (!_playing) {
      if (_gameOver) _startGame();
      return;
    }
    setState(() {
      _velocity = -0.021;
      _funnyMessage = _random.nextBool()
          ? 'Very graceful!'
          : 'Maximum birthday flapping!';
    });
  }

  void _tick() {
    if (!mounted || !_playing) return;
    setState(() {
      _velocity += 0.00095;
      _likiY += _velocity;
      for (final pipe in _pipes) {
        pipe.x -= 0.0045;
        if (!pipe.passed && pipe.x < 0.19) {
          pipe.passed = true;
          _score++;
          _funnyMessage = _score.isEven
              ? 'Pipe dodged! Hair still fabulous!'
              : 'That was close-ish!';
        }
      }
      _pipes.removeWhere((pipe) => pipe.x < -0.25);
      if (_pipes.isEmpty || _pipes.last.x < 0.55) {
        _pipes.add(_makePipe(1.08));
      }
    });

    final hitPipe = _pipes.any(
      (pipe) =>
          pipe.x < 0.24 &&
          pipe.x > 0.08 &&
          (_likiY < pipe.gapCenter - pipe.gapSize / 2 ||
              _likiY > pipe.gapCenter + pipe.gapSize / 2),
    );
    if (_likiY < 0.02 || _likiY > 0.98 || hitPipe) {
      _endGame(hitPipe);
    }
  }

  void _endGame(bool hitPipe) {
    _gameTimer?.cancel();
    setState(() {
      _playing = false;
      _gameOver = true;
      _funnyMessage = hitPipe
          ? 'BONK! The birthday pipe wins this round.'
          : 'Liki flew into the dramatic void.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5BC0EB), Color(0xFFBDECF7), Color(0xFFFFD1DC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF42182D),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Flappy Liki',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.greatVibes(
                            fontSize: 36,
                            color: const Color(0xFF42182D),
                          ),
                        ),
                      ),
                      const MusicControlButton(size: 38),
                    ],
                  ),
                ),
                Text(
                  'Score: $_score',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF42182D),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => GestureDetector(
                      onTap: _flap,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _FlappySkyPainter(
                                animation: _animationController.value,
                              ),
                            ),
                          ),
                          ..._pipes.map(
                            (pipe) => _buildPipe(
                              pipe,
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 30),
                            left: constraints.maxWidth * 0.16,
                            top: constraints.maxHeight * _likiY,
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) => Transform.rotate(
                                angle: math.max(
                                  -0.35,
                                  math.min(0.55, _velocity * 18),
                                ),
                                child: Transform.scale(
                                  scale:
                                      0.92 +
                                      (_animationController.value * 0.12),
                                  child: child,
                                ),
                              ),
                              child: const Text(
                                '🐥',
                                style: TextStyle(fontSize: 52),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 18,
                            left: 0,
                            right: 0,
                            child: Text(
                              _funnyMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF42182D),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (_gameOver)
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.86),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Liki bonked! 💫',
                                        style: GoogleFonts.greatVibes(
                                          fontSize: 32,
                                          color: const Color(0xFF42182D),
                                        ),
                                      ),
                                      Text(
                                        'Final score: $_score',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF42182D),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: _startGame,
                                        icon: const Icon(Icons.replay_rounded),
                                        label: const Text('Try again'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Text(
                    _playing
                        ? 'Tap anywhere to flap'
                        : 'Tap Try again to unleash the wings',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF42182D).withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildPipe(_BirthdayPipe pipe, double width, double height) {
    final gapTop = height * (pipe.gapCenter - pipe.gapSize / 2);
    final gapBottom = height * (pipe.gapCenter + pipe.gapSize / 2);
    return Positioned(
      left: width * pipe.x,
      top: 0,
      bottom: 0,
      width: width * 0.13,
      child: Column(
        children: [
          _pipePart(height: gapTop, text: '🎂'),
          SizedBox(height: gapBottom - gapTop),
          _pipePart(height: height - gapBottom, text: '🎁'),
        ],
      ),
    );
  }

  Widget _pipePart({required double height, required String text}) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE05688),
        border: Border.all(color: const Color(0xFF8B264E), width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _BirthdayPipe {
  final int id;
  double x;
  final double gapCenter;
  final double gapSize = 0.40;
  bool passed = false;

  _BirthdayPipe({required this.id, required this.x, required this.gapCenter});
}

class _FlappySkyPainter extends CustomPainter {
  final double animation;

  const _FlappySkyPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    for (var index = 0; index < 5; index++) {
      final x =
          ((index * size.width / 4) + animation * 24) % (size.width + 80) - 40;
      final y = 48.0 + (index % 3) * 90.0;
      canvas.drawCircle(Offset(x, y), 22, cloudPaint);
      canvas.drawCircle(Offset(x + 24, y + 6), 16, cloudPaint);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 12, y + 16), width: 70, height: 28),
        cloudPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FlappySkyPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
