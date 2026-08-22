import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_config.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';
import '../services/slideshow_download_service.dart';

const int kCoreMemoryCount = 75;

class CoreMemoriesScreen extends StatefulWidget {
  final BirthdayConfig config;

  const CoreMemoriesScreen({super.key, required this.config});

  @override
  State<CoreMemoriesScreen> createState() => _CoreMemoriesScreenState();
}

class _CoreMemoriesScreenState extends State<CoreMemoriesScreen> {
  bool _isCompactGrid = false;
  late final List<int> _memoryOrder;
  late final List<String> _orderedCaptions;

  @override
  void initState() {
    super.initState();
    _memoryOrder = _buildMemoryOrder();
    _orderedCaptions = _memoryOrder.map((photoNumber) {
      final safeIndex = photoNumber - 1;
      if (safeIndex >= 0 && safeIndex < _captions.length) {
        return _captions[safeIndex];
      }
      return 'A treasured memory from our story ✨';
    }).toList();
  }

  List<int> _buildMemoryOrder() {
    return List<int>.generate(kCoreMemoryCount, (index) => index + 1);
  }

  // Custom short tags for Polaroid bottoms (70 unique tags for all 70 photos)
  final List<String> _shortTags = [
    "Memory 📸", "Candid 😊", "Vibes ✨", "Golden Hour 🌟", "Good Times 🎉", "Dreamy 🌸",
    "Joy 💕", "Snapshot 💫", "Laughing 😂", "Moment 💖", "Glow ☀️", "Grateful 🙏",
    "Fun Times ✨", "Radiant 🌸", "Iconic 💅", "Precious 💎", "Classic 🎞️", "Lit 🔥",
    "Chill 🌿", "Epic 🚀", "Pure Joy 😄", "Smashing 💫", "Natural 🌻", "Bright ☀️",
    "Vivid 🎨", "Serene 🍃", "Hyped 🎶", "Real 💯", "Bold 🌹", "Glam 💃",
    "Sweet Day 🍬", "Sunny Smile ☀️", "Unfiltered ✨", "Golden Glow 💛", "Festive Vibes 🎈", "Sparkle 🌟",
    "Peaceful 🕊️", "Good Energy ⚡", "Heartfelt 💖", "Shine Bright ⭐", "Lovely Frame 🖼️", "Catching Rays 🌤️",
    "Pure Magic 💫", "Best Day 🥳", "Stay Gold 👑", "Charming 🌸", "Unforgettable 📖", "Happiness 😄",
    "So Bright 🌟", "Celebration 🎉", "Positive Vibes ✨", "Golden Memory 💛", "Sweet Times 🍭", "Smiles All Around 😊",
    "Daydreaming ☁️", "Lively 🎶", "Cute Pose 📸", "Special Day 🎁", "Warmth ☀️", "Timeless ⏳",
    "Joyous 🎈", "Shining 🌟", "Wild & Free 🌿", "Happy Spirit ✨", "Sunshine Girl ☀️", "Pure Bliss 🌸",
    "Golden Laugh 😂", "Making Memories 📸", "Cheerful Days 🥳", "Timeless Joy 💫", "Vibrant Life 🌺", "Grateful Heart 💖", "Beautiful Days 🌸", "Smiles & Sun ☀️", "Best Moment 💖","Chilling 🧘","Pure joy 😊"
  ];

