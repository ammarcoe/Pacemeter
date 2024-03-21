import 'package:flutter/material.dart';
import 'package:pacemeters/Screens/home_screen.dart';
import 'package:pacemeters/Screens/manual.dart';
import 'package:pacemeters/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class PaceTest extends StatelessWidget {
  const PaceTest({Key? key}) : super(key: key);
  final int _selectedIndex = 1;

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
            Text(
              'Pacemeter',
              style: GoogleFonts.spaceGrotesk(), // Apply Space Grotesk
            ),
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
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/background_image.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8), // Adjust opacity here
          ),

          // Centered buttons
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material3Button(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoPlayerWidget(),
                      ),
                    );
                    // Handle Manual Test button press
                  },
                  label: "Manual Test",
                  icon: Icons.video_call,
                ),
                const SizedBox(
                  height: 20,
                ),
                Material3Button(
                  onPressed: () {
                    // Show dialog for AI SpeedTest
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("AI Speed Test"),
                          content: const Text("AI Pace Test coming soon"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: "AI SpeedTest",
                  icon: Icons.sports_baseball,
                ),
              ],
            ),
          ),

          // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(selectedIndex: _selectedIndex,),
          ),
        ],
      ),
    );
  }
}

class Material3Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const Material3Button({
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 252, 44, 29)),
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          elevation: MaterialStatePropertyAll<double>(5),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(height: 5),
            Text(
              
              label,
              style: GoogleFonts.spaceGrotesk( // Apply Space Grotesk 
                fontSize: 18,
              ),
            
            ),
          ],
        ),
      ),
    );
  }
}
