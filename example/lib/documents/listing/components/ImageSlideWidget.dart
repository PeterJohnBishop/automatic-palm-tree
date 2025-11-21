import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageSlideWidget extends StatefulWidget {
  final String imagePath;
  const ImageSlideWidget({super.key, required this.imagePath});

  @override
  State<ImageSlideWidget> createState() =>
      _DesktopImageSlideWidgetState();
}

class _DesktopImageSlideWidgetState extends State<ImageSlideWidget> {
  BoxFit _fit = BoxFit.cover; // default
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _resolveImageDimensions();
  }

  void _resolveImageDimensions() async {
    final Image image = Image.asset(widget.imagePath);
    final ImageStream stream = image.image.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      final ui.Image img = info.image;
      final width = img.width.toDouble();
      final height = img.height.toDouble();

      setState(() {
        _fit = width > height ? BoxFit.fitWidth : BoxFit.fitHeight;
        _loaded = true;
      });
      stream.removeListener(listener); // clean up listener
    });
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final double imageSize = width.clamp(400, 600);

        return Center(
          child: Container(
            width: imageSize,
            height: imageSize,
            color: Colors.white,
            child: _loaded
                ? Image.asset(widget.imagePath, fit: _fit)
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
