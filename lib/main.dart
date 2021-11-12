import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/cubit/game_cubit.dart';
import 'src/ui/main_game.dart';
import 'src/ui/main_menu.dart';
import 'src/ui/theme.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final gfLicense = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], gfLicense);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool inGame = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: MaterialApp(
        title: 'Bugman',
        theme: themeData,
        home: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            if (state is GameInProgress || state is GameOver) {
              return const MainGame();
            } else {
              return MainMenu(onPlay: () {
                context.read<GameCubit>().startGame();
              });
            }
          },
        ),
      ),
    );
  }
}
