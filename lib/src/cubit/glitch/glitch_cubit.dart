import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../game/utils.dart';

part 'glitch_state.dart';

class GlitchCubit extends Cubit<GlitchState> {
  Timer? _glitchTimer;

  GlitchCubit() : super(Normal());

  void start() {
    var time = gameRandom.nextDouble() * 10 + 10;

    _glitchTimer?.cancel();
    _glitchTimer = Timer(Duration(milliseconds: (time * 1000).toInt()), () {
      emit(Glitching(GlitchType.values[gameRandom.nextInt(GlitchType.values.length)]));

      time = gameRandom.nextDouble() * 2;
      Timer(Duration(milliseconds: (time * 1000).toInt()), () {
        emit(Normal());
        start();
      });
    });
  }

  end() {
    _glitchTimer?.cancel();
    emit(Normal());
  }
}
