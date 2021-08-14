import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/StartTripModel.dart';
import 'package:kinga/Data/complete_trip_response.dart';
import 'package:kinga/Data/send_otp_for_complete_trip_response.dart';
import 'package:kinga/SharingSettingEmergencyContact.dart';
import 'package:kinga/Utils/AppConstant.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:location/location.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Data/send_emergency_msg_response.dart';
import 'EmergencyContact.dart';
import 'Utils/CustomAlertDialogue.dart';
import 'Utils/global.dart';

class CompletedRide extends StatefulWidget {
  final StartTripModel model;
  final String tripId;

  const CompletedRide({Key key, this.model, this.tripId}) : super(key: key);

  @override
  CompletedRideState createState() => CompletedRideState();
}

class CompletedRideState extends State<CompletedRide> {
  //BitmapDescriptor sourceIcon;
  //BitmapDescriptor myIcon;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  TextEditingController _pinPutController = TextEditingController();

  String googleAPIKey = "AIzaSyAHK0oNURLIdEjB59KQXVemT0JsoJQHfg8";

  double CAMERA_ZOOM = 13;
  double CAMERA_TILT = 0;
  double CAMERA_BEARING = 30;

  //LatLng SOURCE_LOCATION;
  //LatLng DEST_LOCATION;

// this set will hold my markers
  Set<Marker> _markers = {};

// this will hold the generated polylines
  Set<Polyline> _polylines = {};

// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  PointLatLng SOURCE_LOCATION;
  PointLatLng DEST_LOCATION;

  LatLng SOURCE_LOCATIONT;
  LatLng DEST_LOCATIONT;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    SOURCE_LOCATION = PointLatLng(widget.model.startLatt, widget.model.startLng);
    DEST_LOCATION = PointLatLng(widget.model.dropLatt, widget.model.dropLng);

