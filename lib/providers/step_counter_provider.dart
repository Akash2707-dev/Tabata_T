import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounterState {
  final int stepCount;
  final bool isRunning;
  final bool isPaused;

  StepCounterState({
    required this.stepCount,
    required this.isRunning,
    required this.isPaused,
  });

  StepCounterState copyWith({
    int? stepCount,
    bool? isRunning,
    bool? isPaused,
  }) {
    return StepCounterState(
      stepCount: stepCount ?? this.stepCount,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class StepCounterNotifier extends StateNotifier<StepCounterState> {
  StepCounterNotifier()
      : super(StepCounterState(stepCount: 0, isRunning: false, isPaused: false)) {
    _initializePedometer();
  }

  StreamSubscription<StepCount>? _stepCountSubscription;
  int _initialStepCount = 0;
  int _readingCount = 0;  // Count the number of readings
  bool _addedExtraSteps = false;  // Track if extra steps have been added

  Future<void> _initializePedometer() async {
    final permissionStatus = await Permission.activityRecognition.request();
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      // Notify user to enable permissions
      // This will be handled in the StepCalculatorScreen
    } else {
      _stepCountSubscription = Pedometer.stepCountStream.listen((stepCount) {
        if (state.isRunning) {
          if (_initialStepCount == 0) {
            _initialStepCount = stepCount.steps;
          }

          // Increment the reading count
          _readingCount++;

          // Add 3 extra steps to the initial step count after the 3rd reading
          if (_readingCount == 3 && !_addedExtraSteps) {
            _addedExtraSteps = true;
            _initialStepCount -= 0;  // Add 3 extra steps
          }

          // Update the step count, subtract the initial step count
          int currentSteps = stepCount.steps - _initialStepCount;
          state = state.copyWith(stepCount: currentSteps);
        }
      });
    }
  }

  void startCounting() {
    state = state.copyWith(isRunning: true, isPaused: false);
    _initializePedometer();
  }

  void pauseCounting() {
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void resumeCounting() {
    state = state.copyWith(isPaused: false);
  }

  void resetCounting() {
    _initialStepCount = 0;
    _readingCount = 0;  // Reset the reading count
    _addedExtraSteps = false;  // Reset the extra steps flag
    state = state.copyWith(stepCount: 0, isRunning: false, isPaused: false);
    _stepCountSubscription?.cancel();
    _initializePedometer();
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    super.dispose();
  }
}

final stepCounterProvider = StateNotifierProvider<StepCounterNotifier, StepCounterState>(
      (ref) => StepCounterNotifier(),
);
