import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createVideoControllerFromAsset(String assetPath) async {
  final bytes = await rootBundle.load(assetPath);
  final tempFile = File('${Directory.systemTemp.path}/${assetPath.replaceAll('/', '_')}');
  await tempFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
  return VideoPlayerController.file(tempFile);
}
