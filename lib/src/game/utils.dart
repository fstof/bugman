import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

const tileSize = 32.0;
final gameRandom = Random();

bool isMobile() {
  if (!kIsWeb) {
    return Platform.isIOS || Platform.isAndroid;
  }
  return false;
}

double dToR(double d) {
  return d / 180 * pi;
}

double rToD(double r) {
  return r * 180 / pi;
}
