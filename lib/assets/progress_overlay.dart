import 'package:flutter/material.dart';

class ProgressOverlay extends StatelessWidget {
  final double progress;  // Value between 0.0 and 1.0
  final bool isTimerFinished;
  final bool isPaused;  // Flag to determine if the timer is paused

  const ProgressOverlay({
    Key? key,
    required this.progress,
    required this.isTimerFinished,
    required this.isPaused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true, // Prevent interaction with underlying widgets
      child: Stack(
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
          // Pause indicator if paused
          if (isPaused)
            Center(
              child: Icon(
                Icons.pause,
                size: 48,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
