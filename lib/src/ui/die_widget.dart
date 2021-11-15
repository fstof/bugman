import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game/game_cubit.dart';

class DieWidget extends StatelessWidget {
  const DieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Bummer', style: Theme.of(context).textTheme.headline1),
            OutlinedButton(
              onPressed: () {
                context.read<GameCubit>().continueGame();
              },
              child: Text('GO!', style: Theme.of(context).textTheme.headline2),
            ),
          ],
        ),
      ),
    );
  }
}
