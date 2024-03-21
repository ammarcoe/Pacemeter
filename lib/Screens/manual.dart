import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  Duration _releasePoint = Duration.zero;
  Duration _impactPoint = Duration.zero;
  double pitchSize = 17.5; 
  double? _storedPace;// Default pitch size

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/SA.mp4', // Replace with the path to your video file
    )
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 30 / 30,
      autoInitialize: true,
      looping: true,
      allowFullScreen: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  // Future<void> _calculatePaceAndShowDialog(
  //     Duration releasePoint, Duration impactPoint) async {
  //   // Calculate the pace using the difference between release and impact points
  //   Duration timeDifference = impactPoint - releasePoint;

  //   // Ensure that the time difference is positive and non-zero
  //   if (timeDifference.inMicroseconds > 0) {
  //     double paceInMetersPerSecond = pitchSize /
  //         (timeDifference.inMicroseconds / Duration.microsecondsPerSecond);
  //     double paceInKilometersPerHour =
  //         paceInMetersPerSecond * 3600 / 1000; // Convert m/s to km/h

  //     // Show a dialog with the calculated pace
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Ball Pace'),
  //           content: Text(
  //               'The pace of the ball is ${paceInKilometersPerHour.toStringAsFixed(2)} kilometers per hour.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // Show an error dialog if the time difference is not positive and non-zero
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Error'),
  //           content:
  //               Text('Invalid release and impact points. Please try again.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  Future<void> _calculatePaceAndShowDialog(
      Duration releasePoint, Duration impactPoint) async {
    // Calculate the pace using the difference between release and impact points
    Duration timeDifference = impactPoint - releasePoint;

    // Ensure that the time difference is positive and non-zero
    if (timeDifference.inMicroseconds > 0) {
      double paceInMetersPerSecond = pitchSize /
          (timeDifference.inMicroseconds / Duration.microsecondsPerSecond);
      double paceInKilometersPerHour =
          paceInMetersPerSecond * 3600 / 1000; // Convert m/s to km/h

      // Store the pace data in Firestore
      await storePaceData(paceInKilometersPerHour, DateTime.now());

      // Show a dialog with the calculated pace
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ball Pace'),
            content: Text(
                'The pace of the ball is ${paceInKilometersPerHour.toStringAsFixed(1)} kilometers per hour.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error dialog if the time difference is not positive and non-zero
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Invalid release and impact points. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> storePaceData(double pace, DateTime dateTime) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get reference to the user's document in Firestore
        var userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Add pace data to the user's document
        await userDocRef.collection('paces').add({
          'pace': pace,
          'timestamp': dateTime,
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error storing pace data: $e');
        }
      }
    }
  }

  Future<void> _showTimePopup(String title) async {
    // Fetch the current position of the video controller
    Duration currentTime = _controller.value.position;

    // Show a dialog with the current time
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Time: $currentTime'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPitchSizePopup() async {
    TextEditingController pitchSizeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Pitch Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the pitch size (meters):'),
              TextField(
                controller: pitchSizeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pitch Size',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, pitchSizeController.text);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          pitchSize = double.parse(value);
        });
      }
    });
  }

  Future<void> _importVideo() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        _controller = VideoPlayerController.file(File(pickedFile.path))
          ..addListener(() {
            setState(() {});
          })
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {});
          });

        _chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: 30 / 30,
          autoInitialize: true,
          looping: true,
          allowFullScreen: false,
          showControls: true,
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () {
              _importVideo();
            },
            child: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Import Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () {
              _showPitchSizePopup();
            },
            child: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Set Pitch Size',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    var skipDuration = const Duration(milliseconds: 160);
                    _controller
                        .seekTo(_controller.value.position - skipDuration);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous,
                    color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    var skipDuration = const Duration(milliseconds: 20);
                    _controller
                        .seekTo(_controller.value.position - skipDuration);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.skip_next, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    var skipDuration = const Duration(milliseconds: 20);
                    _controller
                        .seekTo(_controller.value.position + skipDuration);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_outlined,
                    color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    var skipDuration = const Duration(milliseconds: 160);
                    _controller
                        .seekTo(_controller.value.position + skipDuration);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    _releasePoint = _controller.value.position;
                  });
                  await _showTimePopup('Release Point Time');
                },
                child: const Text(
                  'Release Point',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    _impactPoint = _controller.value.position;
                  });
                  await _showTimePopup('Impact Point Time');
                },
                child: const Text(
                  'Impact Point',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TextButton(
              onPressed: () {
                _calculatePaceAndShowDialog(_releasePoint, _impactPoint);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text(
                'Calculate Pace',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
