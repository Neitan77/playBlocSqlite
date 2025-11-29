import 'package:flutter/material.dart';

class Botonera extends StatelessWidget {
  final VoidCallback play;
  final VoidCallback next;
  final VoidCallback previous;
  final bool playing;
  final Duration position;
  final Duration duration;
  final double progressPercent;
  final Color color;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const Botonera({
    super.key,
    required this.play,
    required this.next,
    required this.previous,
    required this.playing,
    required this.position,
    required this.duration,
    required this.progressPercent,
    required this.color,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
  });

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            iconSize: 28,
            onPressed: previous,
          ),
          const SizedBox(width: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: progressPercent,
                  strokeWidth: 4,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 36,
                  padding: const EdgeInsets.all(12),
                  onPressed: play,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            iconSize: 28,
            onPressed: next,
          ),
        ],
      ),
    );
  }
}
