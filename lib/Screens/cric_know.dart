import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/pace_test.dart';
import 'package:pacemeters/Screens/stats.dart';
import 'package:pacemeters/widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';

class CricKnow extends StatelessWidget {
  CricKnow({super.key});
  final int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/PM.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('Pacemeter'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const UserProfileBottomSheet();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to the Fast Bowling Drill/Exercises screen
              },
              child: CardWidget(
                title: 'Fast Bowling Drill/Exercises',
                imagePath: 'assets/fast_bowling_image.jpg',
                width: 300,
                height: 220,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to the Spinners Drills/Exercises screen
              },
              child: CardWidget(
                title: 'Spinners Drills/Exercises',
                imagePath: 'assets/spinners_image.jpg',
                width: 300,
                height: 220,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey[800],
      elevation: 4,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.asset(
                imagePath,
                height: height - 50,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}