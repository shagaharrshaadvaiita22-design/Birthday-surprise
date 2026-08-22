import 'dart:html' as html;
import 'dart:typed_data';

Future<void> saveSlideshow(Uint8List zipBytes) async {
  final blob = html.Blob([zipBytes], 'application/zip');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = 'core_memories_slideshow.zip'
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}
