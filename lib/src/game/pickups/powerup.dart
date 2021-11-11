import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';

class Powerup extends GameComponent with Sensor {
  Powerup({required Vector2 position}) : super() {
    this.position = Vector2Rect(position - Vector2(tileSize, tileSize) / 2, Vector2.all(tileSize));
    setupSensorArea(Vector2Rect(Vector2.zero(), Vector2.all(tileSize)), intervalCheck: 10);
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
      position.center,
      10,
      Paint()..color = const Color(0xffff00ff),
    );
  }
}
