import 'package:bonfire/bonfire.dart';

import '../enemy/enemy_bug.dart';
import '../utils.dart';

class Bullet extends AnimatedObject with Sensor {
  static const length = tileSize * 3;

  Timer? _showTimer;
  Future<SpriteAnimation> animationFuture;
  final Function onAnimationEnd;

  Bullet({
    required Vector2 position,
    required Vector2 size,
    required this.animationFuture,
    double? angle,
    required this.onAnimationEnd,
  }) {
    this.position = Vector2Rect(position, size);
    this.angle = angle ?? 0;

    setupSensorArea(Vector2Rect(Vector2.zero(), size), intervalCheck: 10);
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    // animation = await BulletSpriteSheet.normal;
    animation = await animationFuture;
    _showTimer = Timer(1, callback: () {
      _showTimer = null;
      removeFromParent();
    })
      ..start();
  }

  @override
  void onContact(GameComponent component) {
    if (component is EnemyBug) {
      component.returnToHome();
    }
  }

  @override
  void update(double dt) {
    width = length;
    if (shouldRemove) return;

    super.update(dt);
    _showTimer?.update(dt);

    if (animation?.isLastFrame ?? false) {
      onAnimationEnd();
    }
  }
}

class BulletSpriteSheet {
  static Future<SpriteAnimation> get normal => SpriteAnimation.load(
        "player/spray.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          loop: false,
          textureSize: Vector2(tileSize * 3, tileSize),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get fire => SpriteAnimation.load(
        "player/fire_spray.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          loop: false,
          textureSize: Vector2(tileSize * 3, tileSize * 3),
          texturePosition: Vector2(0, 0),
        ),
      );
}
