import 'package:bonfire/bonfire.dart';

import '../../cubit/game/game_cubit.dart';
import 'enemy_bug.dart';

class EnemySpawn extends GameComponent {
  EnemySpawn({required Vector2 position}) {
    this.position = Vector2Rect(position, Vector2(1, 1));
  }
}

class EnemySpawner extends GameComponent {
  final GameCubit _gameCubit;

  var enemiesSpawned = false;

  EnemySpawner(this._gameCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    _gameCubit.stream.listen((state) {
      if (state is GameInProgress && state.reset) {
        enemiesSpawned = false;
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!enemiesSpawned) {
      final spawnPoints = gameRef.children.whereType<EnemySpawn>();
      gameRef.children.whereType<EnemyBug>().forEach((element) {
        element.removeFromParent();
      });
      for (var k = 0; k < ButType.values.length; k++) {
        gameRef.add(EnemyBug.createEnemy(
          type: ButType.values[k],
          position: spawnPoints.elementAt(k).position.position,
        ));
      }
    }
    enemiesSpawned = true;
  }
}
