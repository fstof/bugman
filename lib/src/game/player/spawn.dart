import 'package:bonfire/bonfire.dart';

class Spawn extends GameComponent {
  Spawn({required Vector2 position}) {
    this.position = Vector2Rect(position, Vector2(1, 1));
  }
}

class Spawner extends GameComponent {
  var playerSpawned = false;

  @override
  void update(double dt) {
    super.update(dt);

    if (!playerSpawned) {
      final spawnPoint = gameRef.children.whereType<Spawn>().toList();
      final player = gameRef.player;

      if (spawnPoint.isNotEmpty && player != null) {
        player.vectorPosition =
            spawnPoint.first.vectorPosition - player.position.size * 0.5;
        playerSpawned = true;
        removeFromParent();
      }
    }
  }
}
