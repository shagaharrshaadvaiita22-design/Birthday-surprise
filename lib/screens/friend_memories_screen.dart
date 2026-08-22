import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';
import '../models/birthday_config.dart';
import '../utils/asset_video_controller_io.dart';
import '../widgets/sparkle_overlay.dart';
import '../widgets/music_control_button.dart';

class FriendMemoriesScreen extends StatefulWidget {
  final BirthdayConfig config;

  const FriendMemoriesScreen({super.key, required this.config});

  @override
  State<FriendMemoriesScreen> createState() => _FriendMemoriesScreenState();
}

class _FriendMemoriesScreenState extends State<FriendMemoriesScreen> {
  int? _activePlayingIndex;
  VideoPlayerController? _activeController;
  bool _isControllerInitialized = false;
  bool _isMuted = false;
  String? _videoErrorMessage;

  late final List<Map<String, String>> _videoMemories;

  @override
  void initState() {
    super.initState();
    _videoMemories = [
      {
        'title': 'Special Birthday Moments 🎬✨',
        'duration': 'Video 1',
        'friends': 'Likitha Solo Doodles',
        'desc': 'A heartfelt video tribute celebrating Likitha\'s 21st birthday journey!',
        'thumbnail': 'assets/images/her_doodle_thumb.png',
        'videoPath': 'assets/videos/v 1.mp4',
      },
      {
        'title': 'Forever Friends Memories 🥳🎉',
        'duration': 'Video 2',
        'friends': 'Friends Squad Doodles',
        'desc': 'Unforgettable laughs, trips, and golden memories created together.',
        'thumbnail': 'assets/images/friends_doodle_thumb.png',
        'videoPath': 'assets/videos/v 2.mp4',
      },
      {
        'title': 'Brother & Sister Moments 👫💖',
        'duration': 'Video 3',
        'friends': 'Brother & Sister',
        'desc': 'A sweet, funny & special compilation of golden memories with your brother!',
        'thumbnail': 'assets/images/brosis_doodle_thumb.png',
        'videoPath': 'assets/videos/v 3.mp4',
      },
    ];
  }

  bool _isVideo3Unlocked = false;

  @override
  void dispose() {
    _activeController?.dispose();
    super.dispose();
  }

