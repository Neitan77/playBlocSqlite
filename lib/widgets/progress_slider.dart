import 'package:flutter/material.dart';

class ProgressSlider extends StatelessWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final Color color;

  const ProgressSlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.color = const Color(0xffda1cd2),
  });

  String formatTime(double seconds) {
    final int min = seconds ~/ 60;
    final int sec = seconds.toInt() % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: value.clamp(0, max),
            min: 0,
            max: max > 0 ? max : 1,
            onChanged: onChanged,
            activeColor: color,
            inactiveColor: color.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(value),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                Text(
                  formatTime(max),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
