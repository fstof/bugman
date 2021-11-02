import 'package:bonfire/bonfire.dart';

class DummyPlayer extends SimplePlayer {
  DummyPlayer()
      : super(
          position: Vector2.zero(),
          animation: SimpleDirectionAnimation(
            idleLeft: PlayerSpriteSheet.idleLeft,
            idleRight: PlayerSpriteSheet.idleRight,
            runRight: PlayerSpriteSheet.runRight,
            runLeft: PlayerSpriteSheet.runLeft,
          ),
        );
}

class PlayerSpriteSheet {
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
