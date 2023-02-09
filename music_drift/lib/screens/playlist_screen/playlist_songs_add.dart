import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_drift/db_functions/db_function/db_playlist.dart';
import 'package:music_drift/db_functions/model/audio_player.dart';
import 'package:music_drift/screens/favourite_screen/favourite_btn.dart';
import 'package:music_drift/screens/play_screen/play_screen.dart';
import 'package:music_drift/screens/playlist_screen/playlist_page_view.dart';
import 'package:music_drift/widgets/bg.dart';
import 'package:music_drift/widgets/get_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistAddSongs extends StatefulWidget {
  const PlaylistAddSongs(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final AudioPlayer playlist;
  final int folderindex;

  @override
  State<PlaylistAddSongs> createState() => _PlaylistAddSongsState();
}

class _PlaylistAddSongsState extends State<PlaylistAddSongs> {
  late List<SongModel> playlistSong;
  @override
  Widget build(BuildContext context) {
    PlaylistDb.getAllPlaylist();

    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.playlist.name),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaylistViewPage(playlist: widget.playlist),
                  ));
                },
                icon: const Icon(
                  Icons.playlist_add,
                  size: 30,
                ))
          ],
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          
            child: ValueListenableBuilder(
              
          valueListenable: Hive.box<AudioPlayer>('playlistDB').listenable(),
          builder:
              (BuildContext context, Box<AudioPlayer> value, Widget? child) {
            playlistSong =
                listplaylist(value.values.toList()[widget.folderindex].songId);
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (context) {
                        widget.playlist.deleteData(playlistSong[index].id);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ]),
                  child: ListTile(
                      onTap: () async {
                        List<SongModel> newList = [...playlistSong];
                        GetSongs.audioPlayer.setAudioSource(
                            GetSongs.createSongList(newList),
                            initialIndex: index);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => PlayScreen(
                                  audioPlayerSong: playlistSong,
                                )),
                          ),
                        );
                        GetSongs.audioPlayer.play();
                      },
                      leading: QueryArtworkWidget(
                        id: playlistSong[index].id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(2),
                        size: 50,
                        artworkFit: BoxFit.fill,
                        quality: 100,
                        nullArtworkWidget: Icon(
                          Icons.music_note_rounded,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        playlistSong[index].displayNameWOExt,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        playlistSong[index].artist!,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: FavouriteButton(
                        song: playlistSong[index],
                      )),
                );
              }),
              itemCount: playlistSong.length,
              separatorBuilder: (context, index) => const Divider(),
            );
          },
        )),
      ),
    );
  }

  List<SongModel> listplaylist(List<int> data) {
    List<SongModel> playsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          playsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return playsongs;
  }
}
