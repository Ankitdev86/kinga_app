import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';

class CompletedRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage("Assets/arrow.png"),
                                color: Colors.black,
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "134 KM",
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Riara Road \nNairobi Kenya",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 0.8,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                  color: Colors.green),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width - 120,
                                child: Text(
                                  "Talisman Restaurant\n Nagong Road, Nairobi, Kenya",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1.35,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey,
                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "sarah.DropOff",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Colors.grey,
                                height: 1,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // width: MediaQuery.of(context).size.width ,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.deepOrangeAccent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.double_arrow_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "Complete Trip".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onTap: () {
                                        _showBottomView(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 170,
                      child: FloatingActionButton(
                          backgroundColor: Colors.white60,
                          child: Icon(
                            Icons.shield,
                            color: Colors.black,
                          ),
                          onPressed: () {}),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showBottomView(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 10,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                          color: Colors.black,
                        ),
                      )),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.07),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: ClipOval(
                                                child: Image(
                                                  image: new AssetImage(
                                                      "Assets/Profile Image.png"),
                                                  width: 60,
                                                  height: 60,
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Joshua Ngugi",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                "EuclidCircularA-Bold",
                                              ),
                                            ),
                                            Text(
                                              "Member since 2019",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontFamily:
                                                "EuclidCircularA-Bold",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          "NY000",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "EuclidCircularA-Bold",
                                          ),
                                        ),
                                        Text(
                                          "Yamaha MT-07",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "EuclidCircularA-Bold",
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: Colors.grey,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          color: Colors.blue),
                                      child: Icon(
                                        Icons.navigation_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 0, bottom: 5),
                                            child: Stack(children: <Widget>[
                                              InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 0,
                                                                right: 5),
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width -
                                                                120,
                                                            child: Text(
                                                              "The Language School in Kenya, Chania Ave. Nairobi, Kenya",
                                                              maxLines: 5,
                                                              // "Country*",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'EuclidCircularA-Regular',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ])),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 0, bottom: 10),
                                            child: Text(
                                              "The language school in kenya",
                                              maxLines: 5,
                                              // "Country*",
                                              style: TextStyle(
                                                fontFamily:
                                                'EuclidCircularA-Regular',
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 0),
                                child: Text(
                                  "Your location and bike details will be shared with your emergency contacts.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Change sharing settings.",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              Container(
                                height: 0.5,
                                color: Colors.grey,
                                width: MediaQuery.of(context).size.width,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.redAccent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.double_arrow_sharp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 100,
                                      // ),
                                      InkWell(
                                        child: Text(
                                          "Swipe to text 911".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ));
        });
  }
}