  // Unique captions for all 75 photos
  final List<String> _captions = [
    "A smile that lights up the entire room ✨",
    "Making everyday moments magical 🌸",
    "Radiating beauty and grace, inside and out 💖",
    "Grateful for this beautiful soul in our lives 🌟",
    "Liki in her absolute element! 😊",
    "Capturing the purest form of happiness 💫",
    "A little spark of magic wherever you go ✨",
    "Cherishing the laughter we share ❤️",
    "Looking absolutely gorgeous as always! 👑",
    "Every picture tells a sweet story of joy 📖",
    "Keep shining, beautiful girl! 🌟",
    "A memory that makes the heart warm up 🥰",
    "Blessed with the sweetest smile 🌸",
    "Golden moments with the golden girl 💛",
    "May your days be as bright as your smile ☀️",
    "Our favourite birthday girl in action! 🎈",
    "Creating sweet memories one day at a time 🍭",
    "Chasing dreams and catching smiles 💫",
    "The world is brighter with you in it 💖",
    "Nothing but pure, unfiltered joy! 😄",
    "Elegant, beautiful, and uniquely you ✨",
    "A picture-perfect moment to hold close 📸",
    "Confidence, beauty, and kindness in one frame 🌹",
    "Liki's golden laugh is the best sound 🎶",
    "So precious and wonderful! 💕",
    "Celebrating the beautiful person you are 🥂",
    "May this year bring you infinite happiness 🌈",
    "A true queen, wearing her invisible crown 👑",
    "Dressed in smiles and positive vibes 🌸",
    "Sweetest memories of our favourite girl 🍬",
    "A beautiful chapter of your 21st year 📖",
    "Here's to more laughs and endless fun 🎉",
    "Sparkling bright like the star you are 🌟",
    "Moments that make life truly beautiful ❤️",
    "So grateful for your magical presence ✨",
    "May your heart always be full of joy 💖",
    "Keep spreading your beautiful energy! 💫",
    "A snapshot of pure happiness 📸",
    "A heart of gold and a smile to match 💛",
    "Keep dreaming big, princess! 👑",
    "Simply stunning in every single way 🌹",
    "A magical memory to treasure forever ✨",
    "Laughter is the music of your soul 🎶",
    "Such a beautiful soul, inside and out 💖",
    "Captured a piece of heaven in your eyes 🌟",
    "Wishing you a world of sweetness and joy 🧁",
    "You deserve all the happiness in the universe 💫",
    "Every memory with you is a core memory ❤️",
    "Shine bright, today and for all your years 🌟",
    "Happy 21st Birthday, dear Likitha! 🎂🎉",
    "May you reach all your dreams and beyond 🚀",
    "Blessed to see you grow into such a gem 💎",
    "A perfect smile for a perfect day 😊",
    "Living, laughing, and loving life 🌸",
    "Your happiness is our greatest joy 💖",
    "A beautiful flower in the garden of life 🌹",
    "Stunning, sweet, and incredibly smart ✨",
    "May your path be lined with blessings 🌟",
    "Glow girl, the world is yours! 💛",
    "A masterpiece created of joy and light 🎨",
    "Keep being the amazing person you are 💫",
    "So full of life and wonder 🦄",
    "Your smile is a cure for any bad day 😊",
    "May this new decade be your best yet 🚀",
    "Sweet Liki, our brightest sunshine ☀️",
    "Every picture shows your beautiful spirit 🌸",
    "Making memories that will last a lifetime 💫",
    "A beautiful soul deserving of a beautiful life ❤️",
    "Cheering for you today and always! 📣🎉",
    "A journey of a thousand smiles 💫",
    "Radiating joy like the morning sun ☀️",
    "Embracing every moment with grace 🌸",
    "Creating magical stories every day ✨",
    "Our final and best moment 💖",
    "The final moment, the sweetest chapter of all 🌸",
    "A warm ending wrapped in love and laughter 🌸",
    "Forever treasuring the moments we shared together 🌸",
    "May every new day feel as beautiful as this memory 💫",
    "A fresh burst of sparkle for our favorite chapter ✨",
    "The story keeps getting brighter, love and laughter included 💖",
  ];

  // Helper method to get correct path and format extension for the 75 images/videos
  String _getImagePath(int index) {
    final photoNumber = index;
    if (photoNumber <= 10) {
      return 'assets/Photos/$photoNumber.jpeg';
    } else if (photoNumber == 28) {
      return 'assets/Photos/28.png';
    } else if (photoNumber == 50) {
      return 'assets/Photos/50.webp';
    } else if (photoNumber >= 72 && photoNumber <= 75) {
      return 'assets/Photos/$photoNumber.mp4';
    } else {
      return 'assets/Photos/$photoNumber.jpg';
    }
  }

