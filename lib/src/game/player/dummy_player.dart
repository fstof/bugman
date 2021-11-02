import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class DummyPlayer extends SimplePlayer with ObjectCollision {
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
}

class _SpriteSheet {
  static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "player/Adventurer Sprite Sheet left v1.3.png",
        SpriteAnimationData.sequenced(
          amount: 13,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "player/Adventurer Sprite Sheet left v1.3.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );

  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "player/Adventurer Sprite Sheet v1.3.png",
        SpriteAnimationData.sequenced(
          amount: 13,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "player/Adventurer Sprite Sheet v1.3.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
}
