import 'dart:convert';
import 'dart:io';

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/BikeDetailScreen.dart';
import 'package:kinga_app/CompleteRide.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinga_app/Data/API.dart';
import 'package:kinga_app/Data/BikeDetailResponse.dart';
import 'package:kinga_app/Data/KingaProfileResponse.dart';
import 'package:kinga_app/Data/StartTripModel.dart';
import 'package:kinga_app/Data/get_user_name_image_response.dart';
import 'package:kinga_app/Data/start_trip_response.dart';
import 'package:kinga_app/EmergencyContact.dart';
import 'package:kinga_app/Login.dart';
import 'package:kinga_app/MakePayment.dart';
import 'package:kinga_app/OnboardingScreen.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'package:kinga_app/StartTripPage.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinga_app/KingaProfile.dart';
import 'Utils/CustomPlacePicker/src/place_picker.dart';
import 'Utils/custom_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:kinga_app/Utils/SHDF.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool status = false;
  String title = "Offline";
  String geoocationLattitude = "";
  String geoocationLongitude = "";
  GoogleMapController _controller;
  Widget _child;
  Location location;

  @override
  void initState() {
    // TODO: implement initState
    setIcon();
    getCurrentLocation();

    super.initState();
    redirectUser();
  }

  Future<void> redirectUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool personalDetail = preferences.getBool(AppConstants.personalDetail);
    bool bikeDetail = preferences.getBool(AppConstants.bikeDetail);
    bool kingaprofile = preferences.getBool(AppConstants.kingaProfile);
    bool kinStatus = preferences.getBool(AppConstants.emergencyContact);
    bool colleagueStatus = preferences.getBool(AppConstants.collegueContact);

    if (personalDetail == false) {
      Alert(context: context, title: "", desc: "Please complete your profile",
          // image: Image.asset("Assets/success.png"),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonalDetail(false)),
              ),
              color: Color(0xFF2C51BE),
              radius: BorderRadius.circular(5.0),
            ),
          ]).show();
    } else if (bikeDetail == false) {
      Alert(context: context, title: "", desc: "Please complete your profile",
          // image: Image.asset("Assets/success.png"),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BikeDetail(false)),
              ),
              color: Color(0xFF2C51BE),
              radius: BorderRadius.circular(5.0),
            ),
          ]).show();
    } else if (kingaprofile == false) {
      Alert(context: context, title: "", desc: "Please complete your profile",
          // image: Image.asset("Assets/success.png"),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KingaProfileScreen(false)),
              ),
              color: Color(0xFF2C51BE),
              radius: BorderRadius.circular(5.0),
            ),
          ]).show();
    } else if (kinStatus == false && colleagueStatus == false) {
      Alert(context: context, title: "", desc: "Please complete your profile",
          // image: Image.asset("Assets/success.png"),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyScreen(false)),
              ),
              color: Color(0xFF2C51BE),
              radius: BorderRadius.circular(5.0),
            ),
          ]).show();
    }
  }

  TextEditingController textEditingController_firstname = TextEditingController();

  //Change Switch Status
  Future<void> changeStatus() async {
    if (status == false) {
      title = "Offline";
    } else {
      title = "Online";
    }
    _child = await mapWidget();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2C51BE)),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios_rounded),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blueGrey[100], //                   <--- border color
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: AssetImage('Assets/Profile Image.png'),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myName,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              myBikeName,
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
          // Divider(
          //   color: Colors.grey,
          //   height: 1,
          // ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/profile.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Kinga Profile",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => KingaProfileScreen(true)));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/personal-details.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Personal Details",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PersonalDetail(true)));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/bike-details.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Bike Details",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BikeDetail(true)));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/emergency-contacts.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Emergency Contacts",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EmergencyScreen(true)));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/reports.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Reports",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileView()));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/payments-setup.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Payment Setup",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PaymentScreen()));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/help.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Help",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileView()));
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          ListTile(
              leading: Image(
                image: AssetImage('Assets/logout.png'),
                color: Colors.grey,
                height: 25,
                width: 25,
              ),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(context);

                showLogoutDialog();
              }),
          Divider(
            color: Colors.grey,
            height: 1,
          )
        ],
      )),
      appBar: AppBar(
        //height: 80,
        backgroundColor: Color(0xFF2C51BE),
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 10, top: 0),
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
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 5,
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
      body: WillPopScope(
          onWillPop: () {
            showExitAppDialog();
          },
          child: Container(
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
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.double_arrow_sharp,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Start Trip".toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (status == false) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context1) => OKDialogBox(
                                  title: "Please change status online first",
                                  description: "",
                                  my_context: context,
                                ));
                      } else {
                        chooselocation();
                      }

                      // show input autocomplete with selected mode
                      // then get the Prediction selected
                    },
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 100,
                  child: Column(
                    children: [
                      Card(
                          color: Colors.white60,
                          margin: EdgeInsets.only(left: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          elevation: 25,
                          child: InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 00, left: 0, right: 0, top: 0),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white60,
                                  height: 50, // height of the button
                                  width: 50, // width of the button
                                  child: Center(
                                    child: Image.asset(
                                      'Assets/location.png',
                                      width: 25,
                                      height: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {

                              if (progressDialog == false) {
                                progressDialog = true;
                                _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
                              }
                              
                              location = new Location();
                              currentLocation = await location.getLocation();

                              print("latt ---" + currentLocation.latitude.toString());
                              print("longg ---" + currentLocation.longitude.toString());

                              geoocationLattitude = currentLocation.latitude.toString();
                              geoocationLongitude = currentLocation.longitude.toString();

                              createMarker();
                              _progressDialog.dismissProgressDialog(context);
                              progressDialog = false;

                              try {
                                Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      if (_controller != null) {
                                        
                                        _controller.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(currentLocation.latitude,
                                                    currentLocation.longitude),
                                                zoom: 15),
                                          ),
                                        );
                                      }
                                    });
                              } catch (e) {
                                
                              }
                            },
                          )),
                      FloatingActionButton(
                          backgroundColor: Colors.white60,
                          child: Icon(
                            Icons.shield,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _showBottomView(context);
                          }),
                    ],
                  ),
                )
              ],
            ),
          )),
    ));
  }

  BitmapDescriptor sourceIcon;
  BitmapDescriptor myIcon;

  void setIcon() async {
    //
    //
    // BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(30, 30), devicePixelRatio: 2.5),
    //     'assets/images/map_logo.png')
    //     .then((onValue) {
    //   sourceIcon = onValue;
    // });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60, 60), devicePixelRatio: 2.5), 'Assets/navigation.png').then((onValue) {
      myIcon = onValue;
    });

    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(15, 15), devicePixelRatio: 2.5), 'assets/images/my_location_icon.png').then((onValue) {
    //   myCurrentIcon = onValue;
    // });
  }

  Future<Widget> mapWidget() async {
    if (currentLocation == null) {
      location = new Location();
      currentLocation = await location.getLocation();
    }
    if (status == false) {
      return GoogleMap(
        key: Key("1234"),
        initialCameraPosition: CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15.0),
        mapType: MapType.normal,
        //markers:createBlankMarker(),
        myLocationEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      );
    } else {
      return GoogleMap(
        key: Key("4321"),
        initialCameraPosition: CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15.0),
        mapType: MapType.normal,
        markers: createMarker(),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15.0),
      mapType: MapType.normal,
      markers: createMarker(),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  String myProfileImnage = "";
  String myName = "";
  String myBikeYear = "";
  String myBikeModel = "";
  String myBikeName = "";
  String myCurrentAddress = "";
  String myCurrentAddressPlace = "";
  LocationData currentLocation;

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
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      height: 60,
                                      width: 60,
                                      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blueGrey[100], //                   <--- border color
                                            width: 2,
                                          ),
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(myProfileImnage),
                                          ))),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                myName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Member since ${myBikeYear}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 20),
                                              child: Text(
                                                "${myBikeModel}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: 20),
                                              child: Text(
                                                myBikeName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
                                      child: Icon(
                                        Icons.navigation_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 10, top: 0, bottom: 5),
                                            child: Stack(children: <Widget>[
                                              InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 20),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin: const EdgeInsets.only(top: 0, right: 5),
                                                            width: MediaQuery.of(context).size.width - 120,
                                                            child: Text(
                                                              myCurrentAddress,
                                                              maxLines: 5,
                                                              // "Country*",
                                                              style: TextStyle(
                                                                fontFamily: 'EuclidCircularA-Regular',
                                                                fontSize: 14,
                                                                color: Colors.black,
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
                                            margin: EdgeInsets.only(left: 10, top: 0, bottom: 10),
                                            child: Text(
                                              myCurrentAddressPlace,
                                              maxLines: 5,
                                              // "Country*",
                                              style: TextStyle(
                                                fontFamily: 'EuclidCircularA-Regular',
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
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
                                child: Text(
                                  "Your location and bike details will be shared with your emergency contacts.",
                                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Change sharing settings.",
                                      style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.w500),
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
                                        padding: const EdgeInsets.only(left: 10),
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
                                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
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

  Set<Marker> createMarker() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60, 60), devicePixelRatio: 2.5), 'Assets/navigation.png').then((onValue) {
      myIcon = onValue;
    });

    return <Marker>[
      Marker(markerId: MarkerId("home"), position: LatLng(currentLocation.latitude, currentLocation.longitude), icon: myIcon, infoWindow: InfoWindow(title: "Current location")),
    ].toSet();
  }

  Set<Marker> createBlankMarker() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 30), devicePixelRatio: 2.5), 'Assets/navigation.png').then((onValue) {
      myIcon = onValue;
    });

    return <Marker>[
      Marker(
          markerId: MarkerId("home"), position: LatLng(currentLocation.latitude, currentLocation.longitude), icon: BitmapDescriptor.defaultMarker, infoWindow: InfoWindow(title: "Current location")),
    ].toSet();
  }

  Future getCurrentLocation() async {
    location = new Location();

    currentLocation = await location.getLocation();
    _child = await mapWidget();
    setState(() {});
    final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);

    var myaddressTmp = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = myaddressTmp.first;
    myaddress = first.addressLine;
  }

  chooselocation() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return PlacePicker(
          //apiKey: "AIzaSyAL8L6GyWVCOyb8pfVMRJ_BQ3YcdVC3-PY",
          apiKey: kGoogleApiKey,
          initialPosition: LatLng(currentLocation.latitude, currentLocation.longitude),
          useCurrentLocation: true,

          usePlaceDetailSearch: true,

          hintText: "Enter drop location",

          onPlacePicked: (result) async {
            final coordinates = new Coordinates(result.geometry.location.lat, result.geometry.location.lng);
            var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var first = addresses.first;
            print("${first.countryName} : ${first.addressLine}");
            String country = first.countryName;
            //selectedPickupLat = result.geometry.location.lat.toString();
            //selectedPickupLang = result.geometry.location.lng.toString();
            // selectedLocation = first.addressLine;

            setState(() {});

            double distanceInMeters = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, result.geometry.location.lat, result.geometry.location.lng);

            double distanceInKm = distanceInMeters / 1000;

            startLatt = currentLocation.latitude;
            startLng = currentLocation.longitude;
            dropLatt = result.geometry.location.lat;
            dropLng = result.geometry.location.lng;

            // Navigator.pop(context,true);
            Navigator.pop(context);
            getProfileData(result.addressComponents[0].shortName, first.addressLine, distanceInKm.toStringAsFixed(2));

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => StartTripPage(selectedAddress:addresses[0].addressLine)),
            // );
          },
        );
      },
    ));
  }

  ProgressDialog _progressDialog = ProgressDialog();

  Future getProfileData(String shortAddress, String address, String km) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');
    print(API.get_kinga_profile);

    Map map = {
      "user_id": user_id,
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await getKingaProfile(API.getUserNameImage, map, context, shortAddress, address, km);
  }

  Future<http.Response> getKingaProfile(String url, Map jsonMap, BuildContext context, String shortAddress, String address, String km) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) {
        final int statusCode = response.statusCode;
        print(response);
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          print(statusCode);
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                    title: 'Check your internet connections and settings !',
                    description: "",
                    my_context: context,
                  ));

          throw new Exception("Error while fetching data");
        } else {
          print(response.body);
          GetUserNameImageResponse responseData = new GetUserNameImageResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          print(responseData.name);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            setState(() {
              //wristbandTF.text = responseData.kingaProfileDetails.wristBandNo;
              // confwristbandTF.text = responseData.kingaProfileDetails.wristBandNo;
              // bloodGroup = responseData.kingaProfileDetails.bloodGroup;
              // allergy = responseData.kingaProfileDetails.allergy;
              // insurer = responseData.kingaProfileDetails.insurer;
              // policyTF.text = responseData.kingaProfileDetails.policyNo;
              // nhifTF.text = responseData.kingaProfileDetails.nHIFNo;
              String networkimage = API.baseUrl + responseData.image;

              sendBikeDetail(shortAddress, address, responseData.name, networkimage, km);
            });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                      title: '' + responseData.msg,
                      description: "",
                      my_context: context,
                    ));
          }
        }
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: e.toString(),
                description: "",
                my_context: context,
              ));
    }
    return responseInternet;
  }

  Future sendBikeDetail(String shortAddress, String address, String username, String profileImage, String km) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');

    Map map = {
      "user_id": user_id,
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await getBikeDetail(API.get_bike_details, map, context, shortAddress, address, username, profileImage, km);
  }

  String year = "";
  String bikeName = "";
  String modelnumber = "";

  Future<http.Response> getBikeDetail(String url, Map jsonMap, BuildContext context, String shortAddress, String address, String username, String profileImage, String km) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) {
        final int statusCode = response.statusCode;
        print(response);
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          print(statusCode);
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                    title: 'Check your internet connections and settings !',
                    description: "",
                    my_context: context,
                  ));

          throw new Exception("Error while fetching data");
        } else {
          print(response.body);
          GetBikeData responseData = new GetBikeData();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            year = responseData.bikeDetails.year;
            bikeName = responseData.bikeDetails.numberPlate;
            modelnumber = responseData.bikeDetails.model;

            showStartTripDialog(shortAddress, address, username, profileImage, km);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                      title: '' + responseData.msg,
                      description: "",
                      my_context: context,
                    ));
          }
        }
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: e.toString(),
                description: "",
                my_context: context,
              ));
    }
    return responseInternet;
  }

  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhoneNo = TextEditingController();
  TextEditingController txtCost = TextEditingController();

  double startLatt = 0.0;
  double startLng = 0.0;
  double dropLatt = 0.0;
  double dropLng = 0.0;

  void showStartTripDialog(String shortAddress, String address, String username, String profileImage, String km) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context1, setState1) {
            return Wrap(children: <Widget>[
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 3.0),
                              borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                  ),
                            ),
                            //color: Colors.white,
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset(
                              "Assets/back.png",
                              fit: BoxFit.contain,
                              color: Colors.black,
                              height: 25,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context1);
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only()),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Row(
                            children: [
                              Container(
                                  height: 60,
                                  width: 60,
                                  margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blueGrey[100], //                   <--- border color
                                        width: 2,
                                      ),
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(profileImage),
                                      ))),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            username,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Member since ${year}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            "${modelnumber}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            bikeName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              shortAddress,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              address,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            "${km} KM",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            "Total Distance",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                            child: TextField(
                              controller: txtName,
                              // obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Passenger First Name',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "KE +254",
                                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: txtPhoneNo,
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                            child: TextField(
                              controller: txtCost,
                              keyboardType: TextInputType.number,
                              // obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Trip Cost (Ksh)',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: 45,
                                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Container(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                                                borderRadius: BorderRadius.circular(
                                                  5,
                                                )),
                                            color: Colors.white,
                                            highlightColor: Colors.white,
                                            splashColor: Colors.blue.withAlpha(100),
                                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                            onPressed: () {
                                              Navigator.pop(context1);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(fontFamily: "EuclidCircularA-SemiBold", fontSize: 14, letterSpacing: 1, color: Colors.blue),
                                              ),
                                            ),
                                          ),
                                        )),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: 45,
                                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Container(
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.black, width: 0, style: BorderStyle.solid),
                                                borderRadius: BorderRadius.circular(
                                                  5,
                                                )),
                                            color: Colors.lightGreen,
                                            highlightColor: Colors.white,
                                            splashColor: Colors.blue.withAlpha(100),
                                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                            onPressed: () {
                                              if (txtName.text == "") {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context1) => OKDialogBox(
                                                          title: 'Please Enter Name',
                                                          description: "",
                                                          my_context: context,
                                                        ));
                                              } else if (txtPhoneNo.text == "") {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context1) => OKDialogBox(
                                                          title: 'Please Enter Phone Number',
                                                          description: "",
                                                          my_context: context,
                                                        ));
                                              } else if (txtCost.text == "") {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context1) => OKDialogBox(
                                                          title: 'Please Enter Cost',
                                                          description: "",
                                                          my_context: context,
                                                        ));
                                              } else {
                                                StartTripModel model = new StartTripModel();
                                                model.dropAddress = address;
                                                model.dropShortAddress = shortAddress;
                                                model.myName = username;
                                                model.km = km;
                                                model.passangerName = txtName.text;
                                                model.passangerPhone = txtPhoneNo.text;
                                                model.passangerCost = txtCost.text;
                                                model.startLatt = startLatt;
                                                model.startLng = startLng;
                                                model.dropLatt = dropLatt;
                                                model.dropLng = dropLng;
                                                model.bikeYear = year;
                                                model.bikeModel = modelnumber;
                                                model.bikeName = bikeName;
                                                model.profileImage = profileImage;

                                                Navigator.pop(context1);

                                                startTrip(model);
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                "Start Trip",
                                                style: TextStyle(fontFamily: "EuclidCircularA-SemiBold", fontSize: 14, letterSpacing: 1, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              new SizedBox(
                                height: MediaQuery.of(context).size.height * 0.02,
                              ),
                            ],
                          ),
                          new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]);
          });
        });
  }

  String myaddress = "";

  Future startTrip(StartTripModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');

    Map map = {
      "user_id": user_id,
      "passenger_name": model.passangerName,
      "from_address": myaddress,
      "from_lat": model.startLng.toString(),
      "from_long": model.startLng.toString(),
      "to_address": model.dropAddress,
      "to_lat": model.dropLatt.toString(),
      "to_long": model.dropLng.toString(),
      "price": model.passangerCost,
      "phone_no": model.passangerPhone,
      "distance": model.km + " KM"
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await startTriprequestCall(API.startTrip, map, context, model);
  }

  Future<http.Response> startTriprequestCall(String url, Map jsonMap, BuildContext context, var model) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) {
        final int statusCode = response.statusCode;
        print(response);
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          print(statusCode);
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                    title: 'Check your internet connections and settings !',
                    description: "",
                    my_context: context,
                  ));

          throw new Exception("Error while fetching data");
        } else {
          print(response.body);
          StartTripResponse responseData = new StartTripResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            String tripId = responseData.tripId;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompletedRide(model: model, tripId: tripId)),
            );
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                      title: '' + responseData.msg,
                      description: "",
                      my_context: context,
                    ));
          }
        }
      });
    } catch (e) {
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: e.toString(),
                description: "",
                my_context: context,
              ));
    }
    return responseInternet;
  }

  void showExitAppDialog() {
    showDialog(
      context: context,
      builder: (context1) {
        return StatefulBuilder(
          builder: (context1, setState) {
            return AlertDialog(
              title: Text(
                "Exit!",
                style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'seg'),
              ),
              content: Text(
                "Sure you want to Exit?",
                style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'seg'),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context1).pop();
                      },
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          //height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF2C51BE),
                                Color(0xFF2C51BE),
                                Color(0xFF2C51BE),
                              ],
                            ),
                          ),
                          child: Center(
                            child: new Text("No", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'seg')),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.of(context1).pop();
                          exit(1);
                        });
                      },
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          //height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF2C51BE),
                                Color(0xFF2C51BE),
                                Color(0xFF2C51BE),
                              ],
                            ),
                          ),
                          child: Center(
                            child: new Text("Yes", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'seg')),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context1) {
        return StatefulBuilder(
          builder: (context1, setState) {
            return AlertDialog(
              title: Text(
                "Log Out!",
                style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'seg'),
              ),
              content: Text(
                "Are you sure you want to log out?",
                style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'seg'),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context1).pop();
                  },
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2C51BE),
                            Color(0xFF2C51BE),
                            Color(0xFF2C51BE),
                          ],
                        ),
                      ),
                      child: Center(
                        child: new Text("No", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'seg')),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context1).pop();
                    SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, false);
                    SHDFClass.saveSharedPrefValueString(AppConstants.UserID, "");

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
                  },
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2C51BE),
                            Color(0xFF2C51BE),
                            Color(0xFF2C51BE),
                          ],
                        ),
                      ),
                      child: Center(
                        child: new Text("Yes", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'seg')),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Future<Null> displayPrediction(Prediction p) async {
//   if (p != null) {
//     var _places;
//     PlacesDetailsResponse detail =
//     await _places.getDetailsByPlaceId(p.placeId);
//
//     var placeId = p.placeId;
//     double lat = detail.result.geometry.location.lat;
//     double lng = detail.result.geometry.location.lng;
//
//     var address = await Geocoder.local.findAddressesFromQuery(p.description);
//
//     print(lat);
//     print(lng);
//   }
// }

}