  // Opens a swipeable, zoomable full-screen page viewer
  void _openFullscreenViewer(int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.95),
        pageBuilder: (context, _, a) => _InteractivePhotoViewer(
          initialIndex: initialIndex,
          captions: _orderedCaptions,
          memoryOrder: _memoryOrder,
          getImagePath: _getImagePath,
        ),
      ),
    );
  }

  // Opens the automated slideshow screen
  void _startSlideshow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SlideshowScreen(
          captions: _orderedCaptions,
          memoryOrder: _memoryOrder,
          getImagePath: _getImagePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Stack(
          children: [
            // Dark Soft Ambient Background
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
                  // Custom AppBar Header
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
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                'Core Memories 📸💖',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.greatVibes(
                                  fontSize: MediaQuery.of(context).size.width < 360 ? 24 : 30,
                                  color: const Color(0xFFFFD1DC),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Celebrating ${widget.config.girlName}',
                                style: GoogleFonts.poppins(
                                  fontSize: MediaQuery.of(context).size.width < 360 ? 9 : 11,
                                  color: Colors.white54,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const MusicControlButton(size: 38),
                      ],
                    ),
                  ),

                  // Option Toolbar (Slideshow & Layout Toggle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Play Slideshow Button
                        ElevatedButton.icon(
                          onPressed: _startSlideshow,
                          icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                          label: Text(
                            'Play Slideshow 📽️',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE05688).withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Color(0xFFFFB6C1), width: 1),
                            ),
                          ),
                        ).animate().scale(delay: 200.ms, duration: 400.ms),

                        // Layout Toggle Button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isCompactGrid = !_isCompactGrid;
                            });
                          },
                          icon: Icon(
                            _isCompactGrid ? Icons.auto_awesome_mosaic_rounded : Icons.grid_view_rounded,
                            color: const Color(0xFFFFB6C1),
                          ),
                          tooltip: _isCompactGrid ? 'Switch to Scrapbook Grid' : 'Switch to Compact Grid',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white10,
                            padding: const EdgeInsets.all(10),
                          ),
                        ).animate().scale(delay: 200.ms, duration: 400.ms),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Gallery view area
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                          child: child,
                        ),
                      ),
                      child: _isCompactGrid
                          ? _buildCompactGrid()
                          : _buildScrapbookGrid(),
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

  // A memory-efficient scrapbook collage layout using ListView.builder
  Widget _buildScrapbookGrid() {
    return ListView.builder(
      key: const PageStorageKey<String>('scrapbook_grid'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: (_memoryOrder.length + 1) ~/ 2,
      itemBuilder: (context, rowIndex) {
        final int leftIndex = rowIndex * 2;
        final int rightIndex = rowIndex * 2 + 1;
        final int leftPhotoNumber = _memoryOrder[leftIndex];
        final int? rightPhotoNumber = rightIndex < _memoryOrder.length ? _memoryOrder[rightIndex] : null;

        final double leftTopPadding = (rowIndex % 2 == 0) ? 8.0 : 36.0;
        final double rightTopPadding = (rowIndex % 2 == 0) ? 36.0 : 8.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(6, leftTopPadding, 6, 16),
                child: _buildAestheticFrame(
                  context,
                  leftIndex,
                  _getImagePath(leftPhotoNumber),
                  onTap: () => _openFullscreenViewer(leftIndex),
                ),
              ),
            ),
            Expanded(
              child: rightPhotoNumber != null ? Padding(
                padding: EdgeInsets.fromLTRB(6, rightTopPadding, 6, 16),
                child: _buildAestheticFrame(
                  context,
                  rightIndex,
                  _getImagePath(rightPhotoNumber),
                  onTap: () => _openFullscreenViewer(rightIndex),
                ),
              ) : const SizedBox(),
            ),
          ],
        );
      },
    );
  }

  // Clean, high-density 3-column staggered photo grid (preserves aspect ratios)
  Widget _buildCompactGrid() {
    return ListView.builder(
      key: const PageStorageKey<String>('compact_grid'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: (_memoryOrder.length + 2) ~/ 3,
      itemBuilder: (context, rowIndex) {
        final int firstIndex = rowIndex * 3;
        final int secondIndex = rowIndex * 3 + 1;
        final int thirdIndex = rowIndex * 3 + 2;
        final int? firstPhotoNumber = firstIndex < _memoryOrder.length ? _memoryOrder[firstIndex] : null;
        final int? secondPhotoNumber = secondIndex < _memoryOrder.length ? _memoryOrder[secondIndex] : null;
        final int? thirdPhotoNumber = thirdIndex < _memoryOrder.length ? _memoryOrder[thirdIndex] : null;

        final bool showSecond = secondPhotoNumber != null;
        final bool showThird = thirdPhotoNumber != null;

        final double p1 = (rowIndex % 3 == 0) ? 6.0 : (rowIndex % 3 == 1 ? 16.0 : 26.0);
        final double p2 = (rowIndex % 3 == 0) ? 26.0 : (rowIndex % 3 == 1 ? 6.0 : 16.0);
        final double p3 = (rowIndex % 3 == 0) ? 16.0 : (rowIndex % 3 == 1 ? 26.0 : 6.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: firstPhotoNumber != null ? Padding(
                padding: EdgeInsets.fromLTRB(4, p1, 4, 10),
                child: _buildAestheticFrame(
                  context,
                  firstIndex,
                  _getImagePath(firstPhotoNumber),
                  isCompact: true,
                  onTap: () => _openFullscreenViewer(firstIndex),
                ),
              ) : const SizedBox(),
            ),
            Expanded(
              child: showSecond
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(4, p2, 4, 10),
                      child: _buildAestheticFrame(
                        context,
                        secondIndex,
                        _getImagePath(secondPhotoNumber!),
                        isCompact: true,
                        onTap: () => _openFullscreenViewer(secondIndex),
                      ),
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: showThird
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(4, p3, 4, 10),
                      child: _buildAestheticFrame(
                        context,
                        thirdIndex,
                        _getImagePath(thirdPhotoNumber!),
                        isCompact: true,
                        onTap: () => _openFullscreenViewer(thirdIndex),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }

  // A unified, highly aesthetic frame style that dynamically fits the photo's original aspect ratio
  Widget _buildAestheticFrame(
    BuildContext context,
    int index,
    String imagePath, {
    bool isCompact = false,
    VoidCallback? onTap,
  }) {
    final bool isFinalMoment = _memoryOrder[index] == 75;
    final String tag = isFinalMoment ? 'Final Moment 💖' : _shortTags[index % _shortTags.length];
    final double angle = ((index % 3) - 1) * 0.015;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            isCompact ? 6 : 10,
            isCompact ? 6 : 10,
            isCompact ? 6 : 10,
            isCompact ? 12 : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(isCompact ? 10 : 16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: isCompact ? 1.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF69B4).withValues(alpha: 0.12),
                blurRadius: isCompact ? 8 : 15,
                spreadRadius: isCompact ? 1 : 2,
                offset: Offset(0, isCompact ? 3 : 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(isCompact ? 6 : 10),
                    child: imagePath.endsWith('.mp4')
                        ? IgnorePointer(
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: _AssetVideoPlayer(path: imagePath, autoPlay: false),
                            ),
                          )
                        : Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => _buildErrorImage(isCompact: isCompact),
                          ),
                  ),
                  Positioned(
                    top: isCompact ? -4 : -6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: isCompact ? 8 : 12,
                        height: isCompact ? 8 : 12,
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            colors: [
                              Color(0xFFFFD1DC),
                              Color(0xFFB76E79),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ],
                          border: Border.all(color: Colors.white70, width: isCompact ? 0.5 : 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 6 : 12),
              Center(
                child: Text(
                  tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: GoogleFonts.caveat(
                    color: const Color(0xFFFFD1DC),
                    fontSize: isCompact ? 11 : 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fallback missing asset view
  Widget _buildErrorImage({bool isCompact = false}) {
    return Container(
      color: const Color(0xFF381223),
      height: isCompact ? 80 : 120,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: const Color(0xFFFFC0CB),
          size: isCompact ? 18 : 26,
        ),
      ),
    );
  }
}

// Stateful fullscreen interactive viewer for zooming/panning and swiping
class _InteractivePhotoViewer extends StatefulWidget {
  final int initialIndex;
  final List<String> captions;
  final List<int> memoryOrder;
  final String Function(int) getImagePath;

  const _InteractivePhotoViewer({
    required this.initialIndex,
    required this.captions,
    required this.memoryOrder,
    required this.getImagePath,
  });

  @override
  State<_InteractivePhotoViewer> createState() => _InteractivePhotoViewerState();
}

class _InteractivePhotoViewerState extends State<_InteractivePhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dismissible swipe area
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withValues(alpha: 0.92),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Photo PageView
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.memoryOrder.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final photoNumber = widget.memoryOrder[index];
                final imagePath = widget.getImagePath(photoNumber);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: imagePath.endsWith('.mp4')
                        ? _AssetVideoPlayer(path: imagePath, autoPlay: true)
                        : InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 3.5,
                            child: Hero(
                              tag: 'photo_hero_$photoNumber',
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF69B4).withValues(alpha: 0.15),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    )
                                  ],
                                ),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF2C101B),
                                    width: 300,
                                    height: 300,
                                    child: const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),

          // Top Header Controls
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Photo Number Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.memoryOrder.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Close Button
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Caption area
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFB6C1).withValues(alpha: 0.3), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.captions[_currentIndex],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.greatVibes(
                          color: const Color(0xFFFFD1DC),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Swipe left/right to browse memories",
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ).animate(key: ValueKey(_currentIndex)).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          ),

          // Arrow Navigation overlays (desktops/large screens helper)
          if (_currentIndex > 0)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 18),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
          if (_currentIndex < widget.memoryOrder.length - 1)
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Automated fullscreen auto-play slideshow screen
class _SlideshowScreen extends StatefulWidget {
  final List<String> captions;
  final List<int> memoryOrder;
  final String Function(int) getImagePath;

