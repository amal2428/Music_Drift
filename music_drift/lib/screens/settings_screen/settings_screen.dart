import 'package:flutter/material.dart';
import 'package:music_drift/widgets/bg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body:
              AppBar(
            title: Text(
              'Settings',
              style: TextStyle(letterSpacing: 1),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          )),
    );
  }
}
