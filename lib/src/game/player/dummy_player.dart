import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../pickups/gun.dart';

class DummyPlayer extends SimplePlayer with ObjectCollision {
  Gun? currentGun;

  DummyPlayer()
      : super(
          position: Vector2.zero(),
          width: 32,
          height: 32,
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
            size: Size(width * 0.6, height * 0.6),
            align: Vector2(8, 8),
          )
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (currentGun != null) {
      currentGun!.position = Vector2Rect(
        position.position,
        currentGun!.position.size,
      );
      if (currentGun!.timeToLive!.finished) {
        currentGun = null;
      }
    }
  }

  void getGun(Gun gun) {
    currentGun = gun;
  }

  void removeGun() {
    currentGun = null;
  }
}

class _SpriteSheet {
  static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "player/player_idle.png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "player/player_run.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "player/player_idle.png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "player/player_run.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
}
