import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../blocs/player_load_events.dart';
import '../blocs/player_state.dart';
import '../widgets/swiper.dart';
import '../widgets/artist.dart';
import '../widgets/progress_slider.dart';
import '../widgets/botonera.dart';
import '../widgets/add_internet_track_dialog.dart';

class Player extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const Player({super.key, this.onMenuPressed});

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<Player> {
  static const Color colorPrincipal = Color(0xFF8B5CF6);
  static const Color colorFondo = Color(0xFF1E1B4B);

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PlayerBloc>();
    if (bloc.state is InitialState) {
      bloc.add(const PlayerLoadEvent(0));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSettingsModal() {
    _showSettingsModal(context);
  }

  void _showSettingsModal(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: const Color(0xFF1E1B4B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, currentState) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                String estadoTexto = "Pausado";
                String duracionTexto = "00:00";
                String posicionTexto = "00:00";
                double currentVolume = 1.0;
                double currentPitch = 1.0;

                if (currentState is PlayingState) {
                  estadoTexto = currentState.isPlaying
                      ? "Reproduciendo"
                      : "Pausado";
                  duracionTexto = _formatearTiempo(currentState.duration);
                  posicionTexto = _formatearTiempo(currentState.position);
                  currentVolume = currentState.volume;
                  currentPitch = currentState.pitch;
                }

                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Text(
                          "Configuración de Audio",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              currentVolume < 0.3
                                  ? Icons.volume_mute
                                  : currentVolume < 0.7
                                  ? Icons.volume_down
                                  : Icons.volume_up,
                              color: Colors.white70,
                              size: 24,
                            ),
                            Expanded(
                              child: Slider(
                                value: currentVolume,
                                min: 0.0,
                                max: 1.0,
                                divisions: 100,
                                activeColor: colorPrincipal,
                                inactiveColor: colorPrincipal.withValues(
                                  alpha: 0.2,
                                ),
                                onChanged: (value) {
                                  context.read<PlayerBloc>().add(
                                    ChangeVolumeEvent(value),
                                  );
                                },
                              ),
                            ),
                            const Icon(
                              Icons.volume_up,
                              color: Colors.white70,
                              size: 24,
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "Volumen: ${(currentVolume * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Velocidad de Reproducción",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((
                            speed,
                          ) {
                            final isSelected =
                                (currentPitch - speed).abs() < 0.01;
                            return GestureDetector(
                              onTap: () {
                                context.read<PlayerBloc>().add(
                                  ChangePitchEvent(speed),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorPrincipal
                                      : Colors.grey[800],
                                  border: Border.all(
                                    color: isSelected
                                        ? colorPrincipal
                                        : Colors.grey[600]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    if (isSelected) const SizedBox(width: 4),
                                    Text(
                                      "${speed}x",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Información del Audio",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoColumn("Estado", estadoTexto),
                                  _buildInfoColumn("Duración", duracionTexto),
                                  _buildInfoColumn("Posición", posicionTexto),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(modalContext);
                              showAddInternetTrackDialog(parentContext);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Agregar Canción desde Internet"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrincipal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatearTiempo(Duration duration) {
    final minutos = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "$minutos:$segundos";
  }

  Widget _buildInternetTrackImage(String imageUrl) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.35;
    final imageHeight = availableHeight.clamp(180.0, 220.0);

    return Container(
      height: imageHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorPrincipal.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: imageHeight,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint("Error cargando imagen: $error");
            return _buildPlaceholderImage();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[900],
              child: Center(
                child: CircularProgressIndicator(
                  color: colorPrincipal,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.35;
    final imageHeight = availableHeight.clamp(180.0, 220.0);

    return Container(
      height: imageHeight,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[800],
        boxShadow: [
          BoxShadow(
            color: colorPrincipal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.music_note, size: 80, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorPrincipal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: 'Abrir menú',
                      onPressed: widget.onMenuPressed ?? () {},
                      splashRadius: 24,
                    ),
                  ),
                  const Text(
                    'Playbloc',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => _showSettingsModal(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  if (state is PlayingState) {
                    return Stack(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: CustomScrollView(
                            key: ValueKey(state.currentIndex),
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    state.isInternetTrack &&
                                            state.imageUrl != null &&
                                            state.imageUrl!.isNotEmpty
                                        ? _buildInternetTrackImage(
                                            state.imageUrl!,
                                          )
                                        : state.isInternetTrack
                                        ? _buildPlaceholderImage()
                                        : Swiper(
                                            audioList: context
                                                .read<PlayerBloc>()
                                                .canciones,
                                            currentIndex: state.currentIndex,
                                            onpageChange: (index) {
                                              context.read<PlayerBloc>().add(
                                                PlayerLoadEvent(index),
                                              );
                                            },
                                            color: colorPrincipal,
                                          ),
                                    Artist(
                                      artist: state.artist,
                                      name: state.title,
                                      song: state.title,
                                    ),
                                    ProgressSlider(
                                      value: state.position.inSeconds
                                          .toDouble(),
                                      max: state.duration.inSeconds.toDouble(),
                                      onChanged: (val) {
                                        final newpos = Duration(
                                          seconds: val.toInt(),
                                        );
                                        context.read<PlayerBloc>().add(
                                          SeekEvent(newpos),
                                        );
                                      },
                                      color: colorPrincipal,
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Botonera(
                                        play: () => context
                                            .read<PlayerBloc>()
                                            .add(PlayPauseEvent()),
                                        next: () => context
                                            .read<PlayerBloc>()
                                            .add(NextEvent()),
                                        previous: () => context
                                            .read<PlayerBloc>()
                                            .add(PrevEvent()),
                                        playing: state.isPlaying,
                                        position: state.position,
                                        duration: state.duration,
                                        progressPercent:
                                            state.duration.inSeconds == 0
                                            ? 0.0
                                            : (state.position.inSeconds /
                                                      state.duration.inSeconds)
                                                  .clamp(0.0, 1.0),
                                        color: colorPrincipal,
                                        onPlay: () {},
                                        onPause: () {},
                                        onStop: () {},
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.isBuffering)
                          Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: colorPrincipal,
                              ),
                            ),
                          ),
                      ],
                    );
                  }

                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(color: colorPrincipal),
                    );
                  } else if (state is ErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(color: colorPrincipal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
