import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';
import 'bullet.dart';

class Gun extends GameComponent with Sensor {
  Timer? timeToLive;
  Timer? powerUpTimer;
  var used = false;
  var totalTime = 30.0;
  var _powerUp = false;
  Bullet? currentBullet;
  Direction? _direction;

  Gun({required Vector2 position}) : super() {
    super.position = Vector2Rect(
      Vector2(position.x - 16, position.y - 16),
      Vector2.all(tileSize),
    );
    setupSensorArea(Vector2Rect(Vector2.zero(), Vector2.all(tileSize)), intervalCheck: 10);
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
    powerUpTimer?.update(dt);
    timeToLive?.update(dt);
    if (currentBullet != null) {
      // currentBullet!.position = currentBullet!.position.copyWith(position: _bulletPosition);
      // currentBullet!.angle = _bulletAngle;
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
    if (_powerUp) {
      switch (_direction) {
        case Direction.up:
          return position
              .translate(
                -(bulletSized[_powerUp]!.x / 2 - tileSize / 2),
                -(bulletSized[_powerUp]!.x),
              )
              .position;
        case Direction.down:
          return position
              .translate(
                -(bulletSized[_powerUp]!.x / 2 - tileSize / 2),
                tileSize,
              )
              .position;
        case Direction.left:
          return position
              .translate(
                -bulletSized[_powerUp]!.x,
                -tileSize,
              )
              .position;
        case Direction.right:
          return position
              .translate(
                tileSize,
                -tileSize,
              )
              .position;
        default:
          return position.position;
      }
    } else {
      switch (_direction) {
        case Direction.up:
          return position
              .translate(
                -(bulletSized[_powerUp]!.x / 2 - tileSize / 2),
                -(bulletSized[_powerUp]!.x / 2 + tileSize / 2),
              )
              .position;
        case Direction.down:
          return position
              .translate(
                -(bulletSized[_powerUp]!.x / 2 - tileSize / 2),
                (bulletSized[_powerUp]!.x / 2 + tileSize / 2),
              )
              .position;
        case Direction.left:
          return position
              .translate(
                -bulletSized[_powerUp]!.x,
                0,
              )
              .position;
        case Direction.right:
          return position
              .translate(
                tileSize,
                0,
              )
              .position;
        default:
          return position.position;
      }
    }
  }

  double get _bulletAngle {
    switch (_direction) {
      case Direction.up:
        return dToR(90);
      case Direction.down:
        return dToR(-90);
      case Direction.left:
        return dToR(0);
      case Direction.right:
        return dToR(180);
      default:
        return dToR(0);
    }
  }

  void shoot() {
    gameRef.add(currentBullet = Bullet(
      position: _bulletPosition,
      size: bulletSized[_powerUp]!,
      animationFuture: _powerUp ? BulletSpriteSheet.fire : BulletSpriteSheet.normal,
      angle: _bulletAngle,
      onAnimationEnd: () {
        currentBullet?.removeFromParent();
        currentBullet = null;
      },
    ));
  }

  set powerUp(bool value) {
    _powerUp = value;
    if (value) {
      powerUpTimer = Timer(5, callback: () {
        _powerUp = false;
      })
        ..start();
    }
  }
}

final bulletSized = <bool, Vector2>{
  false: Vector2(Bullet.length, tileSize),
  true: Vector2(Bullet.length, Bullet.length),
};
