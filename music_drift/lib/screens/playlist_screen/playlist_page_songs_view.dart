import 'package:flutter/material.dart';
import 'package:music_drift/db_functions/db_function/db_playlist.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/widgets/bg.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistViewPage extends StatefulWidget {
  const PlaylistViewPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final AudioPlayer playlist;
  @override
  State<PlaylistViewPage> createState() => _PlaylistViewPageState();
}

class _PlaylistViewPageState extends State<PlaylistViewPage> {
  final audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Add songs'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<SongModel>>(
            future: audioQuery.querySongs(
              sortType: SongSortType.TITLE,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Songs Found',
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: ((ctx, index) {
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(2),
                      size: 50,
                      artworkFit: BoxFit.fill,
                      quality: 100,
                      nullArtworkWidget: const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item.data![index].displayNameWOExt,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${item.data![index].artist}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        onPressed: (() {
                          setState(() {
                            checkPlaylist(item.data![index]);

                            PlaylistDb.playlistNotifier.notifyListeners();
                          });
                        }),
                        icon: !widget.playlist.isValueIn(item.data![index].id)
                            ? const Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.remove,
                                color: Colors.red,
                              )),
                  );
                }),
                itemCount: item.data!.length,
              );
            },
          ),
        ),
      ),
    );
    
  }

  void checkPlaylist(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.transparent,
          duration: Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          width: 200,
          content: Text(
            'Added to Playlist',
            style: TextStyle(
              color: Colors.white,
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      widget.playlist.deleteData(data.id);
      final snackbar = SnackBar(
        backgroundColor:  Colors.transparent,
        content: Text(
          'Song Deleted',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        width: 200,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
