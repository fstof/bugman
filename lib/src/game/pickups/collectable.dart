import 'package:bonfire/bonfire.dart';

import '../player/dummy_player.dart';
import '../utils.dart';

class Collectable extends GameDecoration with Sensor {
  Collectable({required Vector2 position})
      : super(
          position: position - Vector2(tileSize, tileSize) / 2,
          height: tileSize,
          width: tileSize,
        ) {
    setupSensorArea(
      Vector2Rect(Vector2(tileSize, tileSize) / 4, Vector2(tileSize, tileSize) / 2),
      intervalCheck: 10,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await _SpriteSheet.sprite;
  }

  @override
  void onContact(GameComponent component) {
    if (component is DummyPlayer) {
      component.addScore(1);
      removeFromParent();
    }
  }
}

class _SpriteSheet {
  static Future<Sprite> get sprite => Sprite.load(
        "objects/collectable.png",
        srcPosition: Vector2.all(0),
        srcSize: Vector2.all(tileSize),
      );
}
