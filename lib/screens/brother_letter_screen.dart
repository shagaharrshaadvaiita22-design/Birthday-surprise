import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';

class BrotherLetterScreen extends StatefulWidget {
  final BirthdayConfig config;

  const BrotherLetterScreen({super.key, required this.config});

  @override
  State<BrotherLetterScreen> createState() => _BrotherLetterScreenState();
}

class _BrotherLetterScreenState extends State<BrotherLetterScreen> {
  bool _isUnlocked = false;
  String _enteredPin = '';
  bool _shakeError = false;

  void _onDigit(String d) {
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin += d);
      if (_enteredPin.length == 4) {
        if (_enteredPin == '0707') {
          setState(() => _isUnlocked = true);
        } else {
          setState(() {
            _shakeError = true;
            _enteredPin = '';
          });
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) setState(() => _shakeError = false);
          });
        }
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  void _openFullscreenImageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/birthday_letter.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.broken_image_rounded,
                                  color: Colors.white54, size: 60),
                              const SizedBox(height: 12),
                              Text(
                                'Could not load birthday_letter.png',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Close Button
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Hint Banner
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pinch to zoom / Drag to pan letter 🔍',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onClear() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin = '');
    }
  }

  Widget _buildNumKey(String label, VoidCallback onTap, {Color? fg}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: fg ?? Colors.white,
                  fontSize: (label == '⌫' || label == 'C') ? 18 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinLockScreen() {
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
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Lock Icon animated
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF85A1), Color(0xFFE05688)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.lock_rounded, color: Colors.white, size: 38),
                              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                              const SizedBox(height: 20),

                              Text(
                                'Enter PIN 🔐',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'This letter is locked with a special PIN\njust for you 💌',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // PIN dots
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 80),
                                transform: _shakeError
                                    ? Matrix4.translationValues(10, 0, 0)
                                    : Matrix4.identity(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (i) {
                                    final filled = i < _enteredPin.length;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _shakeError
                                            ? Colors.redAccent
                                            : (filled
                                                ? const Color(0xFFFF85A1)
                                                : Colors.white24),
                                        border: Border.all(
                                          color: filled
                                              ? const Color(0xFFFF85A1)
                                              : Colors.white38,
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              if (_shakeError) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Wrong PIN ✗  Try again',
                                  style: GoogleFonts.poppins(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 28),

                              // Number pad with Material wrapper and standard 3-column layout
                              Row(
                                children: [
                                  _buildNumKey('1', () => _onDigit('1')),
                                  _buildNumKey('2', () => _onDigit('2')),
                                  _buildNumKey('3', () => _onDigit('3')),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildNumKey('4', () => _onDigit('4')),
                                  _buildNumKey('5', () => _onDigit('5')),
                                  _buildNumKey('6', () => _onDigit('6')),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildNumKey('7', () => _onDigit('7')),
                                  _buildNumKey('8', () => _onDigit('8')),
                                  _buildNumKey('9', () => _onDigit('9')),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildNumKey('C', _onClear, fg: Colors.orangeAccent),
                                  _buildNumKey('0', () => _onDigit('0')),
                                  _buildNumKey('⌫', _onDelete, fg: const Color(0xFFFFB6C1)),
                                ],
                              ),
                            ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) return _buildPinLockScreen();

    // ── Unlocked: letter content ──
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Dark Ambient Background
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
                  // Header Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                          tooltip: 'Back',
                        ),

                        Row(
                          children: [
                            const Icon(Icons.mark_email_read_rounded, color: Color(0xFFFFB6C1), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Letter from Brother 📜',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const MusicControlButton(size: 36),
                      ],
                    ),
                  ),

                  // Image Letter Card
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _openFullscreenImageModal(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFFFB6C1).withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF69B4).withValues(alpha: 0.35),
                                    blurRadius: 25,
                                    spreadRadius: 3,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Image.asset(
                                      'assets/images/birthday_letter.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 300,
                                          color: const Color(0xFF4A182D),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.broken_image_rounded,
                                                    color: Color(0xFFFFB6C1), size: 50),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'birthday_letter.png not found',
                                                  style: GoogleFonts.poppins(color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Overlay Zoom Tag
                                  Positioned(
                                    bottom: 14,
                                    right: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFFFB6C1)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.zoom_in_rounded, color: Color(0xFFFFB6C1), size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Tap to Expand 🔍',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),

                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            onPressed: () => _openFullscreenImageModal(context),
                            icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
                            label: Text(
                              'Read Full Resolution Letter 📜✨',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE05688),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              elevation: 4,
                            ),
                          ),
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
