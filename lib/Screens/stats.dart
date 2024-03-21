import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pacemeters/Screens/home_screen.dart';
import 'package:pacemeters/widgets/bottom_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({super.key});
  final _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
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
       Text('Pacemeter',
      style: GoogleFonts.spaceGrotesk(),),
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
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: _selectedIndex),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            color: Colors.black.withOpacity(0.9),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage("assets/SSA.jpg")
                            as ImageProvider<Object>?,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.displayName ?? "",
                    style:  GoogleFonts.spaceGrotesk( color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,)
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   Text(
                    "Your Pace History",
                    style: GoogleFonts.spaceGrotesk(
                       color: Colors.white,
                      fontSize: 22,
                    )
                  ),
                  const SizedBox(height: 30),
                  const PaceLineChart(),
                  const SizedBox(height: 20),
                  const SpeedBoxes(),
                  const SizedBox(height: 20),
                  const TopDeliveries(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaceLineChart extends StatelessWidget {
  const PaceLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('paces')
      .orderBy('timestamp', descending: true)
      .snapshots(),
  builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      var paces = snapshot.data!.docs;
      List<FlSpot> paceData = [];
      for (var i = 0; i < paces.length; i++) {
        var paceDoc = paces[i];
        var paceDataMap = paceDoc.data() as Map;
        paceData.add(FlSpot(i.toDouble(), paceDataMap["pace"]));
      }
      return AspectRatio(
        aspectRatio: 1.8,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: paceData,
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                isStrokeCapRound: false,
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black,
                tooltipRoundedRadius: 2,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  },
);
  }
}

class SpeedBoxes extends StatelessWidget {
  const SpeedBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('paces')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var paces = snapshot.data!.docs;
          double totalSpeed = 0;
          double highestSpeed = 0;

          for (var paceDoc in paces) {
            var paceData = paceDoc.data() as Map<String, dynamic>;
            double pace = paceData["pace"];
            totalSpeed += pace;

            if (pace > highestSpeed) {
              highestSpeed = pace;
            }
          }

          double averageSpeed = totalSpeed / paces.length;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSpeedBox("Average Speed" , averageSpeed),
              _buildSpeedBox("Highest Speed", highestSpeed),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSpeedBox(String label, double speed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            "$label",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${speed.toStringAsFixed(1)} km/hr",
            style: GoogleFonts.spaceGrotesk(color: Colors.white,
              fontSize: 20,)
          ),
        ],
      ),
    );
  }
}

class TopDeliveries extends StatelessWidget {
  const TopDeliveries({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('paces')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var paces = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: paces.map((paceDoc) {
                var paceData = paceDoc.data() as Map<String, dynamic>;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        "${paceData["pace"].toStringAsFixed(1)} km/hr",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('MMM d, y')
                            .format(paceData["timestamp"].toDate()),
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[500],
                          fontSize: 16,)
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}