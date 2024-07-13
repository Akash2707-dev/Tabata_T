import 'package:flutter/material.dart';
import '../screens/step_calculator_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // App Logo and Name
          Center(
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,  // Background color for the DrawerHeader
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),  // Rounded corners at the bottom
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),  // Border around the CircleAvatar
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('https://media.istockphoto.com/id/665421358/vector/muscular-arm-icon.jpg?s=612x612&w=0&k=20&c=4LhJnPcnm1SBeZDrtPvEktjuvYIXGXubO1TMAaFrDXs='),  // Replace with your network image URL
                          radius: 70,  // Reduced the radius to fit within the header
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),  // Adjusted space to reduce overflow
                  Center(
                    child: Text(
                      'Tabata Timer',
                      style: TextStyle(
                        fontSize: 22,  // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,  // Text color
                      ),
                    ),
                  ),
                  SizedBox(height: 4),  // Adjusted space to reduce overflow
                  Center(
                    child: Text(
                      'Your Ultimate Workout Companion',
                      style: TextStyle(
                        fontSize: 14,  // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,  // Lighter text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Drawer options
          Expanded(  // Use Expanded to take up the remaining space and prevent overflow
            child: ListView(
              padding: EdgeInsets.zero,  // Remove the default padding
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.timer, color: Colors.green),  // Icon for Option 1
                  title: Text('Timer'),
                  onTap: () {
                    // Handle Option 1
                  },
                ),
                ListTile(
                  leading: Icon(Icons.sports_martial_arts_sharp, color: Colors.green),  // Icon for Option 2
                  title: Text('Create a Workout'),
                  onTap: () {
                    // Handle Option 2
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share_arrival_time_sharp, color: Colors.green),  // Icon for Option 2
                  title: Text('Reminders'),
                  onTap: () {
                    // Handle Option 2
                  },
                ),
                ListTile(
                  leading: Icon(Icons.directions_run_sharp, color: Colors.green),  // Icon for Step Calculator
                  title: Text('Step Calculator'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StepCalculatorScreen()),  // Navigate to StepCalculatorScreen
                    );
                  },
                ),

                // Add more options as needed
              ],
            ),
          ),
          // Footer decoration
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),  // Very faint tint of green
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),  // Rounded corners at the top
            ),
            child: Column(
              children: [
                Text(
                  'Stay Motivated!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,  // Darker text color for contrast
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Push yourself, because no one else is going to do it for you!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,  // Darker text color for contrast
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Decorative element
                Image.network(
                  'https://img.icons8.com/?size=100&id=9853&format=png&color=000000',  // Replace with your decorative image URL
                  height: 50,  // Adjust height as needed
                  color: Colors.green,  // Apply faint tint of green
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
