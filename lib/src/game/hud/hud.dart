import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import '../player/bugman_player.dart';
import 'package:flutter/material.dart';

import '../../cubit/game/game_cubit.dart';
import '../utils.dart';

class Hud extends GameInterface {
  final GameCubit _gameCubit;
  GameInProgress? gameState;
  Sprite? sprayCan;
  Sprite? powerUp;

  Hud(this._gameCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprayCan = await _SpriteSheet.sprayCan;
    powerUp = await _SpriteSheet.powerup;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    position = Vector2Rect(Vector2.zero(), gameSize);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameCubit.state is GameInProgress) {
      gameState = (_gameCubit.state as GameInProgress);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawScore(canvas);
    _drawLives(canvas);
    _drawLevel(canvas);
    _drawAmmo(canvas);
    _drawPowerup(canvas);
  }

  void _drawScore(Canvas canvas) {
    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    final textSpan = TextSpan(
      text: 'Score: ${gameState?.score ?? 0}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 100,
      maxWidth: 1000,
    );
    textPainter.paint(
      canvas,
      Offset(position.left + 16, position.top),
    );
  }

  void _drawLives(Canvas canvas) {
    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    var text = '';
    for (var i = 0; i < (gameState?.lives ?? 0); i++) {
      text += '❤️';
    }
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 100,
      maxWidth: 1000,
    );
    textPainter.paint(
      canvas,
      Offset(position.left + 16, position.bottom - 50),
    );
  }

  void _drawAmmo(Canvas canvas) {
    sprayCan?.renderRect(
        canvas, Rect.fromLTWH(position.right - 85, position.bottom - 43, tileSize, tileSize));

    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    var text = '= ${(gameRef.player as BugmanPlayer).currentGun?.ammo ?? 0}';
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 100,
      maxWidth: 1000,
    );
    textPainter.paint(
      canvas,
      Offset(position.right - 55, position.bottom - 50),
    );
  }

  void _drawPowerup(Canvas canvas) {
    powerUp?.renderRect(
        canvas, Rect.fromLTWH(position.right - 200, position.bottom - 43, tileSize, tileSize));

    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    var text = '= ${(gameRef.player as BugmanPlayer).currentGun?.powerUpTimeLeft ?? 0}';
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 100,
      maxWidth: 1000,
    );
    textPainter.paint(
      canvas,
      Offset(position.right - 165, position.bottom - 50),
    );
  }

  void _drawLevel(Canvas canvas) {
    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    final textSpan = TextSpan(
      text: 'Level: ${gameState?.level ?? 1}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 100,
      maxWidth: 1000,
    );
    textPainter.paint(
      canvas,
      Offset(position.right - 200, position.top),
    );
  }
}

class _SpriteSheet {
  static Future<Sprite> get sprayCan => Sprite.load(
        "objects/spray-can.png",
        srcPosition: Vector2.zero(),
        srcSize: Vector2(tileSize, tileSize),
      );
  static Future<Sprite> get powerup => Sprite.load(
        "objects/power-up.png",
        srcPosition: Vector2.zero(),
        srcSize: Vector2(tileSize, tileSize),
      );
}
