import '../models/audio_item.dart';
import '../models/audio_track.dart';
import '../services/database_helper.dart';

class AudioRepository {
  List<AudioItem> _canciones = [];

  final List<AudioTrack> _internetTracks = [];

  Future<void> initialize() async {
    await DatabaseHelper.instance.getDataBase();
    await DatabaseHelper.instance.seedInitialData();
    _canciones = await DatabaseHelper.instance.readAll();
  }

  List<AudioItem> getCanciones() {
    return _canciones;
  }

  List<AudioTrack> getInternetTracks() {
    return _internetTracks;
  }

  int getTotalCount() {
    return _canciones.length + _internetTracks.length;
  }

  int getLocalCount() {
    return _canciones.length;
  }

  void addInternetTrack(AudioTrack track) {
    _internetTracks.add(track);
  }
}
