import 'package:flutter/material.dart';
import 'package:vezer/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Discover The\n Weather In Your City',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                "assets/9579644e-70b2-452e-a28d-bbd1b13bf3bf_removalai_preview.png",
              ),
              Spacer(),
              Center(
                child: Text(
                  'Get to know your weather maps and\n radar recipitations forcast',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    // fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color: Colors.white60,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                    child: Text('Get Started',style:TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
