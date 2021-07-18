import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/ContactList.dart';
import 'package:kinga_app/MakePayment.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';




class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
  
}

class _EmergencyScreenState extends State<EmergencyScreen> {



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
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(
                width: 10,
              ),
              Text(
                "Emergency Contact",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next of Kin",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApp(isCollegue: false, isKin: true,)),
                          );
                        },
                        child: Text(
                          "Add Contact",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Allergies",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApp(isCollegue: true, isKin: false,)),
                          );
                        },
                        child: Text(
                          "Add Contact",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
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
                      "NEXT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentScreen()),
                      );
                    },
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
