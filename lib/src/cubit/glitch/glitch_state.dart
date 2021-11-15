part of 'glitch_cubit.dart';

abstract class GlitchState extends Equatable {
  const GlitchState();

  @override
  List<Object> get props => [];
}

class Normal extends GlitchState {}

enum GlitchType { tiles, camera, color, enemy }

class Glitching extends GlitchState {
  final GlitchType type;

  const Glitching(this.type);

  @override
  List<Object> get props => [type];
}
