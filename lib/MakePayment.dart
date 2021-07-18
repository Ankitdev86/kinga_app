import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';

class PaymentScreen extends StatelessWidget {
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
                "Make Payments",
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
                        "STK Push",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_sharp),
                        onPressed: () {},
                        iconSize: 20,
                        color: Colors.grey,
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
                        "Paybill",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_sharp),
                        onPressed: () {},
                        iconSize: 20,
                        color: Colors.grey,
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => PersonalDetail()),
                      // );
                    },
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
