import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../../cubit/game/game_cubit.dart';

class Hud extends GameInterface {
  final GameCubit _gameCubit;
  GameInProgress? gameState;

  Hud(this._gameCubit);

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
  }

  void _drawScore(Canvas canvas) {
    final textStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    final textSpan = TextSpan(
      text: 'Score: ${gameState?.score}',
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
}
