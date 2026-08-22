import 'slideshow_video_export_io.dart'
    if (dart.library.html) 'slideshow_video_export_web.dart' as platform;

Future<void> downloadSlideshow(List<String> assetPaths) async {
  await platform.exportSlideshow(assetPaths);
}
