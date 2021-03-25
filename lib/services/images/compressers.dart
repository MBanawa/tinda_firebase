import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> comporessList(
  Uint8List list,
  int quality, {
  int minHeight: 120,
  int minWidth: 120,
}) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: minHeight,
    minWidth: minWidth,
    quality: 96,
    rotate: 135,
  );
  return result;
}
