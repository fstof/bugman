import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';
import 'bullet.dart';

class Gun extends GameComponent with Sensor {
  bool used = false;
  Timer? timeToLive;
  Timer? shootTimer;
  double totalTime = 10;

  Gun({required Vector2 position}) : super() {
    super.position = Vector2Rect(
      Vector2(position.x - 16, position.y - 16),
      Vector2(32, 32),
    );
    shootTimer = Timer(2, repeat: true, callback: () {
      shoot();
    });
  }

  @override
  void onContact(GameComponent component) {
    if (used) return;
    if (component is DummyPlayer) {
      _pickUp();
      component.getGun(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // timeToLive?.update(dt);
    shootTimer?.update(dt);

    // if (position.overlaps(gameRef.player!.position)) {
    //   pickUp();
    //   (gameRef.player as DummyPlayer).getGun(this);
    // }
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      position.translate(0, -6).center,
      2,
      Paint()..color = const Color(0xff000000),
    );
    canvas.drawCircle(
      position.translate(0, -1).center,
      4,
      Paint()..color = const Color(0xffaaaaaa),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: position.translate(0, 7).center, width: 8, height: 16),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xff0000ff),
    );
    canvas.drawRect(
      Rect.fromCenter(center: position.translate(0, 7).center, width: 8, height: 5),
      Paint()..color = const Color(0xff00ffff),
    );
  }

  void _pickUp() {
    timeToLive = Timer(totalTime, callback: () {
      removeFromParent();
    })
      ..start();

    shootTimer?.start();

    used = true;
  }

  void shoot() {
    double angle;
    final direction = directionThePlayerIsIn();

    switch (direction) {
      case Direction.up:
        angle = dToR(90);
        break;
      case Direction.down:
        angle = dToR(270);
        break;
      case Direction.left:
        angle = dToR(180);
        break;
      case Direction.right:
        angle = dToR(0);
        break;
      default:
        angle = dToR(0);
    }

    gameRef.add(Bullet(
      position: Bullet.bulletPositionForDirection(
        angle,
        position.position,
        tileSize * 0.7,
      ),
      radAngle: angle,
      damage: 100,
      maxDistance: 50,
      speed: 200,
    ));
  }
}
