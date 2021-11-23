import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game/game_cubit.dart';

class DieWidget extends StatefulWidget {
  const DieWidget({Key? key}) : super(key: key);

  @override
  State<DieWidget> createState() => _DieWidgetState();
}

class _DieWidgetState extends State<DieWidget> {
  int timeLeft = 3;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        timeLeft--;
        if (timeLeft == -1) {
          context.read<GameCubit>().continueGame();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Bummer\n$timeLeft',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }
}
