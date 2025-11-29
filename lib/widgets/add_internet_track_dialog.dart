import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../blocs/player_load_events.dart';
import '../models/audio_track.dart';

void showAddInternetTrackDialog(BuildContext parentContext) {
  final urlController = TextEditingController();
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final albumController = TextEditingController();
  final imageUrlController = TextEditingController();
  const Color colorPrincipal = Color(0xFF8B5CF6);

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Agregar Cancion de Internet",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "URL del mp3",
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: colorPrincipal),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Título",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: colorPrincipal),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: artistController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Artista",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: colorPrincipal),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: albumController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Álbum",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: colorPrincipal),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "URL de la Imagen",
                  labelStyle: const TextStyle(color: Colors.white70),
                  helperText: "Debe ser el link con .png ",
                  helperStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: colorPrincipal),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty &&
                  titleController.text.isNotEmpty &&
                  artistController.text.isNotEmpty) {
                final track = AudioTrack(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  artist: artistController.text,
                  album: albumController.text.isEmpty
                      ? "Desconocido"
                      : albumController.text,
                  url: urlController.text,
                  duration: const Duration(minutes: 3, seconds: 30),
                  imageUrl: imageUrlController.text.isEmpty
                      ? null
                      : imageUrlController.text,
                );

                parentContext.read<PlayerBloc>().add(
                  AddInternetTrackEvent(track),
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text("se agrego la cancion"),
                    backgroundColor: colorPrincipal,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrincipal,
              foregroundColor: Colors.white,
            ),
            child: const Text("Agregar"),
          ),
        ],
      );
    },
  );
}
