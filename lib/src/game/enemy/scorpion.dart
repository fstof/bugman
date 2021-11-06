import 'package:bonfire/bonfire.dart';

import '../utils.dart';
import 'enemy_bug.dart';

class Scorpion extends EnemyBug {
  Scorpion({required Vector2 position})
      : super(
          position: position - Vector2.all(tileSize / 2),
          speed: 60,
          animation: SimpleDirectionAnimation(
            idleLeft: _SpriteSheet.idleLeft,
            idleRight: _SpriteSheet.idleRight,
            runRight: _SpriteSheet.runRight,
            runLeft: _SpriteSheet.runLeft,
          ),
        );
}

class _SpriteSheet {
  static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "enemy/Frog Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "enemy/Frog Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "enemy/Frog Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 64),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "enemy/Frog Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 64),
        ),
      );
}
