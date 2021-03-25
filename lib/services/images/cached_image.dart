import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:tinda/models/shared/cached_image.dart';

import 'compressers.dart';

Future<CachedImage> cacheImage(
  String url,
  Uint8List data, {
  List<String> customPathList,
  int quality: 80,
  int minHeight: 120,
  int minWidth: 120,
}) async {
  String dataPath = (await getApplicationDocumentsDirectory()).path + '/';

  if (customPathList != null) {
    customPathList.forEach((element) {
      dataPath += '$element/';
    });
  } else {
    dataPath += 'images/';
  }

  Directory dataPathDir = Directory(dataPath);
  if (!(await dataPathDir.exists())) await dataPathDir.create(recursive: true);

  dataPath += '${url.replaceAll('/', '_')}.png';
  File dataFile = File(dataPath);

  if (!(await dataFile.exists()))
    dataFile = await dataFile.create();
  else
    await dataFile.delete();

  await dataFile.writeAsBytes(await comporessList(
    data,
    quality,
    minHeight: minHeight,
    minWidth: minWidth,
  ));

  CachedImage image = CachedImage(
    url: url,
    filePath: dataPath,
    creationDate: DateTime.now(),
    lastUseDate: DateTime.now(),
    usesCount: 1,
    quality: quality,
  );

  LazyBox<CachedImage> box = Hive.lazyBox(cachedImagesBoxName);
  await box.put(url + '_$quality', image);
  return await box.get(url + '_$quality');
}

Future<CachedImage> getCachedImage(
  String url, {
  List<String> customPathList,
  int quality: 80,
  int minHeight: 120,
  int minWidth: 120,
}) async {
  LazyBox<CachedImage> box = Hive.lazyBox(cachedImagesBoxName);
  if (box.containsKey(url + '_$quality')) {
    return await box.get(url + '_$quality');
  } else {
    var res = await http.get(
      Uri.parse(url),
    );
    if (res.statusCode == 200)
      try {
        var img = await cacheImage(
          url,
          res.bodyBytes,
          customPathList: customPathList,
          quality: quality,
          minHeight: minHeight,
          minWidth: minWidth,
        );
        return img;
      } catch (e) {
        throw e;
      }
  }
  print('Error when caching image');
  throw Exception('Couldn\'t fetch image');
}
