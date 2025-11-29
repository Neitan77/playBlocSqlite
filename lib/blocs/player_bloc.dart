import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart' hide PlayerState;
import 'package:play_bloc/blocs/player_event.dart';
import 'package:play_bloc/blocs/player_load_events.dart';
import 'package:play_bloc/blocs/player_state.dart';
import 'package:play_bloc/models/audio_item.dart';
import 'package:play_bloc/repositories/audio_repository.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer audioPlayer;
  final AudioRepository audioRepository;
  late List<AudioItem> canciones;
  late StreamSubscription _durationSub;
  late StreamSubscription _positionSub;

  PlayerBloc({required this.audioPlayer, required this.audioRepository})
    : super(const InitialState()) {
    canciones = audioRepository.getCanciones();

    _durationSub = audioPlayer.onDurationChanged.listen((d) {
      if (!isClosed && state is PlayingState) {
        add(_UpdateDurationEvent(d));
      }
    });

    _positionSub = audioPlayer.onPositionChanged.listen((p) {
      if (!isClosed && state is PlayingState) {
        add(_UpdatePositionEvent(p));
      }
    });

    on<PlayerLoadEvent>(cargarCancion);
    on<PlayEvent>(reproducir);
    on<PauseEvent>(pausar);
    on<PlayPauseEvent>(alternar);
    on<NextEvent>(siguiente);
    on<PrevEvent>(anterior);
    on<SeekEvent>(mover);
    on<ChangePitchEvent>(cambiarVelocidad);
    on<ChangeVolumeEvent>(cambiarVolumen);
    on<AddInternetTrackEvent>(agregarCancionInternet);
    on<_UpdateDurationEvent>(actualizarDuracion);
    on<_UpdatePositionEvent>(actualizarPosicion);
  }

  @override
  Future<void> close() {
    _durationSub.cancel();
    _positionSub.cancel();
    return super.close();
  }

  Future<void> actualizarDuracion(
    _UpdateDurationEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (state is PlayingState) {
      emit((state as PlayingState).copyWith(duration: event.duration));
    }
  }

  Future<void> actualizarPosicion(
    _UpdatePositionEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (state is PlayingState) {
      emit((state as PlayingState).copyWith(position: event.position));
    }
  }

  Future<void> cargarCancion(
    PlayerLoadEvent event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      double currentVolume = 1.0;
      double currentPitch = 1.0;

      if (state is PlayingState) {
        final estadoActual = state as PlayingState;
        currentVolume = estadoActual.volume;
        currentPitch = estadoActual.pitch;
      }

      await audioPlayer.stop();

      final localCount = audioRepository.getLocalCount();
      final isInternet = event.index >= localCount;

      String title;
      String artist;
      String? imageUrl;

      if (isInternet) {
        final internetTracks = audioRepository.getInternetTracks();
        final trackIndex = event.index - localCount;
        final track = internetTracks[trackIndex];
        title = track.title;
        artist = track.artist;
        imageUrl = track.imageUrl;
      } else {
        title = canciones[event.index].title;
        artist = canciones[event.index].artist;
        imageUrl = null;
      }

      emit(
        PlayingState(
          currentIndex: event.index,
          duration: Duration.zero,
          position: Duration.zero,
          isPlaying: false,
          title: title,
          artist: artist,
          volume: currentVolume,
          pitch: currentPitch,
          isInternetTrack: isInternet,
          imageUrl: imageUrl,
          isBuffering: true,
        ),
      );

      if (isInternet) {
        final internetTracks = audioRepository.getInternetTracks();
        final trackIndex = event.index - localCount;
        final track = internetTracks[trackIndex];
        await audioPlayer.setSourceUrl(track.url);
      } else {
        await audioPlayer.setSourceAsset(canciones[event.index].assetPath);
      }

      await audioPlayer.setVolume(currentVolume);
      await audioPlayer.setPlaybackRate(currentPitch);

      Duration? duracion = await audioPlayer.getDuration();
      duracion ??= const Duration(seconds: 30);

      try {
        await audioPlayer.resume();
        emit(
          PlayingState(
            currentIndex: event.index,
            duration: duracion,
            position: Duration.zero,
            isPlaying: true,
            title: title,
            artist: artist,
            volume: currentVolume,
            pitch: currentPitch,
            isInternetTrack: isInternet,
            imageUrl: imageUrl,
            isBuffering: false,
          ),
        );
      } catch (resumeError) {
        debugPrint("No se pudo iniciar reproducción automática: $resumeError");
        emit(
          PlayingState(
            currentIndex: event.index,
            duration: duracion,
            position: Duration.zero,
            isPlaying: false,
            title: title,
            artist: artist,
            volume: currentVolume,
            pitch: currentPitch,
            isInternetTrack: isInternet,
            imageUrl: imageUrl,
            isBuffering: false,
          ),
        );
      }
    } catch (e) {
      emit(const ErrorState("Error: no se pudo cargar el archivo"));
      debugPrint(e.toString());
    }
  }

  Future<void> reproducir(PlayEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.resume();
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(isPlaying: true));
      } catch (e) {
        emit(const ErrorState("Error: no se pudo reproducir el archivo"));
        debugPrint(e.toString());
      }
    }
  }

  Future<void> pausar(PauseEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.pause();
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(isPlaying: false));
      } catch (e) {
        emit(const ErrorState("Error al pausar"));
        debugPrint(e.toString());
      }
    }
  }

  Future<void> alternar(PlayPauseEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      final estadoActual = state as PlayingState;
      add(estadoActual.isPlaying ? PauseEvent() : PlayEvent());
    }
  }

  Future<void> siguiente(NextEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      final totalCount = audioRepository.getTotalCount();
      final nuevoIndex =
          ((state as PlayingState).currentIndex + 1) % totalCount;
      add(PlayerLoadEvent(nuevoIndex));
    }
  }

  Future<void> anterior(PrevEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      final totalCount = audioRepository.getTotalCount();
      final nuevoIndex =
          ((state as PlayingState).currentIndex - 1 + totalCount) % totalCount;
      add(PlayerLoadEvent(nuevoIndex));
    }
  }

  Future<void> mover(SeekEvent event, Emitter<PlayerState> emit) async {
    if (state is PlayingState) {
      try {
        await audioPlayer.seek(event.position);
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(position: event.position));
      } catch (e) {
        emit(const ErrorState("Error al mover la posición"));
        debugPrint(e.toString());
      }
    }
  }

  Future<void> cambiarVelocidad(
    ChangePitchEvent event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      await audioPlayer.setPlaybackRate(event.pitch);
      if (state is PlayingState) {
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(pitch: event.pitch));
      }
    } catch (e) {
      debugPrint("Error al cambiar el pitch: ${e.toString()}");
    }
  }

  Future<void> cambiarVolumen(
    ChangeVolumeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      await audioPlayer.setVolume(event.volume);
      if (state is PlayingState) {
        final estadoActual = state as PlayingState;
        emit(estadoActual.copyWith(volume: event.volume));
      }
    } catch (e) {
      debugPrint("Error al cambiar el volumen: ${e.toString()}");
    }
  }

  Future<void> agregarCancionInternet(
    AddInternetTrackEvent event,
    Emitter<PlayerState> emit,
  ) async {
    audioRepository.addInternetTrack(event.track);
  }
}

class _UpdateDurationEvent extends PlayerEvent {
  final Duration duration;
  const _UpdateDurationEvent(this.duration);
  @override
  List<Object> get props => [duration];
}

class _UpdatePositionEvent extends PlayerEvent {
  final Duration position;
  const _UpdatePositionEvent(this.position);
  @override
  List<Object> get props => [position];
}
