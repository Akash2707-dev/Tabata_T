import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // App Logo and Name
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,  // Background color for the DrawerHeader
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),  // Rounded corners at the bottom
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://media.istockphoto.com/id/665421358/vector/muscular-arm-icon.jpg?s=612x612&w=0&k=20&c=4LhJnPcnm1SBeZDrtPvEktjuvYIXGXubO1TMAaFrDXs='),  // Replace with your network image URL
                    radius: 30,  // Reduced the radius to fit within the header
                    backgroundColor: Colors.white,  // Background color for the CircleAvatar
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),  // Border around the CircleAvatar
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('https://media.istockphoto.com/id/665421358/vector/muscular-arm-icon.jpg?s=612x612&w=0&k=20&c=4LhJnPcnm1SBeZDrtPvEktjuvYIXGXubO1TMAaFrDXs='),  // Replace with your network image URL
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
                  leading: Icon(Icons.directions_run, color: Colors.green),  // Icon for Option 2
                  title: Text('Create a Workout'),
                  onTap: () {
                    // Handle Option 2
                  },
                ),
                // Add more options as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
