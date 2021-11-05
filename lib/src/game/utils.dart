import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

const tileSize = 32.0;

bool isMobile() {
  if (!kIsWeb) {
    return Platform.isIOS || Platform.isAndroid;
  }
  return false;
}

final gameRandom = Random();
