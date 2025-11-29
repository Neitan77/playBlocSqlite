import 'package:flutter/material.dart';

class ExitView extends StatelessWidget {
  const ExitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Seguro que quieres salir?", style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Cerrar aplicación"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Función de salida no disponible en web")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}