import 'package:flutter/material.dart';
import '../services/audio_manager.dart';

class MusicControlButton extends StatefulWidget {
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;

  const MusicControlButton({
    super.key,
    this.iconColor,
    this.backgroundColor,
    this.size = 44.0,
  });

  @override
  State<MusicControlButton> createState() => _MusicControlButtonState();
}

class _MusicControlButtonState extends State<MusicControlButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    AudioManager.instance.isPlayingNotifier.addListener(_handlePlayStateChanged);
    if (AudioManager.instance.isPlayingNotifier.value) {
      _rotationController.repeat();
    }
  }

  void _handlePlayStateChanged() {
    if (!mounted) return;
    if (AudioManager.instance.isPlayingNotifier.value) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    AudioManager.instance.isPlayingNotifier.removeListener(_handlePlayStateChanged);
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AudioManager.instance.isPlayingNotifier,
      builder: (context, isPlaying, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: AudioManager.instance.isMutedNotifier,
          builder: (context, isMuted, child) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AudioManager.instance.togglePlayPause();
                },
                borderRadius: BorderRadius.circular(widget.size / 2),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPlaying
                          ? const Color(0xFFFF85A1)
                          : Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: isPlaying
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Icon(
                      isPlaying
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      color: widget.iconColor ??
                          (isPlaying ? const Color(0xFFFFB6C1) : Colors.white60),
                      size: widget.size * 0.5,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
