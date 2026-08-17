import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../services/audio_manager.dart';
import '../widgets/music_control_button.dart';
import 'login_screen.dart';

class WishingScreen extends StatefulWidget {
  final BirthdayConfig config;

  const WishingScreen({super.key, required this.config});

  @override
  State<WishingScreen> createState() => _WishingScreenState();
}

class _WishingScreenState extends State<WishingScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _flameController;
  
  bool _candlesBlown = false;
  bool _giftOpened = false;
  int _activeTab = 0; // 0: Wish & Cake, 1: Memories, 2: Special Reasons

  final List<bool> _cardsFlipped = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    AudioManager.instance.playHappyBirthday();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _confettiController.play();

    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _flameController.dispose();
    super.dispose();
  }

  void _blowOutCandles() {
    if (_candlesBlown) return;
    setState(() {
      _candlesBlown = true;
    });
    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFD87093),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amberAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '🎉 Make a wish! All your dreams will come true, ${widget.config.girlName}! ✨',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSettingsDialog() {
    final nameEditController = TextEditingController(text: widget.config.girlName);
    final passEditController = TextEditingController(text: widget.config.password);
    final msgEditController = TextEditingController(text: widget.config.customMessage);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A1B28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.settings_suggest_rounded, color: Color(0xFFFFB6C1)),
              const SizedBox(width: 8),
              Text(
                'Customize Wishes',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField('Birthday Girl Name', nameEditController),
                const SizedBox(height: 12),
                _buildDialogField('Password', passEditController),
                const SizedBox(height: 12),
                _buildDialogField('Custom Wish Message', msgEditController, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05688),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                setState(() {
                  widget.config.girlName = nameEditController.text.trim();
                  widget.config.password = passEditController.text.trim();
                  widget.config.customMessage = msgEditController.text.trim();
                });
                await widget.config.save();
                if (mounted) Navigator.pop(context);
              },
              child: Text('Save', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: const Color(0xFFFFD1DC), fontSize: 12),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Ambient Background Backdrop
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C101B),
                      Color(0xFF4A182D),
                      Color(0xFF6B1D3D),
                      Color(0xFF2D1226),
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
                  Color(0xFFDA70D6),
                ],
                createParticlePath: (size) {
                  final path = Path();
                  path.addOval(Rect.fromCircle(center: Offset.zero, radius: 4));
                  return path;
                },
              ),
            ),

            // App Content
            SafeArea(
              child: Column(
                children: [
                  // Custom App Bar Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(config: widget.config),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
                          tooltip: 'Lock Portal',
                        ),

                        // Title pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.card_membership_rounded, color: Color(0xFFFFB6C1), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.config.girlName}\'s Surprise',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            const MusicControlButton(size: 38),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _openSettingsDialog,
                              icon: const Icon(Icons.tune_rounded, color: Color(0xFFFFB6C1)),
                              tooltip: 'Customize Settings',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Segmented Tab Selector
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton('🎂 Cake & Wish', 0),
                        _buildTabButton('💌 Letter', 1),
                        _buildTabButton('💖 4 Reasons', 2),
                      ],
                    ),
                  ),

                  // Main Tab View Body
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _buildActiveTabContent(size),
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

  Widget _buildTabButton(String title, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE05688) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF69B4).withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 12.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(Size size) {
    switch (_activeTab) {
      case 0:
        return _buildCakeAndWishTab(size);
      case 1:
        return _buildLetterTab(size);
      case 2:
        return _buildSpecialReasonsTab(size);
      default:
        return _buildCakeAndWishTab(size);
    }
  }

  // TAB 0: Interactive Birthday Cake & Wish
  Widget _buildCakeAndWishTab(Size size) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Greeting Banner
          Text(
            'Happy Birthday,',
            style: GoogleFonts.greatVibes(
              fontSize: 42,
              color: const Color(0xFFFFD1DC),
            ),
          ),
          Text(
            widget.config.girlName.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: const Color(0xFFFF69B4).withOpacity(0.8),
                  blurRadius: 20,
                ),
              ],
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 24),

          // Interactive Animated Cake
          GestureDetector(
            onTap: _blowOutCandles,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  // Candles Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            // Flame
                            if (!_candlesBlown)
                              AnimatedBuilder(
                                animation: _flameController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 0.85 + _flameController.value * 0.3,
                                    child: Container(
                                      width: 14,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const RadialGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.yellowAccent,
                                            Colors.orangeAccent,
                                            Colors.redAccent,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withOpacity(0.9),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              // Smoke puff when extinguished
                              Container(
                                width: 8,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ).animate().fadeOut(duration: 1000.ms).slideY(begin: 0, end: -1),
                            const SizedBox(height: 4),
                            // Candle Stick
                            Container(
                              width: 8,
                              height: 35,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  // Layer 1 (Top Frosting)
                  Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC0CB),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '🦋 ✨ 🦋',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  // Layer 2 (Bottom Cake Base)
                  Container(
                    width: 220,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF8BBD0), Color(0xFFE91E63)],
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        widget.config.nickname,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Cake Stand Plate
                  Container(
                    width: 250,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Action Button to Blow Candles
          ElevatedButton.icon(
            onPressed: _blowOutCandles,
            icon: Icon(
              _candlesBlown ? Icons.celebration_rounded : Icons.air_rounded,
              color: Colors.white,
            ),
            label: Text(
              _candlesBlown ? 'Candles Extinguished! 🎉' : 'Tap to Blow Candles 🌬️',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _candlesBlown ? const Color(0xFF4CAF50) : const Color(0xFFE05688),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),

          const SizedBox(height: 24),

          // Interactive Gift Box Unwrap
          _buildGiftBoxCard(),
        ],
      ),
    );
  }

  Widget _buildGiftBoxCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard_rounded, color: Color(0xFFFFD1DC), size: 24),
              const SizedBox(width: 10),
              Text(
                'Surprise Gift Box',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _giftOpened = !_giftOpened;
              });
              _confettiController.play();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _giftOpened
                    ? const Color(0xFFE05688).withOpacity(0.3)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _giftOpened ? const Color(0xFFFFB6C1) : Colors.white24,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _giftOpened ? Icons.card_giftcard_rounded : Icons.redeem_rounded,
                    size: 48,
                    color: const Color(0xFFFFB6C1),
                  ).animate(target: _giftOpened ? 1 : 0).shake(duration: 500.ms),
                  const SizedBox(height: 8),
                  Text(
                    _giftOpened
                        ? '🎁 "My greatest gift is having you in my life! May your year be filled with endless magic, happiness, and success!" ✨'
                        : 'Tap to Unwrap Gift Box 🎁',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: _giftOpened ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: Heartfelt Birthday Scroll / Letter
  Widget _buildLetterTab(Size size) {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F3).withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dearest ${widget.config.girlName},',
                      style: GoogleFonts.sacramento(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B0000),
                      ),
                    ),
                    const Icon(Icons.favorite_rounded, color: Color(0xFFE05688), size: 28),
                  ],
                ),
                const Divider(color: Color(0xFFFFB6C1), thickness: 1.2),
                const SizedBox(height: 12),
                Text(
                  widget.config.customMessage,
                  style: GoogleFonts.dancingScript(
                    fontSize: 22,
                    color: const Color(0xFF4A182D),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'With endless love & wishes,',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF8B0000),
                        ),
                      ),
                      Text(
                        '❤️ Yours Always',
                        style: GoogleFonts.sacramento(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE05688),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  // TAB 2: 4 Special Reasons Cards
  Widget _buildSpecialReasonsTab(Size size) {
    final reasons = [
      {
        'title': '🌟 Your Radiant Smile',
        'desc': 'Your laughter brightens up even the darkest days and brings pure warmth to everyone around you.',
        'icon': Icons.wb_sunny_rounded,
      },
      {
        'title': '💖 Your Caring Heart',
        'desc': 'The kindness and love you radiate make the world a infinitely better and sweeter place.',
        'icon': Icons.favorite_rounded,
      },
      {
        'title': '✨ Your Magical Vibe',
        'desc': 'You have this effortless grace and charm that makes every single moment unforgettable.',
        'icon': Icons.auto_awesome_rounded,
      },
      {
        'title': '👑 Truly One of a Kind',
        'desc': 'Never forget how rare, talented, beautiful, and absolutely extraordinary you are!',
        'icon': Icons.workspace_premium_rounded,
      },
    ];

    return ListView.builder(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(24),
      itemCount: reasons.length,
      itemBuilder: (context, index) {
        final item = reasons[index];
        final isFlipped = _cardsFlipped[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              _cardsFlipped[index] = !_cardsFlipped[index];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isFlipped
                  ? const Color(0xFFE05688).withOpacity(0.35)
                  : Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFlipped ? const Color(0xFFFFB6C1) : Colors.white24,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: const Color(0xFFFFD1DC),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFlipped
                            ? (item['desc'] as String)
                            : 'Tap to reveal why you are special ✨',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(isFlipped ? 0.95 : 0.65),
                          fontSize: 12.5,
                          fontStyle: isFlipped ? FontStyle.normal : FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: Duration(milliseconds: 100 * index)),
        );
      },
    );
  }
}
