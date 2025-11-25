import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

Future<Size> getImageSize(String url) async {
  final Completer<Size> completer = Completer();

  final Image image = Image.network(url);
  final ImageStream stream = image.image.resolve(const ImageConfiguration());

  late ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
    final myImage = info.image;
    completer.complete(Size(myImage.width.toDouble(), myImage.height.toDouble()));
    stream.removeListener(listener);
  });

  stream.addListener(listener);

  return completer.future;
}
