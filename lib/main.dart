import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'src/game/enemy/enemy_bug.dart';
import 'src/game/player/dummy_player.dart';
import 'src/game/player/spawn.dart';
import 'src/game/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BonfireTiledWidget(
      joystick: Joystick(
        directional: isMobile() ? JoystickDirectional() : null,
        keyboardConfig: KeyboardConfig(
          keyboardDirectionalType: KeyboardDirectionalType.arrows,
          enable: true,
        ),
      ),
      player: DummyPlayer(),
      showCollisionArea: true,
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        // zoom: 4,
      ),
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
            return EnemyBug(position: properties.position);
          },
        },
      ),
    );
  }
}
