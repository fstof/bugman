import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bugman/src/cubit/game/game_cubit.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../player/bugman_player.dart';
import '../utils.dart';
import 'grasshopper.dart';
import 'home_base.dart';
import 'moth.dart';
import 'scorpion.dart';
import 'spider.dart';

enum ButType { spyder, scorpion, moth, grasshopper }

abstract class EnemyBug extends SimpleEnemy
    with AutomaticRandomMovement, MoveToPositionAlongThePath, Sensor {
  Timer? moveTimer;
  Timer? homeTimer;
  bool _goingHome = false;
  final double originalSpeed;
  final double homeSpeed;

  EnemyBug({
    required Vector2 position,
    required SimpleDirectionAnimation animation,
    required double speed,
  })  : originalSpeed = speed,
        homeSpeed = speed * 2,
        super(
          position: position - Vector2.all(16),
          height: tileSize,
          width: tileSize,
          speed: speed,
          animation: animation,
        ) {
    setupMoveToPositionAlongThePath(
      showBarriersCalculated: false,
      pathLineColor: const Color(0x00ffffff),
    );

    setupSensorArea(
      Vector2Rect(
        Vector2.zero(),
        Vector2(width, height),
      ),
      intervalCheck: 10,
    );
  }

  factory EnemyBug.createEnemy({required ButType type, required Vector2 position}) {
    switch (type) {
      case ButType.spyder:
        return Spider(position: position);
      case ButType.grasshopper:
        return Grasshopper(position: position);
      case ButType.scorpion:
        return Scorpion(position: position);
      case ButType.moth:
        return Moth(position: position);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final gameState = context.read<GameCubit>().state;
    if (gameState is GameInProgress) {
      speed += (gameState.level - 1) * 5;
    }

    moveTimer = Timer(
      2,
      repeat: true,
      callback: () {
        if (!_goingHome) _moveToPlayer();
      },
    )..start();
  }

  @override
  void onContact(GameComponent component) {
    if (shouldRemove) return;
    if (component is BugmanPlayer) {
      gameRef.enemies().forEach((enemy) {
        enemy.removeFromParent();
      });
      component.die();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    moveTimer?.update(dt);
    homeTimer?.update(dt);
  }

  void _moveToPlayer() {
    if (!_goingHome) {
      if (gameRef.player == null || gameRef.player!.isDead) return;
      moveToPositionAlongThePath(
        gameRef.player!.position.center.toVector2(),
        ignoreCollisions: [gameRef.player],
      );
    }
  }

  void returnToHome() {
    if (_goingHome) return;
    FlameAudio.play('bleeps/kill.mp3');

    _goingHome = true;
    stopMoveAlongThePath();

    homeTimer = Timer(
      0.5,
      callback: () {
        speed = homeSpeed;
        final home = gameRef.componentsByType<HomeBase>().first;
        moveToPositionAlongThePath(
          home.position.center.toVector2(),
          // ignoreCollisions: [gameRef.player],
        );
      },
    )..start();
  }

  void seekPlayer() {
    _goingHome = false;
    speed = originalSpeed;
    if (!isMovingAlongThePath) {
      _moveToPlayer();
    }
  }
}
