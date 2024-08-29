import 'package:cred_assignment/screens/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neopop/neopop.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/home_image.png',
              scale: 1.3,
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'CRED mint',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'grow your savings. \n3x faster',
              style: TextStyle(
                fontFamily: 'Cirka',
                color: Colors.white,
                fontSize: 26,
                height: 1.2,
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            NeoPopButton(
              color: Colors.white,
              onTapUp: () {
                HapticFeedback.vibrate();
                Navigator.push(
                  context,
                  ExploreScreen.route(),
                );
              },
              onTapDown: () => HapticFeedback.vibrate(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Go to category  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/Button arrow.svg',
                    ),
                    // Image.asset(
                    //   'assets/images/button_arrow.png',
                    //   scale: .9,
                    //   color: Colors.black,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
