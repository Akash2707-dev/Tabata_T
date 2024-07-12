import 'package:flutter/material.dart';

class ProgressOverlay extends StatelessWidget {
  final double progress;  // Value between 0.0 and 1.0
  final bool isTimerFinished;

  const ProgressOverlay({
    Key? key,
    required this.progress,
    required this.isTimerFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen overlay with dynamic width
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,  // Width based on progress
              child: Container(
                color: Colors.black87.withOpacity(0.2),  // Semi-transparent black background
              ),
            ),
          ),
        ),
        // Timer finished message
        if (isTimerFinished)
          Center(
            child: Text(
              'You Did Great!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
