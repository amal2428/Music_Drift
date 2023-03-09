import 'package:hive/hive.dart';
part 'audio_player.g.dart';

@HiveType(typeId: 1)
class AudioPlayer extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  List<int> songId;
  // @HiveField(2)
  // int count;

  AudioPlayer({
    required this.name,
    required this.songId,
    // this.count=0,
  });

  add(int id) async {
    songId.add(id);
    save();
  }
  

  deleteData(int id) {
    songId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songId.contains(id);
  }
}



