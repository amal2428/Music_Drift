
// //Recents

// import 'dart:developer';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:music_drift/db_functions/model/audio_player.dart';
// import 'package:music_drift/widgets/mostly_played.dart';
// // import 'package:musica/models/songs.dart';

// // import 'MostPlayed.dart';

// class Recents {
//   static final Box<AudioPlayer> songBox = Hive.box<AudioPlayer>('Songs');
//   static final Box<List> playlistBox = Hive.box<List>('Playlist');

//   static addSongsToRecents({required String songId}) async {
//     final List<AudioPlayer> dbSongs = songBox.values.toList().cast<AudioPlayer>();
//     final List<AudioPlayer> recentSongList =
//         playlistBox.get('Recent')!.toList().cast<AudioPlayer>();

//     final AudioPlayer recentSong =
//         dbSongs.firstWhere((song) => song.songId.toString().contains(songId));

//     /////////////////---------For Most Played----------///////////////////////////

//     int count = recentSong.count;
//     recentSong.count = count + 1;
//     log(recentSong.count.toString());

//     //////////////////////////////////////////////////////////////////////////////
//     /////////////////---------Calling MostPlayed---------/////////////////////////

//     MostPlayed.addSongToPlaylist(songId);

//     //////////////////////////////////////////////////////////////////////////////
//     if (recentSongList.length >= 10) {
//       recentSongList.removeLast();
//     }
//     if (recentSongList.where((song) => song.songId == recentSong.songId).isEmpty) {
//       recentSongList.insert(0, recentSong);
//       await playlistBox.put('Recent', recentSongList);
//     } else {
//       recentSongList.removeWhere((song) => song.songId == recentSong.songId);
//       recentSongList.insert(0, recentSong);
//       await playlistBox.put('Recent', recentSongList);
//     }
//   }
// }
