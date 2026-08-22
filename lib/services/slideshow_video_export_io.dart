import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportSlideshow(List<String> assetPaths) async {
  if (assetPaths.isEmpty) {
    throw StateError('No slideshow slides are available to download.');
  }

  final temporaryDirectory = await getTemporaryDirectory();
  final inputPaths = <String>[];
  final inputArguments = <String>[];
  final filters = <String>[];
  File? outputFile;

  try {
    for (var index = 0; index < assetPaths.length; index++) {
      final assetPath = assetPaths[index];
      final data = await rootBundle.load(assetPath);
      final extension = assetPath.split('.').last.toLowerCase();
      final inputPath = '${temporaryDirectory.path}/slideshow_input_$index.$extension';
      await File(inputPath).writeAsBytes(data.buffer.asUint8List());
      inputPaths.add(inputPath);

      if (extension == 'mp4') {
        inputArguments.addAll(['-i', inputPath]);
      } else {
        inputArguments.addAll(['-loop', '1', '-t', '4', '-i', inputPath]);
      }

      filters.add(
        '[$index:v]scale=640:360:force_original_aspect_ratio=decrease,'
        'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=15,'
        'format=yuv420p,setpts=PTS-STARTPTS[v$index]',
      );
    }

    final outputPath = '${temporaryDirectory.path}/core_memories_slideshow.mp4';
    final command = <String>[
      ...inputArguments,
      '-filter_complex', '${filters.join(';')};${List.generate(assetPaths.length, (index) => '[v$index]').join()}concat=n=${assetPaths.length}:v=1:a=0[outv]',
      '-map', '[outv]',
      '-an',
      '-c:v', 'libx264',
      '-preset', 'ultrafast',
      '-crf', '28',
      '-threads', '2',
      '-movflags', '+faststart',
      '-y',
      outputPath,
    ].map(_quoteArgument).join(' ');

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (!ReturnCode.isSuccess(returnCode)) {
      final output = await session.getOutput();
      throw StateError('Could not create slideshow video. ${output ?? ''}');
    }

    outputFile = File(outputPath);
    if (!await outputFile.exists()) {
      throw StateError('The slideshow video was not created.');
    }

    await Share.shareXFiles(
      [XFile(outputPath, name: 'core_memories_slideshow.mp4', mimeType: 'video/mp4')],
      subject: 'Core memories slideshow',
    );
  } finally {
    for (final inputPath in inputPaths) {
      try {
        await File(inputPath).delete();
      } on FileSystemException {
        // Temporary cleanup should not turn a failed export into another failure.
      }
    }
    if (outputFile != null) {
      try {
        await outputFile.delete();
      } on FileSystemException {
        // Temporary cleanup should not turn a failed export into another failure.
      }
    }
  }
}

String _quoteArgument(String argument) {
  return '"${argument.replaceAll('"', '\\"')}"';
}
