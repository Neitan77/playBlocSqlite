import 'package:play_bloc/blocs/player_event.dart';
import 'package:play_bloc/models/audio_track.dart';

class PlayerLoadEvent extends PlayerEvent {
  final int index;
  const PlayerLoadEvent(this.index);
  @override
  List<Object> get props => [index];
}

class PlayEvent extends PlayerEvent {}

class PauseEvent extends PlayerEvent {}

class NextEvent extends PlayerEvent {}

class PrevEvent extends PlayerEvent {}

class PlayPauseEvent extends PlayerEvent {}

class SeekEvent extends PlayerEvent {
  final Duration position;
  const SeekEvent(this.position);
  @override
  List<Object> get props => [position];
}

class ChangePitchEvent extends PlayerEvent {
  final double pitch;
  const ChangePitchEvent(this.pitch);
  @override
  List<Object> get props => [pitch];
}

class ChangeVolumeEvent extends PlayerEvent {
  final double volume;
  const ChangeVolumeEvent(this.volume);
  @override
  List<Object> get props => [volume];
}

class AddInternetTrackEvent extends PlayerEvent {
  final AudioTrack track;
  const AddInternetTrackEvent(this.track);
  @override
  List<Object> get props => [track];
}
