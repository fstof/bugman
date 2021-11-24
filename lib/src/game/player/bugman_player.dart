import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';

import '../../cubit/game/game_cubit.dart';
import '../pickups/gun.dart';
import '../utils.dart';

class BugmanPlayer extends SimplePlayer with ObjectCollision {
  final GameCubit gameCubit;
  Gun? currentGun;
  JoystickMoveDirectional previousDirectional = JoystickMoveDirectional.IDLE;
  JoystickMoveDirectional nextDirectional = JoystickMoveDirectional.IDLE;
  final double collisionTestOffset = 15;

  BugmanPlayer({required this.gameCubit})
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
    gameCubit.playerDied();
    gameRef.enemies().forEach((enemy) {
      enemy.removeFromParent();
    });
    currentGun?.removeFromParent();
    currentGun = null;
    previousDirectional = JoystickMoveDirectional.IDLE;
    nextDirectional = JoystickMoveDirectional.IDLE;
    joystickChangeDirectional(JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE));

    FlameAudio.play('bleeps/die.wav');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (currentGun != null) {
      currentGun!.position = Vector2Rect(
        position.position,
        currentGun!.position.size,
      );
      if (currentGun!.empty) {
        currentGun = null;
      }
    }

    if (nextDirectional != JoystickMoveDirectional.IDLE) {
      var newEvent = JoystickDirectionalEvent(directional: nextDirectional);
      joystickChangeDirectional(newEvent);
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    super.joystickAction(event);
    currentGun?.shoot();
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    var currentDirectional = event.directional;
    var currentEvent = event;
    if (currentDirectional != previousDirectional &&
        currentDirectional != JoystickMoveDirectional.IDLE) {
      if (canGo(currentDirectional)) {
        previousDirectional = event.directional;
        nextDirectional = JoystickMoveDirectional.IDLE;
      } else {
        currentEvent = JoystickDirectionalEvent(directional: previousDirectional);
        nextDirectional = currentDirectional;
      }
    }
    super.joystickChangeDirectional(currentEvent);
    currentGun?.direction = currentEvent.directional;
  }

  bool canGo(JoystickMoveDirectional direction) {
    double x = 0;
    double y = 0;
    if (direction == JoystickMoveDirectional.MOVE_UP) {
      y = collisionTestOffset * -1;
    } else if (direction == JoystickMoveDirectional.MOVE_DOWN) {
      y = collisionTestOffset;
    } else if (direction == JoystickMoveDirectional.MOVE_LEFT) {
      x = collisionTestOffset * -1;
    } else if (direction == JoystickMoveDirectional.MOVE_RIGHT) {
      x = collisionTestOffset;
    }

    return !isCollision(
        displacement: Vector2(position.position.x + x, position.position.y + y),
        shouldTriggerSensors: false);
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
    FlameAudio.play('bleeps/get-can.wav');
    currentGun = gun;
  }

  void removeGun() {
    currentGun = null;
  }

  void powerup() {
    currentGun?.powerUp = true;
    FlameAudio.play('bleeps/power-up.wav');
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
