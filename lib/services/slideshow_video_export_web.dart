import 'dart:html' as html;

import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/services.dart';

Future<void> exportSlideshow(List<String> assetPaths) async {
  if (assetPaths.isEmpty) {
    throw StateError('No slideshow slides are available to download.');
  }

  final ffmpeg = createFFmpeg(
    CreateFFmpegParam(
      log: false,
      corePath: 'https://unpkg.com/@ffmpeg/core-st@0.11.1/dist/ffmpeg-core.js',
      mainName: 'main',
    ),
  );
  if (!ffmpeg.isLoaded()) {
    await ffmpeg.load();
  }

  final inputArguments = <String>[];
  final filters = <String>[];
  final temporaryFiles = <String>[];

  for (var index = 0; index < assetPaths.length; index++) {
    final assetPath = assetPaths[index];
    final data = await rootBundle.load(assetPath);
    final extension = assetPath.split('.').last.toLowerCase();
    final inputName = 'slideshow_input_$index.$extension';
    temporaryFiles.add(inputName);
    ffmpeg.writeFile(inputName, data.buffer.asUint8List());

    if (extension == 'mp4') {
      inputArguments.addAll(['-i', inputName]);
    } else {
      inputArguments.addAll(['-loop', '1', '-t', '4', '-i', inputName]);
    }

    filters.add(
      '[$index:v]scale=640:360:force_original_aspect_ratio=decrease,'
      'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=15,'
      'format=yuv420p,setpts=PTS-STARTPTS[v$index]',
    );
  }

  const outputName = 'core_memories_slideshow.mp4';
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
    outputName,
  ];

  await ffmpeg.run(command);
  final output = ffmpeg.readFile(outputName);
  final blob = html.Blob([output], 'video/mp4');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = outputName
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  for (final file in [...temporaryFiles, outputName]) {
    ffmpeg.unlink(file);
  }
  ffmpeg.exit();
}
