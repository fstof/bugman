import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:meta/meta.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  AudioPlayer? _musicPlayer;

  GameCubit() : super(GameMenu());

  void startGame() async {
    emit(GameMenu());
    await Future.delayed(const Duration(seconds: 0));
    emit(GameInProgress(score: 0, lives: 3, collectableCount: 0));
  }

  void retry() async {
    _stopMusic();
    startGame();
  }

  void continueGame() async {
    levelStarted();
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
    _stopMusic();

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

  void setCollectableCount(int count) {
    if (state is GameInProgress) {
      emit(GameInProgress(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: count));
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
      var ct = (state as GameInProgress).collectableCount;
      //log('collectableCount count $ct');
      if ((state as GameInProgress).collectableCount <= 1) {
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
    _stopMusic();
    emit(GameMenu());
  }

  Future<void> levelStarted() async {
    _playIntro();
    await Future.delayed(const Duration(seconds: 4));
    _playMusic();
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