  const _SlideshowScreen({
    required this.captions,
    required this.memoryOrder,
    required this.getImagePath,
  });

  @override
  State<_SlideshowScreen> createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<_SlideshowScreen> {
  int _currentIndex = 0;
  Timer? _timer;
  bool _isPlaying = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    // Use post-frame callback so the first slide widget is built before starting timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = null;
    final currentPath = widget.getImagePath(widget.memoryOrder[_currentIndex]);
    // Don't start a timer for videos — we wait for the onFinished callback instead
    if (currentPath.endsWith('.mp4')) {
      return;
    }
    // One-shot timer so it doesn't keep firing across slide changes
    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted || !_isPlaying) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.memoryOrder.length;
      });
      // Restart timer for the new slide (image or skip for video)
      _startTimer();
    });
  }

  void _goToNextSlide({bool force = false}) {
    if (!mounted) return;

    final currentPath = widget.getImagePath(widget.memoryOrder[_currentIndex]);
    if (!force && currentPath.endsWith('.mp4')) {
      return;
    }

    _timer?.cancel();
    _timer = null;
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.memoryOrder.length;
    });
    if (_isPlaying) {
      _startTimer();
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _downloadSlideshow() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);
    try {
      await downloadSlideshow(
        widget.memoryOrder.map(widget.getImagePath).toList(growable: false),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slideshow video download is ready.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not download slideshow: $error')),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photoNumber = widget.memoryOrder[_currentIndex];
    final imagePath = widget.getImagePath(photoNumber);
    final caption = photoNumber == 75
        ? 'The final moment, the sweetest chapter of all 🌸'
        : (_currentIndex < widget.captions.length ? widget.captions[_currentIndex] : 'A treasured memory from our story ✨');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated cross-fade image/video
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: imagePath.endsWith('.mp4')
                ? _AssetVideoPlayer(
                    key: ValueKey<int>(_currentIndex),
                    path: imagePath,
                    autoPlay: true,
                    looping: false,
                    onFinished: () {
                      if (_isPlaying) {
                        _goToNextSlide(force: true);
                      }
                    },
                  )
                : Image.asset(
                    imagePath,
                    key: ValueKey<int>(_currentIndex),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black,
                      child: const Icon(Icons.broken_image, color: Colors.white30, size: 64),
                    ),
                  ),
          ),

          // Soft color gradient overlay at bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Sparkle particles for magical ambient look
          const SparkleOverlay(
            child: SizedBox.expand(),
          ),

          // Header Controls
          Positioned(
            top: 48,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.slideshow_rounded, color: Color(0xFFFFB6C1)),
                    const SizedBox(width: 8),
                    Text(
                      'Slideshow Mode',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        tooltip: 'Download slideshow',
                        icon: _isDownloading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.download_rounded, color: Colors.white),
                        onPressed: _downloadSlideshow,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        tooltip: 'Close slideshow',
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Caption & Interactive playback panel
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Caption
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.greatVibes(
                    color: const Color(0xFFFFD1DC),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 8,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ).animate(key: ValueKey<int>(_currentIndex)).fadeIn(duration: 500.ms),

                const SizedBox(height: 24),

                // Controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Prev Button
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded, color: Colors.white70, size: 28),
                      onPressed: () {
                        setState(() {
                          _timer?.cancel();
                          _timer = null;
                          _currentIndex = (_currentIndex - 1 + widget.memoryOrder.length) % widget.memoryOrder.length;
                        });
                        if (_isPlaying) {
                          _startTimer();
                        }
                      },
                    ),

                    const SizedBox(width: 16),

                    // Play/Pause
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE05688),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Next Button
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white70, size: 28),
                      onPressed: () => _goToNextSlide(force: true),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Index tracking dot indicator
                Text(
                  '${_currentIndex + 1} of ${widget.memoryOrder.length} memories',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetVideoPlayer extends StatefulWidget {
  final String path;
  final bool autoPlay;
  final bool looping;
  final VoidCallback? onFinished;

  const _AssetVideoPlayer({
    super.key,
    required this.path,
    this.autoPlay = false,
    this.looping = true,
    this.onFinished,
  });

  @override
  State<_AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<_AssetVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _finishedNotified = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.path);
    _controller.setLooping(widget.looping);
    _controller.addListener(_handleVideoStatus);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _initialized = true;
      });
      if (widget.autoPlay) {
        _controller.play();
      }
    }).catchError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _videoError = error.toString();
      });
    });
  }

  void _handleVideoStatus() {
    if (!mounted || !_controller.value.isInitialized || _finishedNotified) return;

    // Guard: only fire onFinished if the video actually started playing (position > zero)
    // This prevents a race condition where isCompleted is briefly true before play() is called
    final pos = _controller.value.position;
    final dur = _controller.value.duration;
    if (!widget.looping &&
        dur > Duration.zero &&
        pos >= dur - const Duration(milliseconds: 300)) {
      _finishedNotified = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onFinished?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoError != null) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(
          'Unable to play video.\n${_videoError ?? 'Unknown error.'}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );
    }

    if (!_initialized) {
      return Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB6C1)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        );
      },
    );
  }
}
