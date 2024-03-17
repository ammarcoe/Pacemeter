import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/cric_know.dart';
import 'package:pacemeters/Screens/stats.dart';
import 'package:pacemeters/Screens/pace_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pacemeters/Screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Pacemeter', ),
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
      body: Container(
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/background_image.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 7, 7, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.speed, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaceTest(),
                  ),
                );
              },
            ),
            IconButton(
                      color: Color.fromARGB(255, 255, 254, 254),

              icon: Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
            IconButton(
              color: Color.fromARGB(255, 248, 247, 247),
              
              icon: Icon(Icons.sports_cricket),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CricKnow(),
                  ),
                );
              },
            ),
          ],
        ),
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