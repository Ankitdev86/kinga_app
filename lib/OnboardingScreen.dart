import 'package:flutter/material.dart';
import 'package:kinga/Login.dart';
import 'package:kinga/SignUp.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 14, right: 14, top: 50),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Center(child: Image(image: AssetImage("Assets/logo.png"))),
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
                            style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              child: Text("sign in".toUpperCase(), style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2C51BE)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2), side: BorderSide(color: Color(0xFF2C51BE))))),
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  )),
                          SizedBox(width: 15),
                          ElevatedButton(
                              child: Text("register".toUpperCase(), style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF2C51BE)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2), side: BorderSide(color: Color(0xFF2C51BE))))),
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  ))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    ));
  }
}
