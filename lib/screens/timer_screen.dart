import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../providers/timer_provider.dart';
import '../assets/progress_overlay.dart';  // Import ProgressOverlay
import '../assets/drawer.dart';  // Import AppDrawer

class TimerScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    // Determine background color based on the state
    final backgroundColor = timerState.isBreak ? Colors.greenAccent.shade100 : Colors.redAccent.shade200;

    return Scaffold(
      // Add the drawer to the Scaffold
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,  // Set AppBar background to white
        title: Text(
          'Tabata Timer',
          style: TextStyle(color: Colors.black),  // Set text color to black
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage('https://media.istockphoto.com/id/665421358/vector/muscular-arm-icon.jpg?s=612x612&w=0&k=20&c=4LhJnPcnm1SBeZDrtPvEktjuvYIXGXubO1TMAaFrDXs='),  // Replace with your network image URL
              radius: 24,  // Set the radius of the CircleAvatar
            ),
            onPressed: () {
              // Open the drawer when the CircleAvatar is tapped
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        toolbarHeight: 56.0,  // Set toolbar height to default size (or adjust as needed)
        elevation: 0,  // Remove shadow for a flat AppBar
      ),
      body: Stack(
        children: [
          Container(
            color: backgroundColor,  // Set background color based on the state
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    timerState.isBreak ? 'Break' : 'Active',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<int>(
                    stream: timerNotifier.timeStream,
                    builder: (context, snapshot) {
                      final remainingTime = snapshot.data ?? timerState.remainingTime;
                      return Text(
                        _formatTime(remainingTime),
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Round ${timerState.currentRound}/${timerState.rounds}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  _buildDurationInput(
                    context,
                    'Active Duration',
                    timerState.activeDuration,
                        (duration) => timerNotifier.setActiveDuration(duration),
                  ),
                  SizedBox(height: 20),
                  _buildDurationInput(
                    context,
                    'Break Duration',
                    timerState.breakDuration,
                        (duration) => timerNotifier.setBreakDuration(duration),
                  ),
                  SizedBox(height: 20),
                  _buildRoundsInput(
                    context,
                    'Rounds',
                    timerState.rounds,
                        (rounds) => timerNotifier.setRounds(rounds),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enable sound',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: 10),
                      GFToggle(
                        onChanged: (value) => timerNotifier.toggleSound(),
                        value: timerState.soundEnabled,
                        type: GFToggleType.square,
                        enabledThumbColor: Colors.green,
                        disabledThumbColor: Colors.white38,
                        enabledTrackColor: Colors.green,
                        boxShape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GFButton(
                        onPressed: timerState.isRunning ? null : timerNotifier.start,
                        text: 'Start',
                        shape: GFButtonShape.pills,
                        type: GFButtonType.outline,
                      ),
                      SizedBox(width: 10),
                      GFButton(
                        onPressed: timerState.isRunning ? timerNotifier.pause : null,
                        text: 'Pause',
                        shape: GFButtonShape.pills,
                        type: GFButtonType.outline,
                      ),
                      SizedBox(width: 10),
                      GFButton(
                        onPressed: timerNotifier.reset,
                        text: 'Reset',
                        shape: GFButtonShape.pills,
                        type: GFButtonType.outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Display ProgressOverlay only if running or paused
          if (timerState.isRunning || timerState.isPaused || timerState.currentRound > timerState.rounds)
            ProgressOverlay(
              progress: timerState.isBreak
                  ? (timerState.breakDuration - timerState.remainingTime) / timerState.breakDuration
                  : (timerState.activeDuration - timerState.remainingTime) / timerState.activeDuration,
              isTimerFinished: !timerState.isRunning && timerState.currentRound > timerState.rounds,
              isPaused: timerState.isPaused,
            ),
        ],
      ),
    );
  }

  Widget _buildDurationInput(
      BuildContext context,
      String label,
      int duration,
      void Function(int) onChanged,
      ) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                final newDuration = duration > 0 ? duration - 1 : 0;
                onChanged(newDuration);
              },
            ),
            SizedBox(
              width: 100,
              child: TextField(
                textAlign: TextAlign.center,
                readOnly: true,
                controller: TextEditingController(text: '$minutes:$seconds'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final newDuration = duration + 1;
                onChanged(newDuration);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundsInput(
      BuildContext context,
      String label,
      int rounds,
      void Function(int) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                final newRounds = rounds > 1 ? rounds - 1 : 1;
                onChanged(newRounds);
              },
            ),
            SizedBox(
              width: 100,
              child: TextField(
                textAlign: TextAlign.center,
                readOnly: true,
                controller: TextEditingController(text: '$rounds'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final newRounds = rounds + 1;
                onChanged(newRounds);
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int timeInSeconds) {
    final minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
