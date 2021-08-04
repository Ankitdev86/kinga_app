import 'package:flutter/material.dart';
import 'package:kinga_app/BikeDetailScreen.dart';
import 'package:kinga_app/DashboardScreen.dart';
import 'package:kinga_app/EmergencyContact.dart';
import 'package:kinga_app/KingaProfile.dart';
import 'package:kinga_app/Login.dart';
import 'package:kinga_app/OnboardingScreen.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'dart:async';

import 'package:kinga_app/SignUp.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Just to check bitbucket


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleSession(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Padding(
                padding: EdgeInsets.only(left: 14, right: 14, top: 50),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                              child: Image(image: AssetImage(
                                  "Assets/logo.png"))),
                          SizedBox(
                            height: 80,
                          ),
                          Center(
                              child: Image(
                                image: AssetImage("Assets/bike.png"),
                                height: 380,
                                width: 250,
                                fit: BoxFit.fill,
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                "Ride Bila Stress",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                "Work safely with minimal risk for the rider\nand bike, and run a profitable bodaboda\nbusiness with Kinga.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }


  handleSession(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool Session = preferences.getBool(AppConstants.Session);
    // String UserType = preferences.getString(AppConstants.UserType);

    // print(UserType);

    if (Session == true) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      });
    } else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      });
    }
  }
}