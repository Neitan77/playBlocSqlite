import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:play_bloc/repositories/audio_repository.dart';
import 'package:play_bloc/blocs/player_bloc.dart';
import 'package:play_bloc/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioRepository = AudioRepository();
  await audioRepository.initialize();

  runApp(MainApp(audioRepository: audioRepository));
}

class MainApp extends StatelessWidget {
  final AudioRepository audioRepository;

  const MainApp({super.key, required this.audioRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: audioRepository,
      child: BlocProvider(
        create: (context) => PlayerBloc(
          audioPlayer: AudioPlayer(),
          audioRepository: audioRepository,
        ),
        child: const App(),
      ),
    );
  }
}
