import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_drift/db_functions/db_function/db_fav.dart';
import 'package:music_drift/screens/favourite_screen/favourite_btn.dart';
import 'package:music_drift/widgets/bg.dart';
import 'package:music_drift/widgets/get_songs.dart';
import 'package:music_drift/widgets/miniplayer.dart';
import 'package:music_drift/widgets/text.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool play = true;

  Icon playIcon = const Icon(Icons.play_arrow);
  final _audioQuery = OnAudioQuery();
  final _controller = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  void dispose() {
    GetSongs.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      top: 50,
                    ),
                    child: TextWidget(
                      title: 'Welcome To Music Drift!',
                      size: 25,
                      style: FontStyle.italic,
                      textColor: Colors.white,
                    )),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: TextWidget(
                    title: 'What do you feel like today?',
                    size: 15,
                    style: FontStyle.normal,
                    textColor: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Search field starts
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: false,
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    style: const TextStyle(
                        color: Color.fromARGB(255, 188, 173, 173)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 79, 8, 50),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      hintText: "Search song, artist, title...",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 188, 173, 173)),
                      prefixIcon: const Icon(Icons.search,
                          color: Color.fromARGB(255, 188, 173, 173)),
                    ),
                  ),
                ),
                //search field ends

                const SizedBox(
                  height: 10,
                ),
                //songs fetching
                FutureBuilder<List<SongModel>>(
                  future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true),
                  builder: (context, item) {
                    if (item.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (item.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No songs Found',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 2),
                        ),
                      );
                    }

                    if (!FavouriteDb.isfavourite) {
                      FavouriteDb.isFavourite(item.data!);
                    }

                    GetSongs.songscopy = item.data!;

                    List<SongModel>? songData =
                        searchFromStringList(searchText, item.data);
                    if (searchText == "") {
                      songData = item.data;
                    }

                    if (songData!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No songs Found',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: songData.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () async {
                                GetSongs.audioPlayer.setAudioSource(
                                    GetSongs.createSongList(songData!),
                                    initialIndex: index);

                                await ShowMiniPlayer.updateMiniPlayer(
                                    songlist: songData);

                                await GetSongs.audioPlayer.play();
                              },
                              leading: QueryArtworkWidget(
                                id: songData![index].id,

                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(1),
                                // size: 40,
                                artworkHeight: 45,
                                artworkWidth: 50,
                                artworkFit: BoxFit.fill,
                                quality: 100,
                                nullArtworkWidget: const Image(
                                  image: AssetImage(
                                      "assets/images/music logo.jpg"),
                                  fit: BoxFit.fill,
                                  height: 45,
                                  width: 50,
                                ),
                              ),
                              title: Text(
                                songData[index].displayNameWOExt,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Text(
                                "${songData[index].artist}",
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing:
                                  FavouriteButton(song: item.data![index]),
                              textColor: Colors.white,
                              iconColor: Colors.white,
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  searchFromStringList(String query, stringList) {
    List suggestions = stringList.where((stringElement) {
      String findString = query.toLowerCase();
      final mainString = stringElement.toString().toLowerCase();
      return mainString.contains(findString);
    }).toList();

    return suggestions;
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        setState(() {});
      }
    }
  }
}
