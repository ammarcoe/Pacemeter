import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pacemeters/Screens/splash_screen.dart';
// import 'package:pacemeters/provider/auth_provider.dart';
import 'firebase_options.dart';
// import 'package:pacemeters/Screens/welcome_screen.dart';
// import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //provide multile providers
      // providers: [
      //   ChangeNotifierProvider(
      //       create: (_) =>
      //           AuthProvider()) //change notifiers is a providerw hich is soecifically used for auth
      // ],

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: "PaceMeter",
    );
  }
}
