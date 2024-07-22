import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/step_counter_provider.dart';
import '../assets/metric_card.dart';

class StepCalculatorScreen extends ConsumerWidget {
  // Constants for distance and calories calculations
  static const double _stepLengthInMeters = 0.762;  // Average step length in meters
  static const double _caloriesPerStep = 0.04;     // Average calories burned per step

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepCounterState = ref.watch(stepCounterProvider);
    final stepCounterNotifier = ref.read(stepCounterProvider.notifier);

    // Calculate distance and calories
    double distanceInMeters = stepCounterState.stepCount * _stepLengthInMeters;
    double caloriesBurned = stepCounterState.stepCount * _caloriesPerStep;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // Change back button color to black
        title: Text(
          'Step Calculator',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Step Count Display
            Center(
              child: Column(
                children: [
                  Text(
                    'Step Count',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${stepCounterState.stepCount}',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Distance and Calories Information
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MetricCard(
                    title: 'Distance Covered',
                    value: '${distanceInMeters.toStringAsFixed(2)} meters',
                  ),
                  MetricCard(
                    title: 'Calories Burned',
                    value: '${caloriesBurned.toStringAsFixed(2)} kcal',
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: stepCounterState.isRunning || stepCounterState.isPaused
                      ? null
                      : () {
                    stepCounterNotifier.startCounting();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: stepCounterState.isRunning && !stepCounterState.isPaused
                      ? () {
                    stepCounterNotifier.pauseCounting();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: !stepCounterState.isRunning
                      ? () {
                    stepCounterNotifier.resetCounting();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
