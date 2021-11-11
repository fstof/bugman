import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';
import 'bullet.dart';

class Gun extends GameDecoration with Sensor {
  Timer? timeToLive;
  Timer? powerUpTimer;
  var used = false;
  var totalTime = 30.0;
  var _powerUp = false;
  Bullet? currentBullet;
  Direction? _direction;

  Sprite? inHand;
  SpriteAnimation? idle;

  Gun({required Vector2 position})
      : super(
          position: Vector2(position.x - 16, position.y - 16),
          width: tileSize,
          height: tileSize,
        ) {
    setupSensorArea(Vector2Rect(Vector2.zero(), Vector2.all(tileSize)), intervalCheck: 10);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    inHand = await _SpriteSheet.spriteInHand;
    idle = await _SpriteSheet.spriteIdle;
    animation = idle;
  }

  @override
  void onContact(GameComponent component) {
    if (used) return;
    if (component is DummyPlayer) {
      _pickUp();
      component.getGun(this);
      animation = null;
      sprite = inHand;
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

class _SpriteSheet {
  static Future<Sprite> get spriteInHand => Sprite.load(
        "objects/spray-can.png",
        srcPosition: Vector2.zero(),
        srcSize: Vector2(tileSize, tileSize),
      );
  static Future<SpriteAnimation> get spriteIdle => SpriteAnimation.load(
        "objects/spray-can.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2.zero(),
        ),
      );
}
