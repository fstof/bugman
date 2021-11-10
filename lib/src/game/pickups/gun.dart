import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';
import 'bullet.dart';

class Gun extends GameComponent with Sensor {
  bool used = false;
  Timer? timeToLive;
  double totalTime = 10;
  Bullet? currentBullet;
  Direction? _direction;

  Gun({required Vector2 position}) : super() {
    super.position = Vector2Rect(
      Vector2(position.x - 16, position.y - 16),
      Vector2(32, 32),
    );
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
    if (currentBullet != null) {
      currentBullet?.position = position.copyWith(position: _bulletPosition);
      currentBullet?.angle = _bulletAngle;
    }
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

    used = true;
  }

  set direction(JoystickMoveDirectional directional) {
    switch (directional) {
      case JoystickMoveDirectional.MOVE_UP:
        _direction = Direction.up;
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        _direction = Direction.down;
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        _direction = Direction.left;
        break;
      case JoystickMoveDirectional.MOVE_RIGHT:
        _direction = Direction.right;
        break;
    }
  }

  Vector2 get _bulletPosition {
    switch (_direction) {
      case Direction.up:
        return position.translate(-(100 - tileSize / 2), -((100 + tileSize / 2))).position;
      case Direction.down:
        return position.translate(-(100 - tileSize / 2), (100 + tileSize / 2)).position;
      case Direction.left:
        return position.translate(-200, 0).position;
      case Direction.right:
        return position.translate((tileSize), 0).position;
      default:
        return position.position;
    }
  }

  double get _bulletAngle {
    switch (_direction) {
      case Direction.up:
        return dToR(-90);
      case Direction.down:
        return dToR(90);
      case Direction.left:
        return dToR(0);
      case Direction.right:
        return dToR(0);
      default:
        return dToR(0);
    }
  }

  void shoot() {
    gameRef.add(currentBullet = Bullet(
      position: _bulletPosition,
      angle: _bulletAngle,
      onAnimationEnd: () {
        currentBullet?.removeFromParent();
        currentBullet = null;
      },
    ));
  }
}
