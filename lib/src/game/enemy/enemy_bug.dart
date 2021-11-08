import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../utils.dart';
import 'grasshopper.dart';
import 'home_base.dart';
import 'moth.dart';
import 'scorpion.dart';
import 'spider.dart';

enum ButType { spyder, scorpion, moth, grasshopper }

abstract class EnemyBug extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement, MoveToPositionAlongThePath {
  Timer? moveTimer;
  bool _goingHom = false;

  EnemyBug({
    required Vector2 position,
    required SimpleDirectionAnimation animation,
    required double speed,
  }) : super(
          position: position - Vector2.all(16),
          height: tileSize,
          width: tileSize,
          speed: speed,
          animation: animation,
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
      showBarriersCalculated: false,
      pathLineColor: const Color(0x00ffffff),
    );
  }

  factory EnemyBug.createEnemy({required ButType type, required Vector2 position}) {
    switch (type) {
      case ButType.spyder:
        return Spider(position: position);
      case ButType.grasshopper:
        return Grasshopper(position: position);
      case ButType.scorpion:
        return Scorpion(position: position);
      case ButType.moth:
        return Moth(position: position);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    moveTimer = Timer(
      (gameRandom.nextDouble() * 3) + 1,
      repeat: true,
      callback: () {
        // print('moving to player');
        _moveToPlayer();
      },
    )..start();
  }

  @override
  void onCollision(GameComponent component, bool active) {
    super.onCollision(component, active);
    if (component is Player) {
      // stopMoveAlongThePath();
      _returnToHome();

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

      // runRandomMovement(
      //   dt,
      //   maxDistance: (tileSize * 5).toInt(),
      //   minDistance: (tileSize * 1).toInt(),
      //   runOnlyVisibleInCamera: false,
      //   speed: speed,
      //   // timeKeepStopped: 0,
      // );
    }
    // seeAndMoveToPlayer(
    //   closePlayer: (player) {
    //     print('I am here');
    //   },
    //   radiusVision: 9999,
    // );
  }

  void _moveToPlayer() {
    if (!_goingHom) {
      if (gameRef.player == null || gameRef.player!.isDead) return;
      // final enemies = gameRef.componentsByType<Enemy>();
      moveToPositionAlongThePath(
        gameRef.player!.position.center.toVector2(),
        ignoreCollisions: [
          gameRef.player,
          // ...enemies,
        ],
      );
    }
  }

  void _returnToHome() {
    final home = gameRef.componentsByType<HomeBase>().first;
    _goingHom = true;
    moveToPositionAlongThePath(
      home.position.center.toVector2(),
      ignoreCollisions: [
        home
        // gameRef.player,
        // ...enemies,
      ],
    );
  }

  void homeReached() {
    _goingHom = false;
    if (!isMovingAlongThePath) {
      _moveToPlayer();
    }
  }
}
