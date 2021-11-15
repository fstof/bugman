part of 'game_cubit.dart';

@immutable
abstract class GameState extends Equatable {}

class GameMenu extends GameState {
  @override
  List<Object?> get props => [];
}

class GameInProgress extends GameState {
  final bool reset;
  final int score;
  final int lives;

  GameInProgress({
    this.reset = false,
    required this.score,
    required this.lives,
  });

  @override
  List<Object?> get props => [reset, score, lives];
}

class LifeLost extends GameInProgress {
  LifeLost({
    required int score,
    required int lives,
  }) : super(score: score, lives: lives);
}

class GameOver extends GameInProgress {
  GameOver({
    required int score,
  }) : super(score: score, lives: 0);
}
