import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../../cubit/game/game_cubit.dart';

class Hud extends GameInterface {
  final GameCubit _gameCubit;
  var score = 0;

  Hud(this._gameCubit);

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    _positionScore();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _positionScore();
  }

  void _positionScore() {}

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameCubit.state is GameInProgress) {
      score = (_gameCubit.state as GameInProgress).score;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawScore(canvas);
  }

  void _drawScore(Canvas canvas) {
    final textStyle = Theme.of(context).textTheme.headline2!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    final textSpan = TextSpan(
      text: 'Score: $score',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
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
}
