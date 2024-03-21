// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/home_screen.dart';
// import 'package:pacemeters/widgets/custom_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pacemeters/widgets/custom_buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
      if (_user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add your image here
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.asset(
              'assets/PM.png', // replace with the path to your image
              height: 90, // adjust the height as needed
            ),
          ),
          // Add your text here
          const Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Text(
              'Pacemeter',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Add some spacing between text and button
          CustomButton(
            text: "Sign In with Google",
            onPressed: handleGoogleSignIn,
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return const SizedBox();
  }

  void handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      // await FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
      await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
      // ignore: empty_catches
    } catch (error) {}
  }
}
