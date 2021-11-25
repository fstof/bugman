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
    _playIntro();
    if (level == 1) {
      emit(LevelIntro(
        reset: true,
        score: 0,
        lives: 3,
        //collectableCount: 20, // test_map.json
        collectableCount: 290, // map.json
        level: 1,
      ));
    } else {
      emit(LevelIntro(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        //collectableCount: 20, // test_map.json
        collectableCount: 290, // map.json
        level: (state as GameInProgress).level,
      ));
    }
  }

  void retry() async {
    emit(GameMenu());
  }

  void continueGame() async {
    if (state is LifeLost) {
      _playIntro();
      emit(LevelIntro(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
      await Future.delayed(const Duration(seconds: 4));
    } else if (state is LevelIntro) {
      _playMusic();
      emit(GameInProgress(
        reset: true,
        score: (state as GameInProgress).score,
        lives: (state as GameInProgress).lives,
        collectableCount: (state as GameInProgress).collectableCount,
        level: (state as GameInProgress).level,
      ));
    }
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

  void decCollectableCount() {
    if (state is GameInProgress) {
      if ((state as GameInProgress).collectableCount <= 1) {
        _stopMusic();
        emit(LevelComplete(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount - 1,
          level: (state as GameInProgress).level + 1,
        ));
      } else {
        emit(GameInProgress(
          score: (state as GameInProgress).score,
          lives: (state as GameInProgress).lives,
          collectableCount: (state as GameInProgress).collectableCount - 1,
          level: (state as GameInProgress).level,
        ));
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
