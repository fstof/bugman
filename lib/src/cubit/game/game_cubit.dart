import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameMenu());

  void startGame() async {
    emit(GameMenu());
    await Future.delayed(const Duration(seconds: 0));
    emit(GameInProgress(score: 0, lives: 3));
  }

  void retry() async {
    startGame();
  }

  void continueGame() async {
    if (state is LifeLost) {
      emit(GameInProgress(
        reset: true,
        score: (state as LifeLost).score,
        lives: (state as LifeLost).lives,
      ));
    }
  }

  void playerDied() {
    if (state is GameInProgress) {
      if ((state as GameInProgress).lives == 1) {
        emit(GameOver(score: (state as GameInProgress).score));
      } else {
        emit(LifeLost(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives - 1,
        ));
      }
    }
  }

  void addScore(int score) {
    if (state is GameInProgress) {
      emit(GameInProgress(
        score: (state as GameInProgress).score + score,
        lives: (state as GameInProgress).lives,
      ));
    }
  }

  void quit() {
    emit(GameMenu());
  }
}
