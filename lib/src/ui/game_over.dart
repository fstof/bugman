import '../bloc/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Text('Game Over', style: Theme.of(context).textTheme.headline1),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<GameCubit>().startGame();
                  },
                  child: Text('Retry', style: Theme.of(context).textTheme.headline2),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    context.read<GameCubit>().quit();
                  },
                  child: Text('Quit', style: Theme.of(context).textTheme.headline2),
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
