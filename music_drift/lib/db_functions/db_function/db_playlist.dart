import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';


class PlaylistDb {
static ValueNotifier<List<AudioPlayer>> playlistNotifier = ValueNotifier([]);

  static Future<void> playlistAdd(AudioPlayer value) async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playlistdb.add(value);

    playlistNotifier.value.add(value);
    getAllPlaylist();
  }

  static getAllPlaylist() async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistdb.values);
    playlistNotifier.notifyListeners();
  }

  static playlistDelete(int index) async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playlistdb.deleteAt(index);
    getAllPlaylist();
  }

  bool playlistnameCheck(name) {
    bool result = false;

    for (int i = 0; i < playlistNotifier.value.length; i++) {
      if (playlistNotifier.value[i].name == name) {
        result = true;
      }
      if (result == true) {
        break;
      }
    }
    return result;
  }

  
}