  /// Shows a 4-digit PIN dialog gating Video 3. PIN is 0707.
  Future<void> _showPinLockDialog(int videoIndex) async {
    String entered = '';
    bool shakeError = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDS) {
          void onDigit(String d) {
            if (entered.length < 4) {
              setDS(() => entered += d);
              if (entered.length == 4) {
                if (entered == '0707') {
                  setState(() => _isVideo3Unlocked = true);
                  Navigator.pop(ctx);
                  _playVideoAtIndex(videoIndex);
                } else {
                  setDS(() {
                    shakeError = true;
                    entered = '';
                  });
                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (ctx.mounted) setDS(() => shakeError = false);
                  });
                }
              }
            }
          }

          void onDelete() {
            if (entered.isNotEmpty) setDS(() => entered = entered.substring(0, entered.length - 1));
          }

          void onClear() {
            if (entered.isNotEmpty) setDS(() => entered = '');
          }

          Widget buildKey(String label, VoidCallback onTap, {Color? fg}) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white24),
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

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 80),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C0F1C), Color(0xFF4A182D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFFF85A1).withValues(alpha: 0.6), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF69B4).withValues(alpha: 0.25),
                    blurRadius: 30,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded, color: Color(0xFFFFB6C1), size: 36),
                  const SizedBox(height: 10),
                  Text(
                    'Enter PIN to Unlock 🔐',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This video is locked for you to enjoy later',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // PIN Dots
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    transform: shakeError
                        ? (Matrix4.translationValues(8, 0, 0))
                        : Matrix4.identity(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) {
                        final filled = i < entered.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: shakeError
                                ? Colors.redAccent
                                : (filled ? const Color(0xFFFF85A1) : Colors.white24),
                            border: Border.all(
                              color: filled ? const Color(0xFFFF85A1) : Colors.white38,
                              width: 1.5,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Number pad
                  Row(
                    children: [
                      buildKey('1', () => onDigit('1')),
                      buildKey('2', () => onDigit('2')),
                      buildKey('3', () => onDigit('3')),
                    ],
                  ),
                  Row(
                    children: [
                      buildKey('4', () => onDigit('4')),
                      buildKey('5', () => onDigit('5')),
                      buildKey('6', () => onDigit('6')),
                    ],
                  ),
                  Row(
                    children: [
                      buildKey('7', () => onDigit('7')),
                      buildKey('8', () => onDigit('8')),
                      buildKey('9', () => onDigit('9')),
                    ],
                  ),
                  Row(
                    children: [
                      buildKey('C', onClear, fg: Colors.orangeAccent),
                      buildKey('0', () => onDigit('0')),
                      buildKey('⌫', onDelete, fg: const Color(0xFFFFB6C1)),
                    ],
                  ),
                  if (shakeError) ...
                  [
                    const SizedBox(height: 12),
                    Text(
                      'Wrong PIN, try again ✗',
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _playVideoAtIndex(int index) async {
    if (_activePlayingIndex == index && _activeController != null) {
      if (_activeController!.value.isPlaying) {
        await _activeController!.pause();
        setState(() {});
      } else {
        await _activeController!.play();
        setState(() {});
      }
      return;
    }

    // Stop and dispose previous controller
    if (_activeController != null) {
      await _activeController!.pause();
      await _activeController!.dispose();
      _activeController = null;
    }

    final videoPath = _videoMemories[index]['videoPath']!;

    setState(() {
      _activePlayingIndex = index;
      _isControllerInitialized = false;
      _videoErrorMessage = null;
    });

    // Use direct asset loading on mobile/native platforms.
    // Keep browser-compatible fallbacks only for web builds.
    final encodedPath = Uri.encodeFull(videoPath);
    final isWeb = kIsWeb;

    final strategies = <Future<VideoPlayerController> Function()>[];

    if (isWeb) {
      final cleanPath = videoPath.startsWith('assets/') ? videoPath.substring(7) : videoPath;
      strategies.addAll([
        () async => VideoPlayerController.asset(videoPath),
        () async => VideoPlayerController.asset(encodedPath),
        () async => VideoPlayerController.networkUrl(Uri.parse(encodedPath)),
        () async => VideoPlayerController.networkUrl(Uri.parse(Uri.encodeFull('assets/$videoPath'))),
        () async => VideoPlayerController.networkUrl(Uri.parse(Uri.encodeFull('assets/assets/$cleanPath'))),
        () async => VideoPlayerController.networkUrl(Uri.parse('assets/videos/${Uri.encodeComponent(cleanPath.replaceFirst('videos/', ''))}')),
      ]);
    } else {
      strategies.addAll([
        () async => VideoPlayerController.asset(videoPath),
        () async => VideoPlayerController.asset(encodedPath),
        () async => createVideoControllerFromAsset(videoPath),
      ]);
    }

    VideoPlayerController? successfulController;
    Object? lastException;

    for (final strategy in strategies) {
      try {
        final controller = await strategy();
        await controller.initialize();
        successfulController = controller;
        lastException = null;
        break; // Successfully initialized!
      } catch (e) {
        lastException = e;
      }
    }

    if (successfulController != null) {
      _activeController = successfulController;
      await _activeController!.setLooping(false);
      await _activeController!.setVolume(_isMuted ? 0.0 : 1.0);
      await _activeController!.play();

      if (mounted && _activePlayingIndex == index) {
        setState(() {
          _isControllerInitialized = true;
        });
      }
    } else {
      debugPrint('Error loading video asset $videoPath across all strategies: $lastException');
      if (mounted && _activePlayingIndex == index) {
        setState(() {
          _isControllerInitialized = false;
          _videoErrorMessage = isWeb
              ? 'Browser Video Format Issue:\n$lastException'
              : 'Video could not be loaded. Ensure the asset exists and is supported on this device.';
        });
      }
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _activeController?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _openFullscreenPlayer(String title, VideoPlayerController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withValues(alpha: 0.95),
          insetPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio > 0
                          ? controller.value.aspectRatio
                          : 16 / 9,
                      child: VideoPlayer(controller),
                    ),
                  ),

                  // Header Bar in Dialog
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                          ),
                        ),
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

                  // Bottom Controls in Dialog
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: const Color(0xFFFFB6C1),
                              size: 32,
                            ),
                            onPressed: () {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                              setDialogState(() {});
                              setState(() {});
                            },
                          ),
                          Expanded(
                            child: VideoProgressIndicator(
                              controller,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Color(0xFFFF69B4),
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _toggleMute();
                              setDialogState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
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

            SafeArea(
              child: Column(
                children: [
                  // App Bar
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
                            const Icon(Icons.video_library_rounded, color: Color(0xFFFFB6C1), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Forever Friends Videos 🎬',
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

                  // Subtitle Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text(
                      '3 Special Video Tributes created for Princess ${widget.config.girlName} ✨',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Video Memories List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _videoMemories.length,
                      itemBuilder: (context, index) {
                        final video = _videoMemories[index];
                        final isPlayingThis = _activePlayingIndex == index;
                        final controller = isPlayingThis ? _activeController : null;
                        final isInit = isPlayingThis && _isControllerInitialized && controller != null;
                        final hasError = isPlayingThis && _videoErrorMessage != null;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 22),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isPlayingThis
                                  ? (hasError ? Colors.orangeAccent : const Color(0xFFFFB6C1))
                                  : Colors.white24,
                              width: isPlayingThis ? 2 : 1,
                            ),
                            boxShadow: [
                              if (isPlayingThis)
                                BoxShadow(
                                  color: hasError
                                      ? Colors.orange.withValues(alpha: 0.3)
                                      : const Color(0xFFFF69B4).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Video Preview / Active Player
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                                    child: AspectRatio(
                                      aspectRatio: 1.8,
                                      child: isInit
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                VideoPlayer(controller),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: VideoProgressIndicator(
                                                    controller,
                                                    allowScrubbing: true,
                                                    colors: const VideoProgressColors(
                                                      playedColor: Color(0xFFFF69B4),
                                                      bufferedColor: Colors.white30,
                                                      backgroundColor: Colors.white10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : _DoodleThumbnailWidget(assetPath: video['thumbnail']!),
                                    ),
                                  ),

                                  // Loading Spinner or Play/Pause Button or Error Box
                                  if (isPlayingThis && !_isControllerInitialized && !hasError)
                                    const CircularProgressIndicator(
                                      color: Color(0xFFFF69B4),
                                    )
                                  else if (hasError)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.orangeAccent),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.warning_amber_rounded,
                                              color: Colors.orangeAccent, size: 36),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Browser Codec / Format Note ⚠️',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Your browser cannot decode "${video['duration']}". Ensure the video is encoded in H.264 MP4 format with AAC audio for web browser playback.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () {
                                        if (index == 2 && !_isVideo3Unlocked) {
                                          _showPinLockDialog(index);
                                        } else {
                                          _playVideoAtIndex(index);
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: (isInit && controller.value.isPlaying)
                                              ? Colors.green.withValues(alpha: 0.85)
                                              : const Color(0xFFE05688).withValues(alpha: 0.85),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.5),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          (index == 2 && !_isVideo3Unlocked)
                                              ? Icons.lock_rounded
                                              : ((isInit && controller.value.isPlaying)
                                                  ? Icons.pause_rounded
                                                  : Icons.play_arrow_rounded),
                                          color: Colors.white,
                                          size: 38,
                                        ),
                                      ),
                                    ),

                                  // Badge (File name / Duration)
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        video['duration']!,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Mute & Fullscreen Quick Buttons when Playing
                                  if (isInit)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.black54,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              onPressed: _toggleMute,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.black54,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons.fullscreen_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              onPressed: () => _openFullscreenPlayer(
                                                  video['title']!, controller),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),

                              // Video Details & Info
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            video['title']!,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE05688).withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: const Color(0xFFFFB6C1).withValues(alpha: 0.5)),
                                          ),
                                          child: Text(
                                            video['friends']!,
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFFFFD1DC),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      video['desc']!,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withValues(alpha: 0.75),
                                        fontSize: 12.5,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Action Bar (Tap to play / Fullscreen)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              // Video 3 is PIN-locked
                                              if (index == 2 && !_isVideo3Unlocked) {
                                                _showPinLockDialog(index);
                                              } else {
                                                _playVideoAtIndex(index);
                                              }
                                            },
                                            icon: Icon(
                                              (index == 2 && !_isVideo3Unlocked)
                                                  ? Icons.lock_rounded
                                                  : ((isInit && controller.value.isPlaying)
                                                      ? Icons.pause_rounded
                                                      : Icons.play_arrow_rounded),
                                              color: const Color(0xFFFFB6C1),
                                              size: 18,
                                            ),
                                            label: Text(
                                              (index == 2 && !_isVideo3Unlocked)
                                                  ? 'Locked 🔒 Enter PIN'
                                                  : ((isInit && controller.value.isPlaying)
                                                      ? 'Pause Video'
                                                      : 'Play Video (${video['duration']})'),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: isPlayingThis
                                                    ? const Color(0xFFFFB6C1)
                                                    : Colors.white24,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (isInit) ...[
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () => _openFullscreenPlayer(
                                                video['title']!, controller),
                                            icon: const Icon(Icons.fullscreen_rounded,
                                                color: Color(0xFFFFB6C1)),
                                            tooltip: 'Expand Fullscreen',
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 500.ms, delay: (100 * index).ms);
                      },
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

class _DoodleThumbnailWidget extends StatelessWidget {
  final String assetPath;

  const _DoodleThumbnailWidget({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        final altPath = assetPath.startsWith('assets/')
            ? assetPath.substring(7)
            : 'assets/$assetPath';
        return Image.asset(
          altPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error2, stackTrace2) {
            return Image.asset(
              'assets/images/birthday_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error3, stackTrace3) {
                return Container(
                  color: const Color(0xFF4A182D),
                  child: const Icon(Icons.movie_creation_rounded,
                      size: 50, color: Color(0xFFFFB6C1)),
                );
              },
            );
          },
        );
      },
    );
  }
}
