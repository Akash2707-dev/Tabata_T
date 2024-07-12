import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int activeDuration;
  final int breakDuration;
  final int rounds;
  final int currentRound;
  final int remainingTime;
  final bool isRunning;
  final bool isBreak;
  final bool soundEnabled;

  TimerState({
    required this.activeDuration,
    required this.breakDuration,
    required this.rounds,
    required this.currentRound,
    required this.remainingTime,
    required this.isRunning,
    required this.isBreak,
    required this.soundEnabled,
  });

  TimerState copyWith({
    int? activeDuration,
    int? breakDuration,
    int? rounds,
    int? currentRound,
    int? remainingTime,
    bool? isRunning,
    bool? isBreak,
    bool? soundEnabled,
  }) {
    return TimerState(
      activeDuration: activeDuration ?? this.activeDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;
  final StreamController<int> _timeStreamController = StreamController<int>.broadcast();

  Stream<int> get timeStream => _timeStreamController.stream;

  TimerNotifier() : super(TimerState(
    activeDuration: 10,
    breakDuration: 10,
    rounds: 1,
    currentRound: 1,
    remainingTime: 10, // Set initial break duration
    isRunning: false,
    isBreak: true,  // Start with break period
    soundEnabled: false,
  ));

  void start() {
    if (state.isRunning) return;

    _timer?.cancel();
    _timeStreamController.add(state.remainingTime);

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
        _timeStreamController.add(state.remainingTime);
      } else {
        if (state.isBreak) {
          // Switch to active round after break
          state = state.copyWith(
            isBreak: false,
            remainingTime: state.activeDuration,
          );
        } else {
          if (state.currentRound < state.rounds) {
            // Move to the break period
            state = state.copyWith(
              currentRound: state.currentRound + 1,
              isBreak: true,
              remainingTime: state.breakDuration,
            );
          } else {
            // Complete all rounds and reset
            state = state.copyWith(
              isRunning: false,
              isBreak: true,
              currentRound: 1, // Reset to the first round
              remainingTime: state.breakDuration, // Reset remaining time to break duration
            );
            _timer?.cancel();
            _timeStreamController.add(state.remainingTime);
          }
        }

        if (state.soundEnabled) {
          // Play sound
        }

        _timeStreamController.add(state.remainingTime);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingTime: state.isBreak ? state.breakDuration : state.activeDuration,
      isRunning: false,
    );
    _timeStreamController.add(state.remainingTime);
  }

  void setActiveDuration(int duration) {
    state = state.copyWith(
      activeDuration: duration,
      remainingTime: state.isBreak ? state.breakDuration : duration,
    );
  }

  void setBreakDuration(int duration) {
    state = state.copyWith(breakDuration: duration);
    if (state.isBreak) {
      state = state.copyWith(remainingTime: duration);
      _timeStreamController.add(state.remainingTime);
    }
  }

  void setRounds(int rounds) {
    state = state.copyWith(rounds: rounds);
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
