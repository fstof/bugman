import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class Powerup extends GameComponent {
  Powerup({required Vector2 position}) : super() {
    super.position = Vector2Rect(position, Vector2(32, 32));
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      position.offset,
      10,
      Paint()..color = const Color(0xffff00ff),
    );
  }
}
