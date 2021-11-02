import 'dart:io';

import 'package:flutter/foundation.dart';

const tileSize = 32.0;

bool isMobile() {
  if (!kIsWeb) {
    return Platform.isIOS || Platform.isAndroid;
  }
  return false;
}
