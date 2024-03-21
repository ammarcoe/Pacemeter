import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pacemeters/Screens/welcome_screen.dart';
import 'package:pacemeters/widgets/bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pacemeters/Screens/pace_test.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<String> imageUrls = [
    'https://images.hindustantimes.com/img/2022/05/20/1600x900/image_-_2022-05-20T175125.385_1653049289821_1653049294581.jpg',
    'https://images.hindustantimes.com/img/2022/09/03/1600x900/CRICKET-AUS-ZIM-16_1662185254028_1662185254028_1662185398002_1662185398002.jpg',
    'https://images.hindustantimes.com/rf/image_size_960x540/HT/p2/2020/08/14/Pictures/_8461ac18-dde5-11ea-a97c-4447400c36de.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = 0;
    User? user = FirebaseAuth.instance.currentUser;

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
              style: GoogleFonts.spaceGrotesk(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text(
                      'Welcome ${user?.displayName ?? "Guest User"}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: imageUrls.length,
                    options: CarouselOptions(
                      height: 230,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      viewportFraction: 0.9,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final imageUrl = imageUrls[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Calculate your Pace here',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          
                          style: ButtonStyle(
                            
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaceTest(),
                              ),
                            );
                          },
                          child: Text(
                            'PaceTest',
                            style: GoogleFonts.spaceGrotesk(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
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
            style: GoogleFonts.spaceGrotesk(

              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ) 
              
              
            
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
            child: Text(
              "Sign Out",
              style: GoogleFonts.spaceGrotesk(),
            ),
          ),
        ],
      ),
    );
  }
}
