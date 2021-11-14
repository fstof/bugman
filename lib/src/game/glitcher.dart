import 'package:bonfire/bonfire.dart';

import '../cubit/glitch/glitch_cubit.dart';
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
}
