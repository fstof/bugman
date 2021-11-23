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
  final int level;

  GameInProgress(
      {this.reset = false,
      required this.score,
      required this.lives,
      required this.collectableCount,
      required this.level});

  @override
  List<Object?> get props => [reset, score, lives, collectableCount, level];
}

class LifeLost extends GameInProgress {
  LifeLost({
    required int score,
    required int lives,
    required int collectableCount,
    required int level,
  }) : super(
          score: score,
          lives: lives,
          collectableCount: collectableCount,
          level: level,
        );
  @override
  List<Object?> get props => [1, ...super.props];
}

class LevelIntro extends GameInProgress {
  LevelIntro({
    bool reset = false,
    required int score,
    required int lives,
    required int collectableCount,
    required int level,
  }) : super(
          reset: reset,
          score: score,
          lives: lives,
          collectableCount: collectableCount,
          level: level,
        );
  @override
  List<Object?> get props => [2, ...super.props];
}

class LevelComplete extends GameInProgress {
  LevelComplete({
    required int score,
    required int lives,
    required int collectableCount,
    required int level,
  }) : super(
          score: score,
          lives: lives,
          collectableCount: collectableCount,
          level: level,
        );
  @override
  List<Object?> get props => [3, ...super.props];
}

class GameOver extends GameInProgress {
  GameOver({
    required int score,
    required int collectableCount,
    required int level,
  }) : super(
          score: score,
          lives: 0,
          collectableCount: collectableCount,
          level: level,
        );
  @override
  List<Object?> get props => [4, ...super.props];
}
