import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameMenu());

  void startGame() async {
    emit(GameMenu());
    await Future.delayed(const Duration(seconds: 0));
    emit(GameInProgress(score: 0, lives: 3, collectableCount: 0));
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
          collectableCount: (state as LifeLost).collectableCount));
    } else if (state is LevelComplete) {
      emit(GameInProgress(
          reset: false,
          score: (state as LevelComplete).score,
          lives: (state as LevelComplete).lives,
          collectableCount: (state as LevelComplete).collectableCount));
    }
  }

  void playerDied() {
    if (state is GameInProgress) {
      if ((state as GameInProgress).lives == 1) {
        emit(GameOver(
            score: (state as GameInProgress).score,
            collectableCount: (state as GameInProgress).collectableCount));
      } else {
        emit(LifeLost(
            score: (state as GameInProgress).score,
            lives: (state as GameInProgress).lives - 1,
            collectableCount: (state as GameInProgress).collectableCount));
      }
    }
  }

  void addScore(int score) {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score + score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount));
    }
  }

  void incCollecatbleCount() {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount + 1));
    }
  }

  void decCollectableCount() {
    if (state is GameInProgress) {
      if ((state as GameInProgress).collectableCount == 1) {
        emit(LevelComplete(
            score: (state as GameInProgress).score,
            lives: (state as GameInProgress).lives,
            collectableCount: (state as GameInProgress).collectableCount - 1));
      } else {
        emit(GameInProgress(
            score: (state as GameInProgress).score,
            lives: (state as GameInProgress).lives,
            collectableCount: (state as GameInProgress).collectableCount - 1));
      }
    }
  }

  void quit() {
    emit(GameMenu());
  }
}
