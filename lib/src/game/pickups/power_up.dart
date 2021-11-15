import 'package:bonfire/bonfire.dart';

import '../player/bugman_player.dart';
import '../utils.dart';

class PowerUp extends GameDecoration with Sensor {
  PowerUp({required Vector2 position})
      : super(
          position: position - Vector2(tileSize, tileSize) / 2,
          width: tileSize,
          height: tileSize,
        ) {
    setupSensorArea(Vector2Rect(Vector2.zero(), Vector2.all(tileSize)), intervalCheck: 10);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = await _SpriteSheet.sprite;
  }

  @override
  void onContact(GameComponent component) {
    if (component is BugmanPlayer) {
      if (component.currentGun != null) {
        component.addScore(100);
        component.powerup();
      }
      removeFromParent();
    }
  }
}

class _SpriteSheet {
  static Future<SpriteAnimation> get sprite => SpriteAnimation.load(
        "objects/power-up.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2.zero(),
        ),
      );
}
