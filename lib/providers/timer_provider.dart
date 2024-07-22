import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int activeDuration;
  final int breakDuration;
  final int rounds;
  final int currentRound;
  final int remainingTime;
  final bool isRunning;
  final bool isBreak;
  final bool isPaused;
  final bool soundEnabled;

  TimerState({
    required this.activeDuration,
    required this.breakDuration,
    required this.rounds,
    required this.currentRound,
    required this.remainingTime,
    required this.isRunning,
    required this.isBreak,
    required this.isPaused,
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
    bool? isPaused,
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
      isPaused: isPaused ?? this.isPaused,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;
  final StreamController<int> _timeStreamController = StreamController<int>.broadcast();
  AudioPlayer? _audioPlayer;
  bool _soundReady = false;
  bool _isSoundPlaying = false;
  bool _isPreloading = false;

  Stream<int> get timeStream => _timeStreamController.stream;

  TimerNotifier() : super(TimerState(
    activeDuration: 10,
    breakDuration: 10,
    rounds: 1,
    currentRound: 1,
    remainingTime: 10,
    isRunning: false,
    isBreak: true,
    isPaused: false,
    soundEnabled: false,
  )) {
    _initializeAudioPlayer();
  }

  void start() {
    if (state.isRunning) return;

    _timer?.cancel();
    _timeStreamController.add(state.remainingTime);

    state = state.copyWith(isRunning: true, isPaused: false);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
        _timeStreamController.add(state.remainingTime);

        if (state.soundEnabled && state.remainingTime == 3 && !_isSoundPlaying) {
          _playSound();
        }
      } else {
        if (state.isBreak) {
          state = state.copyWith(
            isBreak: false,
            remainingTime: state.activeDuration,
          );
          _preloadSound(); // Preload sound for active round
        } else {
          if (state.currentRound < state.rounds) {
            state = state.copyWith(
              currentRound: state.currentRound + 1,
              isBreak: true,
              remainingTime: state.breakDuration,
            );
            _preloadSound(); // Preload sound for break round
          } else {
            state = state.copyWith(
              isRunning: false,
              isBreak: true,
              currentRound: 1,
              remainingTime: state.breakDuration,
            );
            _timer?.cancel();
            _timeStreamController.add(state.remainingTime);
          }
        }

        if (state.soundEnabled && _isSoundPlaying) {
          _stopSound();
        } else {
          _preloadSound();
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
    if (_isSoundPlaying) {
      _stopSound();
    }
  }

  Future<void> reset() async {
    // Stop timer and sound
    _timer?.cancel();
    if (_isSoundPlaying) {
      await _stopSound();
    }

    // Reset state
    state = TimerState(
      activeDuration: 10,
      breakDuration: 10,
      rounds: 1,
      currentRound: 1,
      remainingTime: 10,
      isRunning: false,
      isBreak: true,
      isPaused: false,
      soundEnabled: state.soundEnabled, // Keep the current sound setting
    );
    _timeStreamController.add(state.remainingTime);

    // Reinitialize audio player
    await _resetAudioPlayer();

    // Preload sound and play if sound is enabled
    if (state.soundEnabled) {
      await _preloadSound();
      if (state.remainingTime == 3) {
        await _playSound();
      }
    }
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

  void pause() {
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(isPaused: true, isRunning: false);
    }
  }

  void resume() {
    if (state.isPaused) {
      start();
      state = state.copyWith(isPaused: false, isRunning: true);
    }
  }

  Future<void> _initializeAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    print('Audio player initialized.');
    await _preloadSound(); // Preload sound immediately after initializing
  }

  Future<void> _resetAudioPlayer() async {
    _audioPlayer?.dispose(); // Dispose current player
    _audioPlayer = AudioPlayer(); // Reinitialize audio player
    print('Audio player reinitialized.');
    await _preloadSound(); // Preload sound after reinitialization
  }

  Future<void> _preloadSound() async {
    if (_audioPlayer == null) return;

    if (_isPreloading) return; // Avoid redundant preloading
    _isPreloading = true;

    try {
      print('Preloading sound...');
      await _audioPlayer!.setSource(UrlSource('https://drive.google.com/uc?export=download&id=1PVMwKDeQjIHaXnARvvtmBQJ45mgM1rFt')).timeout(Duration(seconds: 10));
      _soundReady = true; // Mark sound as ready
      print('Sound preloaded successfully.');
    } catch (e) {
      print('Error preloading sound: $e');
    } finally {
      _isPreloading = false;
    }
  }

  Future<void> _playSound() async {
    if (!_soundReady) {
      print('Sound not ready. Preloading...');
      await _preloadSound();
    }

    if (_soundReady) {
      try {
        print('Playing sound...');
        await _audioPlayer!.play(UrlSource('https://drive.google.com/uc?export=download&id=1PVMwKDeQjIHaXnARvvtmBQJ45mgM1rFt'));
        _isSoundPlaying = true;
        print('Sound is playing.');
      } catch (e) {
        print('Error playing sound: $e');
      }
    } else {
      print('Sound is not ready to play.');
    }
  }

  Future<void> _stopSound() async {
    if (_audioPlayer != null) {
      try {
        print('Stopping sound...');
        await _audioPlayer!.stop();
        _isSoundPlaying = false;
        print('Sound stopped.');

        // Ensure sound is preloaded immediately after stopping
        await _preloadSound();
      } catch (e) {
        print('Error stopping sound: $e');
      }
    }
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
