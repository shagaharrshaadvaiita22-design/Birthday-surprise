import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomCakeWidget extends StatelessWidget {
  final String shape; // 'heart', 'round', 'square', 'tiered', 'flower'
  final Color baseColor;
  final Color frostingColor;
  final Color accentColor;
  final List<String> toppings; // 'strawberries', 'cherries', 'sprinkles', 'macarons', 'chocolates', 'flowers'
  final bool showCandles;
  final bool candlesLit;
  final String girlName;
  final double scale;

  const CustomCakeWidget({
    super.key,
    this.shape = 'heart',
    this.baseColor = const Color(0xFFFFB6C1),
    this.frostingColor = const Color(0xFFFFF0F5),
    this.accentColor = const Color(0xFFE05688),
    this.toppings = const ['strawberries', 'sprinkles'],
    this.showCandles = true,
    this.candlesLit = true,
    this.girlName = 'Likitha',
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Candles (Number 21 + Flame effect)
          if (showCandles) _buildNumber21Candles(context),

          const SizedBox(height: 6),

          // Cake Body Container according to shape & toppings
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Plate / Stand
              Positioned(
                bottom: -8,
                child: Container(
                  width: 250,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Cake Body Shape
              _buildCakeBody(),

              // Poppins / Toppings Overlay
              Positioned.fill(
                child: _buildToppingsOverlay(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumber21Candles(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNumberCandle('2'),
        const SizedBox(width: 8),
        _buildNumberCandle('1'),
      ],
    );
  }

  Widget _buildNumberCandle(String digit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flame / Smoke particle
        SizedBox(
          height: 28,
          child: candlesLit
              ? Container(
                  width: 14,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const RadialGradient(
                      colors: [
                        Colors.white,
                        Colors.yellow,
                        Colors.orangeAccent,
                        Colors.redAccent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.9),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(begin: 0.9, end: 1.1, duration: 400.ms)
              : Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ).animate().fadeOut(duration: 800.ms).slideY(begin: 0, end: -0.8),
        ),
        const SizedBox(height: 2),

        // Candle Stick with Number
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor,
                baseColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            digit,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCakeBody() {
    switch (shape) {
      case 'heart':
        return _buildHeartCake();
      case 'square':
        return _buildSquareCake();
      case 'tiered':
        return _buildTieredCake();
      case 'flower':
        return _buildFlowerCake();
      case 'round':
      default:
        return _buildRoundCake();
    }
  }

  Widget _buildRoundCake() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Frosting Layer
        Container(
          width: 180,
          height: 48,
          decoration: BoxDecoration(
            color: frostingColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
              ),
            ),
          ),
        ),
        // Bottom Base Layer
        Container(
          width: 210,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [baseColor, accentColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              girlName,
              style: GoogleFonts.sacramento(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(1, 1)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeartCake() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(200, 110),
          painter: _HeartCakePainter(
            baseColor: baseColor,
            frostingColor: frostingColor,
            accentColor: accentColor,
          ),
        ),
        Positioned(
          bottom: 24,
          child: Text(
            girlName,
            style: GoogleFonts.sacramento(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSquareCake() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 170,
          height: 44,
          decoration: BoxDecoration(
            color: frostingColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        Container(
          width: 190,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [baseColor, accentColor]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              girlName,
              style: GoogleFonts.sacramento(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTieredCake() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Small Tier
        Container(
          width: 120,
          height: 35,
          decoration: BoxDecoration(
            color: frostingColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 1.8),
          ),
        ),
        // Middle Tier
        Container(
          width: 160,
          height: 38,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 1.8),
          ),
        ),
        // Bottom Main Tier
        Container(
          width: 200,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [baseColor, accentColor]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              girlName,
              style: GoogleFonts.sacramento(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlowerCake() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 105,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [baseColor, accentColor]),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              girlName,
              style: GoogleFonts.sacramento(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToppingsOverlay() {
    final List<Widget> items = [];

    if (toppings.contains('strawberries')) {
      items.addAll([
        const Positioned(top: 2, left: 35, child: Text('🍓', style: TextStyle(fontSize: 22))),
        const Positioned(top: 2, right: 35, child: Text('🍓', style: TextStyle(fontSize: 22))),
      ]);
    }
    if (toppings.contains('cherries')) {
      items.addAll([
        const Positioned(top: 4, left: 70, child: Text('🍒', style: TextStyle(fontSize: 20))),
        const Positioned(top: 4, right: 70, child: Text('🍒', style: TextStyle(fontSize: 20))),
      ]);
    }
    if (toppings.contains('sprinkles')) {
      items.addAll([
        const Positioned(top: 20, left: 25, child: Text('✨', style: TextStyle(fontSize: 16))),
        const Positioned(top: 22, right: 25, child: Text('✨', style: TextStyle(fontSize: 16))),
        const Positioned(top: 35, left: 80, child: Text('⭐', style: TextStyle(fontSize: 14))),
      ]);
    }
    if (toppings.contains('macarons')) {
      items.addAll([
        const Positioned(top: 10, left: 15, child: Text('🧁', style: TextStyle(fontSize: 20))),
        const Positioned(top: 10, right: 15, child: Text('🧁', style: TextStyle(fontSize: 20))),
      ]);
    }
    if (toppings.contains('chocolates')) {
      items.addAll([
        const Positioned(bottom: 25, left: 20, child: Text('🍫', style: TextStyle(fontSize: 18))),
        const Positioned(bottom: 25, right: 20, child: Text('🍫', style: TextStyle(fontSize: 18))),
      ]);
    }
    if (toppings.contains('flowers')) {
      items.addAll([
        const Positioned(top: 0, left: 85, child: Text('🌸', style: TextStyle(fontSize: 22))),
        const Positioned(bottom: 12, left: 45, child: Text('🦋', style: TextStyle(fontSize: 18))),
        const Positioned(bottom: 12, right: 45, child: Text('🦋', style: TextStyle(fontSize: 18))),
      ]);
    }

    return Stack(clipBehavior: Clip.none, children: items);
  }
}

class _HeartCakePainter extends CustomPainter {
  final Color baseColor;
  final Color frostingColor;
  final Color accentColor;

  _HeartCakePainter({
    required this.baseColor,
    required this.frostingColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Heart Base Path
    final path = Path();
    path.moveTo(width / 2, height * 0.85);
    path.cubicTo(
      width * 0.1, height * 0.55,
      0, height * 0.2,
      width * 0.25, height * 0.05,
    );
    path.cubicTo(
      width * 0.4, -0.05,
      width / 2, height * 0.15,
      width / 2, height * 0.25,
    );
    path.cubicTo(
      width / 2, height * 0.15,
      width * 0.6, -0.05,
      width * 0.75, height * 0.05,
    );
    path.cubicTo(
      width, height * 0.2,
      width * 0.9, height * 0.55,
      width / 2, height * 0.85,
    );
    path.close();

    final paintBase = Paint()
      ..shader = LinearGradient(
          colors: [baseColor, accentColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, width, height));

    final paintStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(path, paintBase);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant _HeartCakePainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.frostingColor != frostingColor ||
        oldDelegate.accentColor != accentColor;
  }
}
