import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/cubit/game/game_cubit.dart';
import 'src/cubit/glitch/glitch_cubit.dart';
import 'src/ui/main_game.dart';
import 'src/ui/main_menu.dart';
import 'src/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final gfLicense = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], gfLicense);
  });
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GameCubit(),
        ),
        BlocProvider(
          create: (context) => GlitchCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Bugman',
        theme: themeData,
        routes: {
          '/': (context) => const MainMenu(),
          '/game': (context) => const MainGame(),
        },
      ),
    );
  }
}
