import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bugman/src/game/enemy/enemy_bug.dart';

class HomeBase extends GameComponent with Sensor {
  HomeBase({required Vector2 position, required Size size}) {
    this.position = this.position.copyWith(
          position: position,
          size: Vector2(size.width, size.height),
        );
  }

  @override
  void onContact(GameComponent component) {
    if (component is EnemyBug) {
      component.homeReached();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // canvas.drawRect(position.rect, Paint()..color = Color(0xffffffff));
    // canvas.drawCircle(position.center, 32, Paint()..color = Color(0xff000000));
  }
}
