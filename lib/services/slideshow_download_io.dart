import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

Future<void> saveSlideshow(Uint8List zipBytes) async {
  await Share.shareXFiles(
    [
      XFile.fromData(
        zipBytes,
        name: 'core_memories_slideshow.zip',
        mimeType: 'application/zip',
      ),
    ],
    subject: 'Core memories slideshow',
  );
}
