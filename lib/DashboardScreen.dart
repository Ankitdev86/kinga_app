import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/CompleteRide.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool status = false;
  String title = "Offline";
  Position position;
  GoogleMapController _controller;
  Widget _child;

  @override
  void initState() {
    // TODO: implement initState

    getCurrentLocation();
    super.initState();
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  TextEditingController textEditingController_firstname =
      TextEditingController();

  //Change Switch Status
  void changeStatus() {
    if (status == false) {
      title = "Offline";
    } else {
      title = "Online";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: IAppBar(
        height: 80,
        color: Color(0xFF2C51BE),
        child: Container(
          margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        child: GestureDetector(
                            onTap: () {},
                            child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "EuclidCircularA-Bold",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: CustomSwitch(
                  activeColor: Colors.green,
                  value: status,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      status = value;
                      changeStatus();
                      // phoneNo = input;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
                child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: _child,
            )),
            Positioned(
              bottom: 15,
              left: 20,
              right: 20,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green,
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
                        "Start Trip".toUpperCase(),
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
            ),
            Positioned(
              right: 20,
              bottom: 100,
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
      ),
    ));
  }

  Widget mapWidget() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15.0),
      mapType: MapType.normal,
      markers: createMarker(),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
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
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {},
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
                                margin: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Talisman Restaurant ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    "EuclidCircularA-Bold",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            "54 km",
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
                                            "Total Distance",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  "EuclidCircularA-Bold",
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                              ),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: TextFormField(
                                  controller: textEditingController_firstname,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontFamily: 'EuclidCircularA-Regular',
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontFamily: 'EuclidCircularA-Light',
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                    hintText: 'Passenger Name',
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, bottom: 10),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 0, bottom: 10),
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
                                                            width: 45,
                                                            child: Text(
                                                              "KE+254",
                                                              // "Country*",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'EuclidCircularA-Regular',
                                                                fontSize: 12,
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
                                        SizedBox(
                                          width: 100,
                                          child: new Center(
                                            child: new Container(
                                              margin: new EdgeInsetsDirectional
                                                      .only(
                                                  start: 20, end: 0, bottom: 5),
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        margin: const EdgeInsets.only(
                                            left: 0, right: 10, top: 0),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            cursorColor: Colors.red,
                                            hintColor: Colors.greenAccent,
                                          ),
                                          child: TextFormField(
                                            controller:
                                                textEditingController_firstname,
                                            maxLength: 10,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                            // inputFormatters: [
                                            //   WhitelistingTextInputFormatter
                                            //       .digitsOnly
                                            // ],
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontFamily:
                                                    'EuclidCircularA-Regular',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                              hintText: 'Mobile Number',
                                              counterText: "",
                                              contentPadding:
                                                  EdgeInsets.only(left: 20.0),
                                            ),
                                            onChanged: (text) {
                                              print("onChanged: $text");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 0),
                              ),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: TextFormField(
                                  controller: textEditingController_firstname,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontFamily: 'EuclidCircularA-Regular',
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontFamily: 'EuclidCircularA-Light',
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                    hintText: 'Trip Cost(Ksh)',
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, bottom: 10),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height: 45,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Container(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 0,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                )),
                                            color: Colors.white,
                                            highlightColor: Colors.white,
                                            splashColor:
                                                Colors.blue.withAlpha(100),
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "EuclidCircularA-SemiBold",
                                                    fontSize: 14,
                                                    letterSpacing: 1,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height: 45,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Container(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 0,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                )),
                                            color: Colors.lightGreen,
                                            highlightColor: Colors.white,
                                            splashColor:
                                                Colors.blue.withAlpha(100),
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompletedRide()),
                                              );
                                            },
                                            child: Center(
                                              child: Text(
                                                "START TRIP",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "EuclidCircularA-SemiBold",
                                                    fontSize: 14,
                                                    letterSpacing: 1,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ));
        });
  }

  Set<Marker> createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId("home"),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Current location")),
    ].toSet();
  }

  Future getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      position = pos;
      _child = mapWidget();
    });
  }
}
