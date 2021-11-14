import 'package:bonfire/bonfire.dart';
import 'package:bonfire/camera/camera_config.dart';
import 'package:bonfire/tiled/tiled_world_map.dart';
import 'package:bugman/src/game/glitcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/game_cubit.dart';
import '../game/bugman_joystick.dart';
import '../game/enemy/enemy_bug.dart';
import '../game/enemy/home_base.dart';
import '../game/hud/hud.dart';
import '../game/pickups/collectable.dart';
import '../game/pickups/gun.dart';
import '../game/pickups/power_up.dart';
import '../game/player/dummy_player.dart';
import '../game/player/spawn.dart';
import '../game/utils.dart';
import 'game_over.dart';

class MainGame extends StatelessWidget {
  const MainGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BonfireTiledWidget(
          joystick: BugmanJoystick(),
          player: DummyPlayer(gameCubit: context.read<GameCubit>()),
          // showCollisionArea: true,
          cameraConfig: CameraConfig(
            moveOnlyMapArea: true,
            // zoom: 4,
          ),
          interface: Hud(context.read<GameCubit>()),
          map: TiledWorldMap(
            // 'maps/map1.json',
            'maps/simple_map.json',
            forceTileSize: const Size(tileSize, tileSize),
            objectsBuilder: {
              'player_spawner': (properties) {
                return Spawner();
              },
              'player': (properties) {
                return Spawn(position: properties.position);
              },
              'enemy': (properties) {
                return EnemyBug.createEnemy(
                  type: ButType.values[properties.others['type']],
                  position: properties.position,
                );
              },
              'gun': (properties) {
                return Gun(position: properties.position);
              },
              'powerup': (properties) {
                return PowerUp(position: properties.position);
              },
              'home': (properties) {
                return HomeBase(position: properties.position, size: properties.size);
              },
              'collect': (properties) {
                return Collectable(position: properties.position);
              },
              'glitcher': (properties) {
                return Glitcher();
              },
            },
          ),
        ),
        BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            if (state is GameOver) {
              return const GameOverWidget();
            }
            return const Offstage();
          },
        ),
      ],
    );
  }
}
