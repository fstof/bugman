import 'dart:math' as math;
import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../utils.dart';

class Bullet extends FlyingAttackAngleObject {
  static const size = 32.0;
  final double maxDistance;

  var distanceTraveled = 0.0;
  var used = false;
  Vector2 _previousPosition;

  AnimatedObjectOnce? explosionAnim;

  Bullet({
    this.maxDistance = 0,
    required Vector2 position,
    required double radAngle,
    double damage = 0,
    double speed = 100,
  })  : _previousPosition = position,
        super(
          position: position,
          radAngle: radAngle,
          width: size,
          height: size,
          flyAnimation: BulletSpriteSheet.idle,
          speed: speed,
          damage: damage,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(size / 3, size / 3),
            align: Vector2(16, 16),
          )
        ],
      ),
    );
  }

  // @override
  // void onCollision(GameComponent component, bool active) {
  //   // print('bullet collide called');
  //   if (shouldRemove) return;
  //   // print('continuing');
  //   _explode(component);

  //   removeFromParent();

  //   super.onCollision(component, active);
  //   used = true;
  // }

  @override
  void update(double dt) {
    if (shouldRemove) return;
    super.update(dt);

    if (maxDistance > 0) {
      final distance = _previousPosition.distanceTo(position.position);

      distanceTraveled += distance;

      if (distanceTraveled >= maxDistance) {
        removeFromParent();
      }

      _previousPosition = position.position;
    }
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawCircle(
  //     position.translate(0, -6).center,
  //     size / 2,
  //     Paint()..color = const Color(0xff000000),
  //   );
  // }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  // }

  static Vector2 bulletPositionForDirection(
    double radAngle,
    Vector2 playerPosition,
    double distanceFromPlayer,
  ) {
    final x = math.cos(radAngle) * distanceFromPlayer;
    final y = math.sin(radAngle) * distanceFromPlayer;

    return Vector2(
      playerPosition.x + tileSize * 0.5 + x - (size * 0.5),
      playerPosition.y + tileSize * 0.5 + y - (size * 0.5),
    );
  }
}

class BulletSpriteSheet {
  static Future<SpriteAnimation> get idle => SpriteAnimation.load(
        "player/spray.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.04,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
}
