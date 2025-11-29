import 'package:equatable/equatable.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class InitialState extends PlayerState {
  const InitialState();
}

class LoadingState extends PlayerState {
  const LoadingState();
}

class PlayingState extends PlayerState {
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final String title;
  final String artist;
  final double volume;
  final double pitch;
  final bool isInternetTrack;
  final String? imageUrl;
  final bool isBuffering;

  const PlayingState({
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.isPlaying,
    required this.title,
    required this.artist,
    this.volume = 1.0,
    this.pitch = 1.0,
    this.isInternetTrack = false,
    this.imageUrl,
    this.isBuffering = false,
  });

  @override
  List<Object?> get props => [
    currentIndex,
    duration,
    position,
    isPlaying,
    title,
    artist,
    volume,
    pitch,
    isInternetTrack,
    imageUrl,
    isBuffering,
  ];

  PlayingState copyWith({
    int? currentIndex,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    String? title,
    String? artist,
    double? volume,
    double? pitch,
    bool? isInternetTrack,
    String? imageUrl,
    bool? isBuffering,
  }) {
    return PlayingState(
      currentIndex: currentIndex ?? this.currentIndex,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      isInternetTrack: isInternetTrack ?? this.isInternetTrack,
      imageUrl: imageUrl ?? this.imageUrl,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }
}

class ErrorState extends PlayerState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
