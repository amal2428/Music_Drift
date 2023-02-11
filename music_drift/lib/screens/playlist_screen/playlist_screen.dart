import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/screens/playlist_screen/playlist_dialogue_add.dart';
import 'package:music_drift/screens/playlist_screen/playlist_songs_add_view.dart';
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
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                  color: Colors.white,
                ),
                title: const Text(
                  'Playlist',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
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
                elevation: 0,
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
                    height: 15,
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
                                          tileColor:
                                              Color.fromARGB(167, 43, 0, 50),
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
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
//content to change
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    43,
                                                                    0,
                                                                    50,
                                                                    1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            title: Text(
                                                              'Edit playlist name',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                            content: Form(
                                                              key: _formKey,
                                                              child:
                                                                  TextFormField(
                                                                autofocus: true,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                controller:
                                                                    newPlaylistController,
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                decoration:
                                                                    InputDecoration(
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.white)),
                                                                  label:
                                                                      const Text(
                                                                    'Playlist Name',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // validator: (value) {
                                                                //   bool check =
                                                                //       PlaylistDb()
                                                                //           .playlistnameCheck(
                                                                //               value);
                                                                //   if (value == '') {
                                                                //     return 'Enter playlist name';
                                                                //   } else if (check) {
                                                                //     return '$value already exist';
                                                                //   } else {
                                                                //     return null;
                                                                //   }
                                                                // },
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: (() {
                                                                  return Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                                child: Text(
                                                                  'cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              TextButton.icon(
                                                                  onPressed:
                                                                      () {
                                                                    // if (_formKey
                                                                    //     .currentState!
                                                                    //     .validate()) {
                                                                    //   final name =
                                                                    //       newPlaylistController
                                                                    //           .text
                                                                    //           .trimLeft();
                                                                    //   if (name
                                                                    //       .isEmpty) {
                                                                    //     return;
                                                                    //   } else {
                                                                    //     final music =
                                                                    //         AudioPlayer(
                                                                    //             name:
                                                                    //                 name,
                                                                    //             songId: []);

                                                                    //     PlaylistDb
                                                                    //         .playlistAdd(
                                                                    //             music);
                                                                    //     newPlaylistController
                                                                    //         .clear();
                                                                    //   }
                                                                    //   Navigator.of(
                                                                    //           context)
                                                                    //       .pop();
                                                                    // }
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .edit_note_sharp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  label: Text(
                                                                    'confirm',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit_note_rounded,
                                                    size: 25,
                                                    color: Colors.white,
                                                  )),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_sweep_rounded,
                                                  size: 25,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  43, 0, 50, 1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          title: const Text(
                                                            'Delete Playlist',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                          content: const Text(
                                                            'Are you sure you want to delete this playlist?',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          actions: <Widget>[
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
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                'Yes',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                musicList
                                                                    .deleteAt(
                                                                        index);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                            ],
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
