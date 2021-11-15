import 'package:bonfire/bonfire.dart';

import '../cubit/glitch/glitch_cubit.dart';
import 'enemy/enemy_bug.dart';
import 'enemy/glitch_spawn.dart';
import 'utils.dart';

class Glitcher extends GameComponent {
  final GlitchCubit _glitchCubit;

  Glitcher(this._glitchCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    // startGlitching();
    _glitchCubit.stream.listen((state) {
      if (state is Glitching) {
        switch (state.type) {
          case GlitchType.camera:
            _cameraGlitch();
            break;
          case GlitchType.tiles:
            _tileGlitch();
            break;
          case GlitchType.enemy:
            _enemyGlitch();
            break;
          default:
            break;
        }
      } else {
        _resetGlitches();
      }
    });
  }

  void _resetGlitches() {
    gameRef.camera.config.angle = 0;
    for (var element in gameRef.map.childrenTiles) {
      if (element.isObjectCollision()) {
        element.angle = 0;
      }
    }
  }

  void _cameraGlitch() {
    gameRef.camera.config.angle = dToR(gameRandom.nextInt(360).toDouble());
  }

  void _tileGlitch() {
    // remove 5 consecutive tiles
    var randomTile = gameRandom.nextInt(gameRef.map.childrenTiles.length - 5);
    for (var i = 0; i < 5; i++) {
      gameRef.map.childrenTiles[randomTile + i].removeFromParent();
    }
    // rotate tiles
    for (var element in gameRef.map.childrenTiles) {
      if (element.isObjectCollision()) {
        element.angle = dToR(1);
      }
    }
  }

  void _enemyGlitch() {
    var enemies = gameRef.children.whereType<EnemyBug>();
    var spawns = gameRef.children.whereType<GlitchSpawn>();
    var randomSpawn = spawns.elementAt(gameRandom.nextInt(spawns.length));
    var randomEnemy = enemies.elementAt(gameRandom.nextInt(enemies.length));
    randomEnemy.position = randomEnemy.position.copyWith(
      position: randomSpawn.position.position - randomEnemy.position.size / 2,
    );
  }
}
