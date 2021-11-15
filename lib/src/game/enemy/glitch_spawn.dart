import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class GlitchSpawn extends GameComponent {
  GlitchSpawn(Vector2 position, Size size) {
    this.position = Vector2Rect(position, Vector2(size.width, size.height));
  }
}
