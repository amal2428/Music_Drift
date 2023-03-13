import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_drift/db_functions/db_function/db_playlist.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/screens/playlist_screen/playlist_dialogue_add.dart';
import 'package:music_drift/screens/playlist_screen/playlist_page_songs_view.dart';
import 'package:music_drift/screens/playlist_screen/playlist_songs_add_view.dart';
import 'package:music_drift/widgets/get_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomSheetWidget {
  AudioPlayer? playlist;
  void bottomSheet(context, int id, SongModel dataModel) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        context: context,
        backgroundColor: Color.fromRGBO(43, 0, 50, 0.901),
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    DialogList.addPlaylistDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(96, 27, 68, 0.619),
                  ),
                  child: Text('Create New Playlist'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Hive.box<AudioPlayer>('playlistDB').isEmpty
                          ? const Center(
                              child: Text(
                                'No playlists added',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1),
                              ),
                            )
                          : SingleChildScrollView(
                              child: ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<AudioPlayer>('playlistDB')
                                        .listenable(),
                                builder: (BuildContext context,
                                    Box<AudioPlayer> musicList, Widget? child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: musicList.length,
                                    itemBuilder: ((context, index) {
                                      final data =
                                          musicList.values.toList()[index];
                                      playlist = data;
                                      print("$data hsgagau");
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, top: 5),
                                        child: Center(
                                          child: SizedBox(
                                            height: 60,
                                            child: ListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                tileColor: const Color.fromARGB(
                                                    167, 43, 0, 50),
                                                leading: const Icon(
                                                  Icons
                                                      .my_library_music_rounded,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                                title: Text(
                                                  data.name,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onTap: () {
                                                  checkPlaylist(dataModel);

                                                  const snackbar = SnackBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            156, 0, 0, 0),
                                                    duration: Duration(
                                                        milliseconds: 800),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    width: 200,
                                                    content: Text(
                                                      'Added to Playlist',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackbar);
                                                  Navigator.pop(context);

                                                  // data.add(id);
                                                }),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void checkPlaylist(
    SongModel data,
  ) {
    if (!playlist!.isValueIn(data.id)) {
      playlist!.add(data.id);
    }
  }
}

  // void addSongToPlaylist(String playlistName, SongModel song) {
  //   print('fghfdhdfhg');
  //   PlaylistDb.playlistAdd(song as AudioPlayer);
  //   const snackbar = SnackBar(
  //     backgroundColor: Colors.transparent,
  //     duration: Duration(milliseconds: 800),
  //     behavior: SnackBarBehavior.floating,
  //     width: 200,
  //     content: Text(
  //       'Added to Playlist',
  //       style: TextStyle(
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }

