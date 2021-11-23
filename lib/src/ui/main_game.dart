import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/camera/camera_config.dart';
import 'package:bonfire/tiled/tiled_world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game/game_cubit.dart';
import '../cubit/glitch/glitch_cubit.dart';
import '../game/bugman_joystick.dart';
import '../game/enemy/enemy_spawn.dart';
import '../game/enemy/glitch_spawn.dart';
import '../game/enemy/home_base.dart';
import '../game/glitcher.dart';
import '../game/hud/hud.dart';
import '../game/pickups/collectable.dart';
import '../game/pickups/gun.dart';
import '../game/pickups/power_up.dart';
import '../game/player/bugman_player.dart';
import '../game/player/spawn.dart';
import '../game/utils.dart';
import 'die_widget.dart';
import 'game_over_widget.dart';

class MainGame extends StatelessWidget {
  const MainGame({Key? key}) : super(key: key);

  static const invertColorMatrix = <double>[
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BonfireTiledWidget(
          joystick: BugmanJoystick(),
          player: BugmanPlayer(gameCubit: context.read<GameCubit>()),
          // showCollisionArea: true,
          cameraConfig: CameraConfig(
            moveOnlyMapArea: true,
            // zoom: 4,
          ),
          onReady: (game) {
            context.read<GlitchCubit>().start();
            context.read<GameCubit>().levelStarted();
            //var ct = game.children.whereType<Collectable>().length;
            //context.read<GameCubit>().setCollectableCount(ct);
          },
          interface: Hud(context.read<GameCubit>()),
          map: TiledWorldMap(
            'maps/map.json',
            forceTileSize: const Size(tileSize, tileSize),
            objectsBuilder: {
              'player_spawner': (properties) {
                return Spawner(context.read<GameCubit>());
              },
              'player': (properties) {
                return Spawn(position: properties.position);
              },
              'enemy_spawner': (properties) {
                return EnemySpawner(context.read<GameCubit>());
              },
              'enemy': (properties) {
                return EnemySpawn(position: properties.position);
              },
              'gun': (properties) {
                return Gun(position: properties.position);
              },
              'powerup': (properties) {
                return PowerUp(position: properties.position);
              },
              'home': (properties) {
                return HomeBase(
                  position: properties.position,
                  size: properties.size,
                );
              },
              'collect': (properties) {
                return Collectable(
                  position: properties.position,
                  gameCubit: context.read<GameCubit>(),
                );
              },
              'glitcher': (properties) {
                return Glitcher(context.read<GlitchCubit>());
              },
              'glitch_spawn': (properties) {
                return GlitchSpawn(properties.position, properties.size);
              },
            },
          ),
        ),
        BlocBuilder<GlitchCubit, GlitchState>(
          builder: (context, state) {
            if (state is Glitching && state.type == GlitchType.color) {
              return Positioned.fill(
                child: BackdropFilter(
                  // filter: const ColorFilter.matrix(invertColorMatrix),
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.black.withOpacity(0.0)),
                ),
              );
            } else {
              return const Offstage();
            }
          },
        ),
        BlocConsumer<GameCubit, GameState>(
          listener: (context, state) {
            if (state is LevelComplete) {
              context.read<GameCubit>().continueGame();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => const MainGame()));
            }
          },
          builder: (context, state) {
            if (state is GameOver) {
              return const GameOverWidget();
            }
            if (state is LifeLost) {
              return const DieWidget();
            }
            return const Offstage();
          },
        ),
      ],
    );
  }
}
