import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../utils.dart';

class EnemyBug extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement, MoveToPositionAlongThePath {
  Timer? moveTimer;

  EnemyBug({required Vector2 position})
      : super(
          position: position - Vector2.all(16),
          height: 32,
          width: 32,
          speed: 51,
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
            // size: Size(20, 20),
            align: Vector2(8, 16),
          )
        ],
      ),
    );
    setupMoveToPositionAlongThePath(
      pathLineStrokeWidth: 4,
      gridSizeIsCollisionSize: false,
      showBarriersCalculated: true,
      pathLineColor: const Color(0xffffffff),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    moveTimer = Timer(
      gameRandom.nextDouble() * 3,
      repeat: true,
      callback: () {
        // print('moving to player');
        if (gameRef.player == null || gameRef.player!.isDead) return;
        final enemies = gameRef.componentsByType<Enemy>();
        moveToPositionAlongThePath(
          gameRef.player!.position.center.toVector2(),
          ignoreCollisions: [gameRef.player, ...enemies],
        );
      },
    )..start();
  }

  @override
  void onCollision(GameComponent component, bool active) {
    super.onCollision(component, active);
    if (component is Player) {
      stopMoveAlongThePath();

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

    if (!isMovingAlongThePath) {
      // moveToPositionAlongThePath(
      //   gameRef.player!.position.center.toVector2(),
      //   ignoreCollisions: [gameRef.player],
      // );

      runRandomMovement(
        dt,
        maxDistance: (tileSize * 5).toInt(),
        minDistance: (tileSize * 1).toInt(),
        runOnlyVisibleInCamera: false,
        speed: speed,
        // timeKeepStopped: 0,
      );
    }
    // seeAndMoveToPlayer(
    //   closePlayer: (player) {
    //     print('I am here');
    //   },
    //   radiusVision: 9999,
    // );
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
