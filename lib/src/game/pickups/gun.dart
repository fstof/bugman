import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';

import '../player/bugman_player.dart';
import '../utils.dart';
import 'bullet.dart';

const _powerUpTime = 5.0;

class Gun extends GameDecoration with Sensor {
  Timer? powerUpTimer;
  int _ammo = 3;
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
    if (component is BugmanPlayer) {
      _pickUp();
      component.getGun(this);
      component.addScore(50);
      animation = null;
      sprite = inHand;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    powerUpTimer?.update(dt);
    if (_ammo <= 0) {
      removeFromParent();
    }
  }

  void _pickUp() {
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
      default:
        _direction = null;
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
    FlameAudio.play('bleeps/spray.wav');
    _ammo--;
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

  int get ammo => _ammo;
  bool get empty => _ammo <= 0;
  int get powerUpTimeLeft =>
      powerUpTimer == null ? 0 : (_powerUpTime - (powerUpTimer?.current ?? 0)).toInt();

  set powerUp(bool value) {
    _powerUp = value;
    _ammo += 3;
    if (value) {
      powerUpTimer = Timer(_powerUpTime, callback: () {
        _powerUp = false;
        powerUpTimer = null;
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
