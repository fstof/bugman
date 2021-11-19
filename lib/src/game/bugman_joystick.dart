import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

class BugmanJoystick extends Joystick {
  final Map<LogicalKeyboardKey, JoystickMoveDirectional> acceptedKyes = {
    LogicalKeyboardKey.arrowUp: JoystickMoveDirectional.MOVE_UP,
    LogicalKeyboardKey.arrowDown: JoystickMoveDirectional.MOVE_DOWN,
    LogicalKeyboardKey.arrowLeft: JoystickMoveDirectional.MOVE_LEFT,
    LogicalKeyboardKey.arrowRight: JoystickMoveDirectional.MOVE_RIGHT,
  };

  BugmanJoystick();

  @override
  void onKeyboard(RawKeyEvent event) {
    //Is this a directional key?
    if (acceptedKyes.containsKey(event.logicalKey)) {
      //Only action key down
      if (event is RawKeyDownEvent) {
        joystickChangeDirectional(JoystickDirectionalEvent(
          directional: acceptedKyes[event.logicalKey]!,
          intensity: 1.0,
          radAngle: 0.0,
        ));
      }
    } else if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      joystickAction(JoystickActionEvent(event: ActionEvent.DOWN));
    }
  }
}
