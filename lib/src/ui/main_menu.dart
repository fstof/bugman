import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onPlay;
  const MainMenu({Key? key, required this.onPlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/cover.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bugman', style: Theme.of(context).textTheme.headline1),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: onPlay,
                      child: Text('Play', style: Theme.of(context).textTheme.headline2),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        showAboutDialog(context: context, applicationName: 'Bugman', children: [
                          const Text('GitHub Game-Off 2021'),
                        ]);
                      },
                      child: Text('About', style: Theme.of(context).textTheme.headline2),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
