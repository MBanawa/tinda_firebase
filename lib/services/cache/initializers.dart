import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tinda/models/shared/cached_image.dart';

initializeCache() async {
  await initializeHive();
}

initializeHive() async {
  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk(cachedImagesBoxName);

  if (!Hive.isAdapterRegistered(CachedImageAdapter().typeId))
    Hive.registerAdapter<CachedImage>(CachedImageAdapter());

  if (!Hive.isBoxOpen(cachedImagesBoxName))
    await Hive.openLazyBox<CachedImage>(cachedImagesBoxName);
}
