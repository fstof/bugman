import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bugman/src/game/player/dummy_player.dart';

class Powerup extends GameComponent with Sensor {
  Powerup({required Vector2 position}) : super() {
    super.position = Vector2Rect(position, Vector2(32, 32));
  }

  @override
  void onContact(GameComponent component) {
    if (component is DummyPlayer) {
      component.powerup();
      removeFromParent();
    }
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
