import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class EnemyBug extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement, MoveToPositionAlongThePath {
  Timer? moveTimer;

  EnemyBug({required Vector2 position})
      : super(
          position: position - Vector2.all(16),
          height: 32,
          width: 32,
          speed: 50,
          animation: SimpleDirectionAnimation(
            idleLeft: _SpriteSheet.idleLeft,
            idleRight: _SpriteSheet.idleRight,
            runRight: _SpriteSheet.runRight,
            runLeft: _SpriteSheet.runLeft,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(width * 0.5, height * 0.5),
            align: Vector2(8, 16),
          )
        ],
      ),
    );
    setupMoveToPositionAlongThePath(
      pathLineStrokeWidth: 0,
      tileSizeIsSizeCollision: true,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    moveTimer = Timer(
      2,
      repeat: true,
      callback: () {
        if (gameRef.player == null || gameRef.player!.isDead) return;
        moveToPositionAlongThePath(
          gameRef.player!.position.center.toVector2(),
          ignoreCollisions: [gameRef.player],
        );
      },
    )..start();
  }

  @override
  void onCollision(GameComponent component, bool active) {
    super.onCollision(component, active);
    if (component is Player) {
      // gameRef.camera.shake(duration: 0.5);
      // gameRef.camera.animateZoom(
      //   zoom: 4,
      //   duration: const Duration(milliseconds: 500),
      //   finish: () {
      //     gameRef.camera.animateZoom(zoom: 1);
      //   },
      // );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    moveTimer?.update(dt);
  }
}

class _SpriteSheet {
  static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "enemy/Cobra Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "enemy/Cobra Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );

  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "enemy/Cobra Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "enemy/Cobra Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
}
