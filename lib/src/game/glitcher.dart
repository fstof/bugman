import 'package:bonfire/bonfire.dart';

import 'utils.dart';

class Glitcher extends GameComponent {
  Timer? _cameraTimer;
  Timer? _cameraResetTimer;
  Timer? _tilesTimer;
  Timer? _tilesResetTimer;

  bool _isGlitching = true;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    startGlitching();
  }

  @override
  void update(double dt) {
    if (!_isGlitching) return;

    super.update(dt);
    _cameraTimer?.update(dt);
    _cameraResetTimer?.update(dt);
    _tilesTimer?.update(dt);
    _tilesResetTimer?.update(dt);
  }

  void _newCameraTimer() {
    var time = gameRandom.nextDouble() * 10 + 10;
    _cameraTimer = Timer(time.toDouble(), callback: () {
      gameRef.camera.config.angle = dToR(gameRandom.nextInt(360).toDouble());

      time = gameRandom.nextDouble() * 2;
      _cameraResetTimer = Timer(time, callback: () {
        gameRef.camera.config.angle = 0;
        _newCameraTimer();
      })
        ..start();
    })
      ..start();
  }

  void _newTilesTimer() {
    var time = gameRandom.nextDouble() * 10 + 10;
    _tilesTimer = Timer(time.toDouble(), callback: () {
      for (var element in gameRef.map.childrenTiles) {
        if (element.isObjectCollision()) {
          element.angle = dToR(1);
        }
      }

      time = gameRandom.nextDouble() * 2;
      _tilesResetTimer = Timer(time, callback: () {
        for (var element in gameRef.map.childrenTiles) {
          if (element.isObjectCollision()) {
            element.angle = 0;
          }
        }
        _newTilesTimer();
      })
        ..start();
    })
      ..start();
  }

  void endGlitching() {
    _isGlitching = false;
    _cameraTimer?.stop();
    _tilesTimer?.stop();
  }

  void startGlitching() {
    _isGlitching = true;
    _newCameraTimer();
    _newTilesTimer();
  }
}
