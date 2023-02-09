import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/screens/playlist_screen/playlist_dialogue_add.dart';
import 'package:music_drift/screens/playlist_screen/playlist_songs_add.dart';
import 'package:music_drift/widgets/bg.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController newPlaylistController = TextEditingController();

class _PlaylistScreenState extends State<PlaylistScreen> {
  late final AudioPlayer playlist;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<AudioPlayer>('playlistDB').listenable(),
        builder: (context, Box<AudioPlayer> musicList, Widget? child) {
          return Container(
            decoration: BoxDecoration(gradient: linearGradient()),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                ),
                title: const Text(
                  'Playlist',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      letterSpacing: 1.5),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      DialogList.addPlaylistDialog(context);
                    },
                    icon: const Icon(
                      Icons.playlist_add_rounded,
                    ),
                    iconSize: 30,
                  )
                ],
                elevation: 1,
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // OptionWidget(
                  //   infoText: 'Add playlist',
                  //   infoIcon: Icons.playlist_add,
                  //   infoAction: () {
                  //     DialogList.addPlaylistDialog(context);
                  //   },
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Hive.box<AudioPlayer>('playlistDB').isEmpty
                      ? const Center(
                          child: Text(
                            'No playlists added',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SingleChildScrollView(
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box<AudioPlayer>('playlistDB')
                                .listenable(),
                            builder: (BuildContext context,
                                Box<AudioPlayer> musicList, Widget? child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: musicList.length,
                                itemBuilder: ((context, index) {
                                  final data = musicList.values.toList()[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 15),
                                    child: Center(
                                      child: SizedBox(
                                        height: 60,
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          tileColor: const Color.fromRGBO(
                                              43, 0, 50, 1),
                                          leading: const Icon(
                                            Icons.my_library_music_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            data.name,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete_sweep_rounded,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              43, 0, 50, 1),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      title: const Text(
                                                        'Delete Playlist',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontSize: 15),
                                                      ),
                                                      content: const Text(
                                                        'Are you sure you want to delete this playlist?',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      227,
                                                                      66,
                                                                      66),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            musicList.deleteAt(
                                                                index);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return PlaylistAddSongs(
                                                  playlist: data,
                                                  folderindex: index,
                                                );
                                              },
                                            ));
                                          },
                                        ),
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
          );
        });
  }
}
