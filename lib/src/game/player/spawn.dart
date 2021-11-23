import 'package:bonfire/bonfire.dart';

import '../../cubit/game/game_cubit.dart';

class Spawn extends GameComponent {
  Spawn({required Vector2 position}) {
    this.position = Vector2Rect(position, Vector2(1, 1));
  }
}

class Spawner extends GameComponent {
  final GameCubit _gameCubit;

  var playerSpawned = false;
  var pauseGame = false;

  Spawner(this._gameCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    _gameCubit.stream.listen((state) {
      if (state is GameInProgress && state.reset) {
        playerSpawned = false;
        gameRef.resumeEngine();
      }
      if (state is LevelIntro) {
        pauseGame = true;
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
    } else {
      if (pauseGame) {
        if ((gameRef.player?.isVisible ?? false) &&
            gameRef.children.whereType<Enemy>().first.isVisible) {
          pauseGame = false;
          gameRef.pauseEngine();
        }
      }
    }
  }
}
