import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_drift/screens/favourite_screen/mostly_played.dart';
import 'package:music_drift/screens/favourite_screen/recently_played.dart';
import 'package:music_drift/widgets/bg.dart';
import 'package:music_drift/widgets/get_songs.dart';
import 'package:music_drift/widgets/miniplayer.dart';
import 'package:music_drift/widgets/mostly_played.dart';
import 'package:music_drift/widgets/recents.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../db_functions/db_function/db_fav.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

ConcatenatingAudioSource createSongList(List<SongModel> song) {
  List<AudioSource> source = [];
  for (var songs in song) {
    source.add(AudioSource.uri(Uri.parse(songs.uri!)));
  }
  return ConcatenatingAudioSource(children: source);
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavouriteDb.favouriteSongs,
        builder:
            (BuildContext context, List<SongModel> favourData, Widget? child) {
          return Container(
            decoration: BoxDecoration(gradient: linearGradient()),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: FadeScrollAppBar(
                scrollController: _scrollController,
                pinned: false,
                elevation: 5,
                fadeOffset: 50,
                expandedHeight: 150,
                backgroundColor: Colors.transparent,
                fadeWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 25),
                          child: Text(
                            " Favourites",
                            style: GoogleFonts.iceberg(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                                letterSpacing: 3,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(43, 0, 50, 0.295),
                                borderRadius: BorderRadius.circular(8)),
                            height: 40,
                            width: 150,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Recently Played',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RecentlyPlayed()));
                            print('Recently played');
                          },
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(43, 0, 50, 0.295),
                                borderRadius: BorderRadius.circular(8)),
                            height: 40,
                            width: 150,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Mostly Played',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                )),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MostlyPlayed()));
                            print('Mostly played');
                          },
                        )
                      ],
                    )
                  ],
                ),
                child: ValueListenableBuilder(
                    valueListenable: FavouriteDb.favouriteSongs,
                    builder:
                        (context, List<SongModel> favourData, Widget? child) {
                      return FavouriteDb.favouriteSongs.value.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/no_favorites.png',
                                      height: 150),
                                  const Text(
                                    'No Favourites',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ValueListenableBuilder(
                                  valueListenable: FavouriteDb.favouriteSongs,
                                  builder: (BuildContext context,
                                      List<SongModel> favorData,
                                      Widget? child) {
                                    return ListView.builder(
                                      itemCount: favorData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () {
                                            FavouriteDb.favouriteSongs
                                                .notifyListeners();
                                            List<SongModel> favourlist = [
                                              ...favorData
                                            ];

                                            GetSongs.audioPlayer.setAudioSource(
                                                GetSongs.createSongList(
                                                    favourlist),
                                                initialIndex: index);

                                            GetSongs.audioPlayer.play();

                                            ShowMiniPlayer.updateMiniPlayer(
                                                songlist: favourlist);
                                          },
                                          tileColor: const Color.fromARGB(
                                              9, 126, 126, 126),
                                          leading: QueryArtworkWidget(
                                            artworkBorder:
                                                BorderRadius.circular(5),
                                            id: favorData[index].id,
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: const Image(
                                              image: AssetImage(
                                                  "assets/images/music logo.jpg"),
                                              fit: BoxFit.fill,
                                              height: 45,
                                              width: 50,
                                            ),
                                          ),
                                          title: Text(
                                            favorData[index].title,
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(
                                            favorData[index].artist!,
                                            maxLines: 1,
                                          ),
                                          textColor: Colors.white,
                                          trailing: IconButton(
                                            onPressed: () {
                                              FavouriteDb.favouriteSongs
                                                  .notifyListeners();
                                              FavouriteDb.delete(
                                                  favorData[index].id);
                                              const snackBar = SnackBar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                duration:
                                                    Duration(milliseconds: 800),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                width: 200,
                                                content: Text(
                                                  'Removed From Favourites',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            },
                                            icon: const Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            );
                    }),
              ),
            ),
          );
        });
  }
}
