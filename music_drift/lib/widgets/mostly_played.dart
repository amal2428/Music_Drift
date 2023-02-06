// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:music_player/db_functions/model/audio_player.dart';
// class MostPlayed {
//   static Box<AudioPlayer> songBox = Hive.box<AudioPlayer>('Songs');

//   static Box<List> playlistBox = Hive.box<List>('Playlist');

//   static addSongToPlaylist(String songId) async {
//     final mostPlayedlist =
//         playlistBox.get('Most Played')!.toList().cast<AudioPlayer>();

//     final dbSongs = songBox.values.toList().cast<AudioPlayer>();

//     final mostPlayedSong =
//         dbSongs.firstWhere((song) => song.songId.contains(songId));
//     if (mostPlayedlist.length >= 10) {
//       mostPlayedlist.removeLast();
//     }

//     if (mostPlayedSong.count >= 5) {
//       if (mostPlayedlist
//           .where((song) => song.songId == mostPlayedSong.songId)
//           .isEmpty) {
//         mostPlayedlist.insert(0, mostPlayedSong);
//         await playlistBox.put('Most Played', mostPlayedlist);
//       } else {
//         mostPlayedlist.removeWhere((song) => song.songId == mostPlayedSong.soid);
//         mostPlayedlist.insert(0, mostPlayedSong);
//         await playlistBox.put('Most Played', mostPlayedlist);
//       }
//     }
//   }
// }
