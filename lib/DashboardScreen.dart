import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/BikeDetailScreen.dart';
import 'package:kinga_app/CompleteRide.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinga_app/EmergencyContact.dart';
import 'package:kinga_app/MakePayment.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinga_app/KingaProfile.dart';
import 'Utils/CustomPlacePicker/src/place_picker.dart';

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
  LocationData currentLocation;

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
  void changeStatus() {
    if (status == false) {
      title = "Offline";
    } else {
      title = "Online";
    }
    _child = mapWidget();
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
                              'Harsha Dubbalwar',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Harsha Dubbalwar',
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
          )
        ],
      )),
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
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
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
                  chooselocation();
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
                          location = new Location();
                          currentLocation = await location.getLocation();

                          print("latt ---" + currentLocation.latitude.toString());
                          print("longg ---" + currentLocation.longitude.toString());

                          geoocationLattitude = currentLocation.latitude.toString();
                          geoocationLongitude = currentLocation.longitude.toString();
                        },
                      )),
                  FloatingActionButton(
                      backgroundColor: Colors.white60,
                      child: Icon(
                        Icons.shield,
                        color: Colors.black,
                      ),
                      onPressed: () {}),
                ],
              ),
            )
          ],
        ),
      ),
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

  Widget mapWidget() {
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: ClipOval(
                                                child: Image(
                                              image: new AssetImage("Assets/Profile Image.png"),
                                              width: 60,
                                              height: 60,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Joshua Ngugi",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "EuclidCircularA-Bold",
                                              ),
                                            ),
                                            Text(
                                              "Member since 2019",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontFamily: "EuclidCircularA-Bold",
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
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Talisman Restaurant ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "EuclidCircularA-Bold",
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
                                              fontFamily: "EuclidCircularA-Bold",
                                            ),
                                          ),
                                          Text(
                                            "Total Distance",
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
                              ),
                              Container(
                                color: Colors.grey,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                              ),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                    contentPadding: EdgeInsets.only(left: 10.0, bottom: 10),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 10, top: 0, bottom: 10),
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
                                                            width: 45,
                                                            child: Text(
                                                              "KE+254",
                                                              // "Country*",
                                                              style: TextStyle(
                                                                fontFamily: 'EuclidCircularA-Regular',
                                                                fontSize: 12,
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
                                        SizedBox(
                                          width: 100,
                                          child: new Center(
                                            child: new Container(
                                              margin: new EdgeInsetsDirectional.only(start: 20, end: 0, bottom: 5),
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
                                        margin: const EdgeInsets.only(left: 0, right: 10, top: 0),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            cursorColor: Colors.red,
                                            hintColor: Colors.greenAccent,
                                          ),
                                          child: TextFormField(
                                            controller: textEditingController_firstname,
                                            maxLength: 10,
                                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                            // inputFormatters: [
                                            //   WhitelistingTextInputFormatter
                                            //       .digitsOnly
                                            // ],
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontFamily: 'EuclidCircularA-Regular',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                              hintText: 'Mobile Number',
                                              counterText: "",
                                              contentPadding: EdgeInsets.only(left: 20.0),
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
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 0),
                              ),
                              Container(
                                height: 45,
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                    contentPadding: EdgeInsets.only(left: 10.0, bottom: 10),
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
                                            color: Colors.white,
                                            highlightColor: Colors.white,
                                            splashColor: Colors.blue.withAlpha(100),
                                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(fontFamily: "EuclidCircularA-SemiBold", fontSize: 14, letterSpacing: 1, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Container(
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
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CompletedRide()),
                                              );
                                            },
                                            child: Center(
                                              child: Text(
                                                "START TRIP",
                                                style: TextStyle(fontFamily: "EuclidCircularA-SemiBold", fontSize: 14, letterSpacing: 1, color: Colors.white),
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
    setState(() async {
      currentLocation = await location.getLocation();
      _child = mapWidget();
    });
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

            // Navigator.pop(context,true);
            Navigator.pop(context);
            
            
          },
        );
      },
    ));
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
