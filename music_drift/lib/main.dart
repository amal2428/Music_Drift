import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/screens/splash_screen/splash_screen.dart';



Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioPlayerAdapter().typeId)) {
    Hive.registerAdapter(AudioPlayerAdapter());
  }
  await Hive.openBox<int>('favouriteDB');
  await Hive.openBox<AudioPlayer>('playlistDB');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    const MusicApp(),
  );
}

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: const SplashScreen(),
    );
  }
}
