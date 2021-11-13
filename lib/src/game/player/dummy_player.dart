import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';

import '../../bloc/cubit/game_cubit.dart';
import '../pickups/gun.dart';
import '../utils.dart';

class DummyPlayer extends SimplePlayer with ObjectCollision {
  final GameCubit gameCubit;
  Timer? shootTimer;
  Gun? currentGun;
  JoystickMoveDirectional previousDirectional = JoystickMoveDirectional.IDLE;
  final double collisionTestOffset = 15;

  DummyPlayer({required this.gameCubit})
      : super(
          position: Vector2.zero(),
          width: tileSize,
          height: tileSize,
          animation: SimpleDirectionAnimation(
            idleLeft: _SpriteSheet.idleLeft,
            idleRight: _SpriteSheet.idleRight,
            runRight: _SpriteSheet.runRight,
            runLeft: _SpriteSheet.runLeft,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(width * 0.6, height * 0.6),
            align: Vector2(8, 8),
          )
        ],
      ),
    );
  }

  @override
  void die() {
    super.die();
    gameCubit.gameOver();
    removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    shootTimer?.update(dt);

    if (currentGun != null) {
      currentGun!.position = Vector2Rect(
        position.position,
        currentGun!.position.size,
      );
      if (currentGun!.timeToLive!.finished) {
        currentGun = null;
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    var currentDirectional = event.directional;
    var currentEvent = event;
    if (currentDirectional != previousDirectional &&
        currentDirectional != JoystickMoveDirectional.IDLE) {
      double x = 0;
      double y = 0;
      if (currentDirectional == JoystickMoveDirectional.MOVE_UP) {
        y = collisionTestOffset * -1;
      } else if (currentDirectional == JoystickMoveDirectional.MOVE_DOWN) {
        y = collisionTestOffset;
      } else if (currentDirectional == JoystickMoveDirectional.MOVE_LEFT) {
        x = collisionTestOffset * -1;
      } else if (currentDirectional == JoystickMoveDirectional.MOVE_RIGHT) {
        x = collisionTestOffset;
      }

      if (isCollision(
          displacement:
              Vector2(position.position.x + x, position.position.y + y),
          shouldTriggerSensors: false)) {
        currentEvent =
            JoystickDirectionalEvent(directional: previousDirectional);
      } else {
        previousDirectional = event.directional;
      }
    }
    super.joystickChangeDirectional(currentEvent);
    currentGun?.direction = currentEvent.directional;
  }

  @override
  void onCollision(GameComponent component, bool active) {
    super.onCollision(component, active);

    if (component is TileWithCollision) {
      //stop player when hiting a wall
      joystickChangeDirectional(
          JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE));
    }
  }

  void getGun(Gun gun) {
    currentGun = gun;
    shootTimer = Timer(
      1,
      repeat: true,
      callback: () {
        currentGun?.shoot();
      },
    )..start();
  }

  void removeGun() {
    currentGun = null;
    shootTimer = null;
  }

  void powerup() {
    currentGun?.powerUp = true;
  }

  void addScore(int score) {
    gameCubit.addScore(score);
  }
}

class _SpriteSheet {
  static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "player/player.png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2(0, tileSize * 0),
        ),
      );

  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "player/player.png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2(0, tileSize * 1),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "player/player.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2(0, tileSize * 2),
        ),
      );
  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "player/player.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(tileSize, tileSize),
          texturePosition: Vector2(0, tileSize * 3),
        ),
      );
}
