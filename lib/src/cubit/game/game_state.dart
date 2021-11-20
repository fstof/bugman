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
  final int collectableCount;

  GameInProgress(
      {this.reset = false,
      required this.score,
      required this.lives,
      required this.collectableCount});

  @override
  List<Object?> get props => [reset, score, lives, collectableCount];
}

class LifeLost extends GameInProgress {
  LifeLost({required int score, required int lives, required int collectableCount})
      : super(score: score, lives: lives, collectableCount: collectableCount);
}

class LevelComplete extends GameInProgress {
  LevelComplete({required int score, required int lives, required int collectableCount})
      : super(score: score, lives: lives, collectableCount: collectableCount);
}

class GameOver extends GameInProgress {
  GameOver({required int score, required int collectableCount})
      : super(score: score, lives: 0, collectableCount: collectableCount);
}
