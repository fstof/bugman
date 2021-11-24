import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../cubit/game/game_cubit.dart';
import '../player/bugman_player.dart';
import '../utils.dart';

class Collectable extends GameDecoration with Sensor {
  final GameCubit gameCubit;
  Collectable({required Vector2 position, required this.gameCubit})
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
    if (component is BugmanPlayer) {
      component.addScore(10);
      gameCubit.decCollectableCount();
      removeFromParent();
      FlameAudio.play('bleeps/collect.wav');
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
