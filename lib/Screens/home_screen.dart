import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pacemeters/Screens/welcome_screen.dart';
import 'package:pacemeters/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);
   int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(selectedIndex:   _selectedIndex ),
          ),
        ],
      ),
    );
  }
}

class UserProfileBottomSheet extends StatelessWidget {
  const UserProfileBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
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
