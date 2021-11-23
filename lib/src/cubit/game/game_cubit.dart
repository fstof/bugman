import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  AudioPlayer? _musicPlayer;

  GameCubit() : super(GameMenu());

  void levelStarted({int level = 1}) async {
    _stopMusic();
    _playIntro();
    if (level == 1) {
      emit(LevelIntro(score: 0, lives: 3, collectableCount: 20, level: 1));
      await Future.delayed(const Duration(seconds: 4));
      emit(GameInProgress(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
    } else {
      emit(LevelIntro(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: 20,
        level: (state as GameInProgress).level,
      ));
      await Future.delayed(const Duration(seconds: 4));
      emit(GameInProgress(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
    }
    _playMusic();
  }

  void retry() async {
    _stopMusic();
    emit(GameMenu());
  }

  void continueGame() async {
    _stopMusic();
    _playIntro();
    if (state is LifeLost) {
      emit(LevelIntro(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
      await Future.delayed(const Duration(seconds: 4));

      emit(GameInProgress(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
    }
    _playMusic();
  }

  void playerDied() {
    _stopMusic();

    if (state is GameInProgress) {
      if ((state as GameInProgress).lives == 1) {
        emit(GameOver(
          score: (state as GameInProgress).score,
          collectableCount: (state as GameInProgress).collectableCount,
          level: (state as GameInProgress).level,
        ));
      } else {
        emit(LifeLost(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives - 1,
          collectableCount: (state as GameInProgress).collectableCount,
          level: (state as GameInProgress).level,
        ));
      }
    }
  }

  void addScore(int score) {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score + score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount,
          level: (state as GameInProgress).level));
    }
  }

  void setCollectableCount(int count) {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: count,
          level: (state as GameInProgress).level));
    }
  }

  void incCollecatbleCount() {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount + 1,
          level: (state as GameInProgress).level));
    }
  }

  void decCollectableCount() {
    if (state is GameInProgress) {
      var ct = (state as GameInProgress).collectableCount;
      // print('collectableCount count $ct');
      if ((state as GameInProgress).collectableCount <= 1) {
        emit(LevelComplete(
            score: (state as GameInProgress).score,
            lives: (state as GameInProgress).lives,
            collectableCount: (state as GameInProgress).collectableCount - 1,
            level: (state as GameInProgress).level + 1));
      } else {
        emit(GameInProgress(
            score: (state as GameInProgress).score,
            lives: (state as GameInProgress).lives,
            collectableCount: (state as GameInProgress).collectableCount - 1,
            level: (state as GameInProgress).level));
      }
    }
  }

  void quit() {
    _stopMusic();
    emit(GameMenu());
  }

  Future<void> _playIntro() async {
    FlameAudio.playLongAudio('music/level_start.wav');
  }

  Future<void> _playMusic() async {
    if (_musicPlayer != null) {
      _musicPlayer?.resume();
    } else {
      _musicPlayer = await FlameAudio.loopLongAudio('music/level_play.wav');
    }
  }

  void _stopMusic() {
    _musicPlayer?.stop();
  }
}
