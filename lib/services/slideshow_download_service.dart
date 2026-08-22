import 'package:archive/archive.dart';
import 'package:flutter/services.dart';

import 'slideshow_download_io.dart'
    if (dart.library.html) 'slideshow_download_web.dart' as platform;

Future<void> downloadSlideshow(List<String> assetPaths) async {
  final archive = Archive();

  for (final assetPath in assetPaths) {
    final data = await rootBundle.load(assetPath);
    final fileName = assetPath.split('/').last;
    archive.addFile(ArchiveFile(fileName, data.lengthInBytes, data.buffer.asUint8List()));
  }

  final zipBytes = Uint8List.fromList(ZipEncoder().encode(archive) ?? <int>[]);
  await platform.saveSlideshow(zipBytes);
}
