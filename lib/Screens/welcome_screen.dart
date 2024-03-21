import 'package:flutter/material.dart';
import 'package:pacemeters/widgets/custom_buttons.dart';
import 'package:pacemeters/Screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/PM.png",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Start a journey for what you want to achieve as a cricketer",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    text: 'Get Started',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
