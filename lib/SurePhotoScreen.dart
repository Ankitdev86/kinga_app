import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kinga_app/BikeDetailScreen.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'package:kinga_app/Utils/global.dart';

class SurePhotoScreen extends StatefulWidget {
  File profileImage ;
  bool isFileUploaded;

  SurePhotoScreen({this.profileImage, this.isFileUploaded});

  @override
  _SurePhotoScreenState createState() => _SurePhotoScreenState();
}

class _SurePhotoScreenState extends State<SurePhotoScreen> {
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
                      child: widget.isFileUploaded ? Container(
                          height : 200,width:200,
                          margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blueGrey[100], //                   <--- border color
                                width: 2,
                              ),
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image:  FileImage(widget.profileImage)
                              )
                          )) :

                      CircleAvatar(
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
                              Navigator.of(context).pop();
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
                                uploadedImage = widget.profileImage;
                                if (isBikeDetail) {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => BikeDetail(false),
                                    ),
                                  );

                                } else {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => PersonalDetail(false),
                                    ),
                                  );

                                }
                              }
                          ),
                        )
                      ],
                    )),
              ],
            )));
  }
}
