import 'package:flutter/material.dart';
import 'package:kinga_app/BikeDetailScreen.dart';

class SurePhotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.greenAccent[400],
                          radius: 100,
                          child: Image(image: AssetImage('Assets/close.png'))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Want to use this photo",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 55,
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // color: Color(0xFF2C51BE),
                          child: TextButton(
                            child: Text(
                              "RETAKE",
                              style: TextStyle(
                                  color: Color(0xFF2C51BE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BikeDetail()),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 55,
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          color: Color(0xFF2C51BE),
                          child: TextButton(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SurePhotoScreen()),
                              );
                            },
                          ),
                        )
                      ],
                    )),
              ],
            )));
  }
}
