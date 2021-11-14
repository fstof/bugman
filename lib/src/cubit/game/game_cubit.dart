import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameMenu());

  void startGame() async {
    emit(GameMenu());
    await Future.delayed(const Duration(seconds: 0));
    emit(GameInProgress(score: 0));
  }

  void gameOver() {
    if (state is GameInProgress) {
      emit(GameOver(score: (state as GameInProgress).score));
    }
  }

  void addScore(int score) {
    if (state is GameInProgress) {
      emit(GameInProgress(score: (state as GameInProgress).score + score));
    }
  }

  void quit() {
    emit(GameMenu());
  }
}
