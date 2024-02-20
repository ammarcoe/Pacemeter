import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/cric_know.dart';
import 'package:pacemeters/Screens/stats.dart';
import 'package:pacemeters/Screens/pace_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pacemeters/Screens/welcome_screen.dart';

// Home screen widget

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/background_image.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),

          // Pacemeter text at the top
          const Positioned(
            top: 50,
            left: 16,
            child: Text(
              "Pacemeter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // User button at the top right
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Colors.red),
              //   overlayColor: MaterialStateProperty.all(Colors.transparent),
              // ),
              onPressed: () {
                // Show the user profile bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const UserProfileBottomSheet();
                  },
                );
              },
            ),
          ),

          // Centered buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaceTest(),
                      ),
                    );
                  },
                  label: "Pace Test",
                  icon: Icons.speed,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                  label: "Statistics",
                  icon: Icons.bar_chart,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CricKnow(),
                      ),
                    );
                  },
                  label: "CricKnow",
                  icon: Icons.sports_cricket,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileBottomSheet extends StatelessWidget {
  const UserProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Default values if user is not logged in

    // Update values if user is logged in
    if (user != null) {}

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage("assets/SSA.jpg") as ImageProvider<Object>?,
          ),
          const SizedBox(height: 10),
          Text(
            user?.displayName ?? "Guest User",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              // Close the bottom sheet
              // ignore: use_build_context_synchronously
              Navigator.pop(context);

              // Navigate to the WelcomeScreen
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
              );
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}
