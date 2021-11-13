part of 'game_cubit.dart';

@immutable
abstract class GameState extends Equatable {}

class GameMenu extends GameState {
  @override
  List<Object?> get props => [];
}

class GameInProgress extends GameState {
  final int score;

  GameInProgress({
    required this.score,
  });

  @override
  List<Object?> get props => [score];
}

class GameOver extends GameInProgress {
  GameOver({
    required int score,
  }) : super(score: score);
}
