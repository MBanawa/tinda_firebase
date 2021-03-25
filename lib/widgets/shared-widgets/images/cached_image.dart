import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:tinda/models/shared/cached_image.dart';
import 'package:tinda/services/images/cached_image.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final BoxFit boxFit;
  final double width, height;
  final int cacheWidth, cacheHeight;
  final int quality;
  final List<String> customPathList;
  final ColorFilter colorFilter;

  const CachedImageWidget({
    Key key,
    @required this.url,
    this.boxFit: BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.quality: 80,
    this.customPathList,
    this.colorFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CachedImage>(
      future: getCachedImage(
        url,
        quality: quality,
        customPathList: customPathList,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) if (colorFilter != null)
          return ColorFiltered(
            colorFilter: colorFilter,
            child: Image.file(
              File(snapshot.data.filePath),
              fit: boxFit,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
              width: width,
              height: height,
            ),
          );
        else
          return Image.file(
            File(snapshot.data.filePath),
            fit: boxFit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            width: width,
            height: height,
          );
        else if (snapshot.hasError) return Icon(Icons.error_outline);
        return ImageLoadingWidget();
      },
    );
  }
}

class ImageLoadingWidget extends StatelessWidget {
  const ImageLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      ),
    );
  }
}
