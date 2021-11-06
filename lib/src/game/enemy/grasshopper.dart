import 'package:bonfire/bonfire.dart';

import '../utils.dart';
import 'enemy_bug.dart';

class Grasshopper extends EnemyBug {
  Grasshopper({required Vector2 position})
      : super(
          position: position - Vector2.all(tileSize / 2),
          speed: 100,
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
        "enemy/Crab Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "enemy/Crab Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "enemy/Crab Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "enemy/Crab Sprite Sheet.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 32),
        ),
      );
}
