import 'package:bonfire/bonfire.dart';
import 'package:bugman/src/cubit/game/game_cubit.dart';
import 'package:bugman/src/game/player/bugman_player.dart';

class Spawn extends GameComponent {
  Spawn({required Vector2 position}) {
    this.position = Vector2Rect(position, Vector2(1, 1));
  }
}

class Spawner extends GameComponent {
  final GameCubit _gameCubit;

  var playerSpawned = false;

  Spawner(this._gameCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    _gameCubit.stream.listen((state) {
      if (state is GameInProgress && state.reset) {
        playerSpawned = false;
        gameRef.resumeEngine();
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!playerSpawned) {
      final spawnPoint = gameRef.children.whereType<Spawn>().toList();
      final player = gameRef.player;

      if (spawnPoint.isNotEmpty && player != null) {
        player.vectorPosition = spawnPoint.first.vectorPosition - player.position.size * 0.5;
        playerSpawned = true;
      }
    }
  }
}
