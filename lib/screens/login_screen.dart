import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../services/audio_manager.dart';
import '../widgets/music_control_button.dart';
import 'splash_sequence_screen.dart';

class LoginScreen extends StatefulWidget {
  final BirthdayConfig config;

  const LoginScreen({super.key, required this.config});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;
  late AnimationController _hintAnimController;

  @override
  void initState() {
    super.initState();
    _hintAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _hintAnimController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlock() async {
    final enteredName = _nameController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (enteredName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the Birthday Girl\'s name ✨';
      });
      return;
    }

    if (enteredPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the secret password 🔑';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    // Check credentials matching Princess_Likitha and 22-09-2026 (or saved config)
    final isValidName = enteredName.toLowerCase().replaceAll('_', '') ==
            widget.config.girlName.toLowerCase().replaceAll('_', '') ||
        enteredName.toLowerCase().contains('likitha') ||
        enteredName.toLowerCase().contains('princess');
    final isValidPass = enteredPassword == widget.config.password ||
        enteredPassword == '22092005' ||
        enteredPassword == '22-09-2005' ||
        enteredPassword == '22-09-2026';

    if (isValidName && isValidPass) {
      widget.config.girlName = enteredName;
      widget.config.password = enteredPassword;
      await widget.config.save();

      AudioManager.instance.playHappyBirthday();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 900),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: SplashSequenceScreen(config: widget.config),
            );
          },
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        if (!isValidName) {
          _errorMessage = 'Incorrect Birthday Girl Name ✨';
        } else {
          _errorMessage = 'Incorrect Password 🔑';
        }
      });
    }
  }

  void _showHintMessage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8A2BE2), Color(0xFFFF69B4), Color(0xFFFF1493)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🏃‍♀️💨 😜',
                style: TextStyle(fontSize: 44),
              ),
              const SizedBox(height: 12),
              Text(
                'u should catch for the hint 😜',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'I\'m moving fast across the screen! Can\'t give any secrets here! Keep catching me! 🏃‍♂️💨✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF1493),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text(
                  'Keep Catching! 🏃‍♀️',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: CustomPaint(
          painter: DoodlePainter(),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2A0845).withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFFFB6C1), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF69B4).withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('✨', style: TextStyle(fontSize: 22)),
                      SizedBox(width: 6),
                      Text('🍗', style: TextStyle(fontSize: 30)),
                      SizedBox(width: 6),
                      Text('🍚', style: TextStyle(fontSize: 30)),
                      SizedBox(width: 6),
                      Text('🤦‍♀️', style: TextStyle(fontSize: 30)),
                      SizedBox(width: 6),
                      Text('✨', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Forgot Password? 🔑',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD1DC),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'u seriously dont know the password? 🤦‍♀️🤣',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'you gotta be serious!! 🤪\nif u really dont know the password you should dm me 📲💬',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFFFFD1DC),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Colors.white30, height: 1),
                        const SizedBox(height: 14),
                        Text(
                          'and forgot to tell ya... u owe me a 2000 bucks of chicken biryani for password! 🍗🍚😋💸',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFE4E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('🎨', style: TextStyle(fontSize: 20)),
                      Text('💖', style: TextStyle(fontSize: 20)),
                      Text('🍗', style: TextStyle(fontSize: 20)),
                      Text('😋', style: TextStyle(fontSize: 20)),
                      Text('💸', style: TextStyle(fontSize: 20)),
                      Text('✨', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check_circle_rounded, size: 20),
                    label: Text(
                      'I\'ll buy the Biryani! 🍗😋',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            // Background Image covering entire screen including status bar
            Positioned.fill(
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/birthday_bg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF9EAE1), Color(0xFFF0C8D0), Color(0xFFE89AA8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Soft dark/pink ambient overlay for high legibility
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.25),
                        const Color(0xFF5D1225).withOpacity(0.35),
                        Colors.black.withOpacity(0.45),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),

            // Music Control Button with SafeArea
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: const MusicControlButton(size: 40),
                ),
              ),
            ),

            // Main Content Container
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top spacing to allow background "Happy Birthday" image text to be fully visible
                      SizedBox(height: size.height * 0.22),





                      // Middle Login / Entrance Card with Birthday Girl Name & Password columns
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 420),
                            padding: const EdgeInsets.all(28.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(28.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD87093).withOpacity(0.25),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header Icon & Subtitle
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon Image
                                      SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Image.asset(
                                          'assets/images/icon.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.auto_awesome_rounded,
                                              color: Color(0xFFFFD1DC),
                                              size: 32,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Birthday Portal',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFFF94B9),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Enter credentials to unlock your surprise',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Column 1: Birthday Girl Name Input Field
                                _buildInputFieldLabel('Birthday Girl Name', Icons.person_rounded),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _nameController,
                                  hintText: 'Enter Birthday Girl\'s Name',
                                  prefixIcon: Icons.favorite_border_rounded,
                                ),

                                const SizedBox(height: 20),

                                // Column 2: Password Input Field
                                _buildInputFieldLabel('Password', Icons.lock_outline_rounded),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'Enter Secret Password',
                                  prefixIcon: Icons.key_rounded,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _showForgotPasswordDialog,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot Password? 🔑',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFFFD1DC),
                                        decoration: TextDecoration.underline,
                                        decorationColor: const Color(0xFFFFD1DC).withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),



                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.redAccent.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ).animate().shake(duration: 400.ms),
                                ],

                                const SizedBox(height: 24),

                                // Unlock Button
                                Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF85A1),
                                        Color(0xFFE05688),
                                        Color(0xFFC73E6A),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF69B4).withOpacity(0.5),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleUnlock,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Unlock Surprise',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.card_giftcard_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                  ),
                                ).animate(
                                  onPlay: (controller) => controller.repeat(reverse: true),
                                ).scaleXY(
                                  begin: 1.0,
                                  end: 1.02,
                                  duration: 1200.ms,
                                  curve: Curves.easeInOut,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),
              ),
            ),

            // Animated Moving Hint Button moving continuously across top layer of the screen
            AnimatedBuilder(
              animation: _hintAnimController,
              builder: (context, child) {
                final t = _hintAnimController.value;
                final paddingX = 16.0;
                final paddingY = 80.0;
                final availableW = (size.width - 130).clamp(20.0, 2000.0);
                final availableH = (size.height - 180).clamp(20.0, 2000.0);

                final x = paddingX + (availableW / 2) + (availableW / 2) * math.sin(t * 2 * math.pi);
                final y = paddingY + (availableH / 2) + (availableH / 2) * math.cos(t * 3 * math.pi);

                return Positioned(
                  left: x,
                  top: y,
                  child: child!,
                );
              },
              child: GestureDetector(
                onTap: _showHintMessage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF758C),
                        Color(0xFFFF7EB3),
                        Color(0xFFFF5252),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5252).withOpacity(0.5),
                        blurRadius: 14,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lightbulb_rounded,
                        color: Colors.amberAccent,
                        size: 20,
                      ).animate(onPlay: (controller) => controller.repeat()).shake(duration: 1000.ms),
                      const SizedBox(width: 8),
                      Text(
                        'Hint 💡',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldLabel(String labelText, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD1DC), size: 16),
        const SizedBox(width: 6),
        Text(
          labelText,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black38,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: true,
        readOnly: false,
        enableInteractiveSelection: true,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: const Color(0xFFFFB6C1),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.55),
            fontSize: 13.5,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFFFFD1DC).withOpacity(0.9),
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class DoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF69B4).withOpacity(0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    _drawSparkleDoodle(canvas, paint, const Offset(-8, 20));
    _drawSparkleDoodle(canvas, paint, Offset(size.width + 8, 40));
    _drawSparkleDoodle(canvas, paint, Offset(size.width / 2, size.height + 12));
    _drawCircleDoodle(canvas, paint, Offset(16, size.height + 8));
    _drawCircleDoodle(canvas, paint, Offset(size.width - 12, -8));

    _drawHeartDoodle(canvas, paint, Offset(-12, size.height / 2));
    _drawHeartDoodle(canvas, paint, Offset(size.width + 12, size.height / 2 + 20));
  }

  void _drawSparkleDoodle(Canvas canvas, Paint paint, Offset center) {
    const size = 10.0;
    canvas.drawLine(Offset(center.dx - size, center.dy), Offset(center.dx + size, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), paint);
    canvas.drawLine(Offset(center.dx - size / 1.5, center.dy - size / 1.5), Offset(center.dx + size / 1.5, center.dy + size / 1.5), paint);
    canvas.drawLine(Offset(center.dx - size / 1.5, center.dy + size / 1.5), Offset(center.dx + size / 1.5, center.dy - size / 1.5), paint);
  }

  void _drawCircleDoodle(Canvas canvas, Paint paint, Offset center) {
    canvas.drawCircle(center, 7, paint);
  }

  void _drawHeartDoodle(Canvas canvas, Paint paint, Offset center) {
    final path = Path();
    path.moveTo(center.dx, center.dy + 4);
    path.cubicTo(center.dx - 6, center.dy - 5, center.dx - 10, center.dy + 3, center.dx, center.dy + 10);
    path.cubicTo(center.dx + 10, center.dy + 3, center.dx + 6, center.dy - 5, center.dx, center.dy + 4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

