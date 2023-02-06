import 'package:flutter/material.dart';
import 'package:music_drift/widgets/bg.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Playlist')),
      ),
    );
  }
}
