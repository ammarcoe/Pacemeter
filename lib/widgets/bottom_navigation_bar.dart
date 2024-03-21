import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/cric_know.dart';
import 'package:pacemeters/Screens/home_screen.dart';
import 'package:pacemeters/Screens/pace_test.dart';
import 'package:pacemeters/Screens/stats.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavigationBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.grey[900], // Dark grey background color
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: const Icon(Icons.speed),
          label: 'Pace Test',
        ),
        NavigationDestination(
          icon: const Icon(Icons.bar_chart),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: const Icon(Icons.sports_cricket),
          label: 'Cric Know'
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaceTest()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatisticsScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CricKnow()),
            );
            break;
        }
      },
      
    );
  }
}