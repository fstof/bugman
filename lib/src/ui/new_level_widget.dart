import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game/game_cubit.dart';

class NewLevelWidget extends StatefulWidget {
  const NewLevelWidget({Key? key}) : super(key: key);

  @override
  State<NewLevelWidget> createState() => _NewLevelWidgetState();
}

class _NewLevelWidgetState extends State<NewLevelWidget> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      context.read<GameCubit>().continueGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is GameInProgress) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Text(
                'Level\n${state.level}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          );
        }
        return const Offstage();
      },
    );
  }
}
