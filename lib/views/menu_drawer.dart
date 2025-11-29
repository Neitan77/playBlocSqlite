import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../blocs/player_state.dart';
import '../blocs/player_load_events.dart';
import '../widgets/add_internet_track_dialog.dart';
import 'player.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final GlobalKey<SliderDrawerState> _drawerKey =
      GlobalKey<SliderDrawerState>();
  final GlobalKey<PlayerWidgetState> _playerKey =
      GlobalKey<PlayerWidgetState>();

  Widget _getView() {
    return Player(
      key: _playerKey,
      onMenuPressed: () => _drawerKey.currentState?.toggle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      key: _drawerKey,
      appBar: const SizedBox.shrink(),
      slider: Material(
        color: const Color(0xFF312E81),
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            bool isPlaying = false;
            if (state is PlayingState) {
              isPlaying = state.isPlaying;
            }

            return Column(
              children: [
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/menu_avatar.jpg"),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text(
                    "Inicio",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.home, color: Colors.white),
                  onTap: () {
                    _drawerKey.currentState?.toggle();
                  },
                ),
                ListTile(
                  title: const Text(
                    "Configuración",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.settings, color: Colors.white),
                  onTap: () {
                    _drawerKey.currentState?.toggle();
                    _playerKey.currentState?.showSettingsModal();
                  },
                ),
                const Divider(color: Colors.white24, height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Controlitos",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                            ),
                            iconSize: 32,
                            onPressed: () {
                              context.read<PlayerBloc>().add(PrevEvent());
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              iconSize: 36,
                              onPressed: () {
                                context.read<PlayerBloc>().add(
                                  PlayPauseEvent(),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                            ),
                            iconSize: 32,
                            onPressed: () {
                              context.read<PlayerBloc>().add(NextEvent());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _drawerKey.currentState?.toggle();
                        showAddInternetTrackDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Agregar cancion"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ListTile(
                  title: const Text(
                    "Salir",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.exit_to_app, color: Colors.white),
                  onTap: () {
                    _drawerKey.currentState?.toggle();
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        ),
      ),
      child: _getView(),
    );
  }
}