    SOURCE_LOCATIONT = LatLng(widget.model.startLatt, widget.model.startLng);
    DEST_LOCATIONT = LatLng(widget.model.dropLatt, widget.model.dropLng);

    
    setMap();
  }

  
  setMap(){

    LatLng _center =  LatLng(widget.model.startLatt, widget.model.startLng);
_lastMapPosition = _center;


    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }
    setSourceAndDestinationIcons();
    startTimer();
    Future.delayed(Duration(seconds: 3), () {
      flagRefreshed = true;
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      setState(() {});
    });

    
    
  }
  
  
  
  String myCurrentAddressPlace = "";
  String myCurrentAddress = "";

  Timer _timer;
  int _start = 50000;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          getCurrentLocation();
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  getCurrentLocation() async {
    var location = new Location();

    var currentLocation = await location.getLocation();
    setState(() {});

    final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);

    var myaddressTmp = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = myaddressTmp.first;
    myCurrentAddress = first.addressLine;
    myCurrentAddressPlace = first.locality;
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'Assets/navigation.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1.5), 'Assets/destination.png');
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    
    if(_timer!=null){
      _timer.cancel();
    }
    
    super.dispose();
  }
  LatLng _lastMapPosition;


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
  GoogleMapController _controller;
  bool status = false;
  bool flagRefreshed = false;

 


  Widget mapWidget() {


    CameraPosition initialLocation = CameraPosition(zoom: 4.0, bearing: CAMERA_BEARING, tilt: CAMERA_TILT, target: LatLng(widget.model.startLatt, widget.model.startLng));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onCameraMove: _onCameraMove,
        onMapCreated: (GoogleMapController controller) async {
          _controller = controller;
          setMapPins();
          setPolylines();
          Future.delayed(Duration(milliseconds: 800), () async {
            await updateCameraLocation(SOURCE_LOCATIONT, DEST_LOCATIONT, controller);

          });
        },
      ),
    );
  }
  Future<void> updateCameraLocation(
      LatLng source,
      LatLng destination,
      GoogleMapController mapController,
      ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }
  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
  void setMapPins() {
    _markers.add(Marker(markerId: MarkerId('sourcePin'), position: LatLng(widget.model.startLatt, widget.model.startLng), icon: sourceIcon));
    // destination pin
    _markers.add(Marker(markerId: MarkerId('destPin'), position: LatLng(widget.model.dropLatt, widget.model.dropLng), icon: destinationIcon));
    setState(() {
      // source pin
      
    });
  }

  setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleAPIKey, SOURCE_LOCATION, DEST_LOCATION);
    print(result.points);

    print(_markers);
    List<PointLatLng> result2 = result.points;
    // List<PointLatLng> result2 = polylinePoints.decodePolyline("_p~iF~ps|U_ulLnnqC_mqNvxq`@");

    if (result.status == "OK") {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result2.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // create a Polyline instance
    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(polylineId: PolylineId('poly'), color: Color.fromARGB(255, 40, 122, 198), points: polylineCoordinates);

    // add the constructed polyline as a set of points
    // to the polyline set, which will eventually
    // end up showing up on the map
    _polylines.add(polyline);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Image(
                              image: AssetImage("Assets/back.png"),
                              color: Colors.black,
                              height: 40,
                              width: 40,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            var url =
                                'https://www.google.com/maps/dir/?api=1&origin=${widget.model.startLatt.toString()},${widget.model.startLng.toString()}&destination=${widget.model.dropLatt.toString()},${widget.model.dropLng.toString()}&travelmode=driving&dir_action=navigate';
                            _launchURL(url);
                          },
                          child: Column(
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
                                  "${widget.model.km} KM",
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                            onTap: () {
                              var url =
                                  'https://www.google.com/maps/dir/?api=1&origin=${widget.model.startLatt.toString()},${widget.model.startLng.toString()}&destination=${widget.model.dropLatt.toString()},${widget.model.dropLng.toString()}&travelmode=driving&dir_action=navigate';
                              _launchURL(url);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.model.dropShortAddress,
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.5), color: Colors.green),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Text(
                                widget.model.dropAddress,
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
                  Center(child: flagRefreshed ? mapWidget() : SizedBox()),
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
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.model.dropShortAddress,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 16),
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
                                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () {
                                      //_showBottomView(context);

                                      sendOtp();
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
                        onPressed: () {
                          _showBottomView(context);
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

/*
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
                                            image: NetworkImage(widget.model.profileImage),
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
                                                widget.model.myName,
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
                                                "Member since ${widget.model.bikeYear}",
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
                                                "${widget.model.bikeModel}",
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
                                                widget.model.bikeName,
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
                                                              "The Language School in Kenya, Chania Ave. Nairobi, Kenya",
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
                                              "The language school in kenya",
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

 */
  String otp = "";

  ProgressDialog _progressDialog = ProgressDialog();

  Future sendOtp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');

    Map map = {"user_id": user_id};

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    // await startTriprequestCall(API.sendOtpForCompleteTrip, map, context, model);

    var request = json.encode(map);
    print(request);
    var body = json.encode(map);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(API.sendOtpForCompleteTrip), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) async {
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
          SendOtpForCompleteTripResponse responseData = new SendOtpForCompleteTripResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            otp = responseData.otp;
            print(otp);
            verifyOtpDialog();
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
  }

  Future verifyOTP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');

    Map map = {"user_id": user_id, "otp": otp};

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    // await startTriprequestCall(API.sendOtpForCompleteTrip, map, context, model);

    var request = json.encode(map);
    print(request);
    var body = json.encode(map);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(API.completeTripUrl), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) async {
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
          CompleteTripResponse responseData = new CompleteTripResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            showDialog(
                context: context,
                builder: (BuildContext context1) {
                  return StatefulBuilder(builder: (context1, setState1) {
                    return Dialog(
                      elevation: 0,
                      // insetPadding: EdgeInsets.all(0),
                      //backgroundColor: Colors.transparent,
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Success",
                                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        responseData.msg,
                                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context1);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  });
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
  }

  void verifyOtpDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context1, setState1) {
            return Dialog(
              elevation: 0,
              // insetPadding: EdgeInsets.all(0),
              //backgroundColor: Colors.transparent,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Complete Trip",
                              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                "Enter your security code to complete your trip",
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 52,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: PinPut(
                            fieldsCount: 5,
                            onSubmit: (String pin) {},
                            controller: _pinPutController,
                            submittedFieldDecoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Colors.black),
                              ),
                              color: Colors.white,
                            ),
                            selectedFieldDecoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Colors.red),
                              ),
                              color: Colors.white,
                            ),
                            followingFieldDecoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Colors.black),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context1);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                if (otp == _pinPutController.text) {
                                  Navigator.pop(context1);
                                  verifyOTP();
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context1) => OKDialogBox(
                                            title: "OTP not Matched",
                                            description: "",
                                            my_context: context,
                                          ));
                                }
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          });
        });
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
                                            image: NetworkImage(widget.model.profileImage),
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
                                                widget.model.myName,
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
                                                "Member since ${widget.model.bikeYear}",
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
                                                "${widget.model.bikeModel}",
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
                                                widget.model.bikeName,
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
                                    onPressed: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SharingSettingEmergencyContact()));

                                    },
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
                                          sendEmergencySms();
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

  Future sendEmergencySms() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);

    Map map = {"user_id": user_id};

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    var request = json.encode(map);
    print(request);
    var body = json.encode(map);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(API.sendEmergencymsgUrl), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) async {
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
          SendEmergencyMsgResponse responseData = new SendEmergencyMsgResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;

            showDialog(
                context: context,
                builder: (BuildContext context1) {
                  return StatefulBuilder(builder: (context1, setState1) {
                    return Dialog(
                      elevation: 0,
                      // insetPadding: EdgeInsets.all(0),
                      //backgroundColor: Colors.transparent,
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Success",
                                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        responseData.msg,
                                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context1);
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  });
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
  }
}
