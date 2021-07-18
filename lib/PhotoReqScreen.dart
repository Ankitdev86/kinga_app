import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'package:kinga_app/SurePhotoScreen.dart';

class PhotoReqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: IAppBar(
        height: 80,
        color: Color(0xFF2C51BE),
        child: Container(
          margin: const EdgeInsets.only(left: 0, right: 10, top: 20),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(
                width: 10,
              ),
              Text(
                "Take your profile photo",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Photo Requirements",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "1. Show your whole face and tops of your shoulder\n\n2. Take our sunglasses off\n\n3. Take your photo in a well-lit place",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.greenAccent[400],
                          radius: 100,
                          child: Image(image: AssetImage('Assets/close.png'))),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 55,
                color: Color(0xFF2C51BE),
                child: TextButton(
                  child: Text(
                    "TAKE PHOTO",
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
              )),
        ],
      ),
    ));
  }
}
