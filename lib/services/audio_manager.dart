import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager instance = AudioManager._internal();
  factory AudioManager() => instance;
  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMutedNotifier = ValueNotifier<bool>(false);
  bool _isInitialized = false;

  static const String happyBirthdaySongPath = 'song/starostin-happy-birthday-357371.mp3';

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _audioPlayer.onPlayerStateChanged.listen((state) {
        isPlayingNotifier.value = state == PlayerState.playing;
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AudioManager: $e');
    }
  }

  Future<void> playHappyBirthday() async {
    try {
      await init();
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(happyBirthdaySongPath));
      if (isMutedNotifier.value) {
        await _audioPlayer.setVolume(0.0);
      } else {
        await _audioPlayer.setVolume(1.0);
      }
      isPlayingNotifier.value = true;
    } catch (e) {
      debugPrint('Error playing happy birthday audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      isPlayingNotifier.value = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await playHappyBirthday();
      }
      isPlayingNotifier.value = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlayingNotifier.value) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> toggleMute() async {
    final nextMuteState = !isMutedNotifier.value;
    isMutedNotifier.value = nextMuteState;
    try {
      if (nextMuteState) {
        await _audioPlayer.setVolume(0.0);
      } else {
        await _audioPlayer.setVolume(1.0);
      }
    } catch (e) {
      debugPrint('Error toggling mute: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      isPlayingNotifier.value = false;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
