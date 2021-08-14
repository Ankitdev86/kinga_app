import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/KingaProfileResponse.dart';
import 'package:kinga/Data/SignUpResponse.dart';
import 'package:kinga/EmergencyContact.dart';
import 'package:kinga/Utils/AppConstant.dart';
import 'package:kinga/Utils/CustomAlertDialogue.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:kinga/Utils/SHDF.dart';
import 'package:kinga/Utils/global.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'SignUp.dart';

class KingaProfileScreen extends StatefulWidget {
  bool isUpdate;

  KingaProfileScreen(this.isUpdate);

  @override
  _KingaProfileScreenState createState() => _KingaProfileScreenState();
}

class _KingaProfileScreenState extends State<KingaProfileScreen> {
  TextEditingController wristbandTF = TextEditingController();
  TextEditingController confwristbandTF = TextEditingController();
  TextEditingController policyTF = TextEditingController();
  TextEditingController nhifTF = TextEditingController();
  ProgressDialog _progressDialog = ProgressDialog();

  String bloodGroup;
  String allergy;

  String insurer;

  List bloodGroupArray = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  List insurerArray = ["Insurer1", "Insurer2", "Insurer3", "Insurer4", "Insurer5", "Insurer6"];
  List allergyArray = ["Allergy1", "Allergy2", "Allergy3", "Allergy4", "Allergy5", "Allergy6"];

  TextStyle placeholderStyle = TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle selectedValueStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate) {
      sendKingaProfileData();
    } else {}
  }

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
                "Kinga Profile",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: wristbandTF,
                          decoration: InputDecoration(
                            hintText: 'Wristband Number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: confwristbandTF,
                          // obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Wristband Number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 10),
                          child: DropdownButton(
                            onChanged: (newValue) {
                              setState(() {
                                bloodGroup = newValue;
                              });
                            },
                            items: bloodGroupArray.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                            icon: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 25,
                            style: bloodGroup == null ? placeholderStyle : selectedValueStyle,
                            value: bloodGroup,
                            hint: Text(
                              "Blood Group",
                              style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            isExpanded: true,
                            underline: SizedBox(
                              height: 0,
                            ),
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 10),
                          child: DropdownButton(
                            onChanged: (newValue) {
                              setState(() {
                                allergy = newValue;
                              });
                            },
                            items: allergyArray.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                            icon: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 25,
                            style: allergy == null ? placeholderStyle : selectedValueStyle,
                            value: allergy,
                            hint: Text(
                              "Allergies",
                              style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            isExpanded: true,
                            underline: SizedBox(
                              height: 0,
                            ),
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 10),
                          child: DropdownButton(
                            onChanged: (newValue) {
                              setState(() {
                                insurer = newValue;
                              });
                            },
                            items: insurerArray.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                            icon: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 25,
                            style: insurer == null ? placeholderStyle : selectedValueStyle,
                            value: insurer,
                            hint: Text(
                              "Insurer",
                              style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            isExpanded: true,
                            underline: SizedBox(
                              height: 0,
                            ),
                          ),
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
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: policyTF,
                          decoration: InputDecoration(
                            hintText: 'Policy Number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: nhifTF,
                          decoration: InputDecoration(
                            hintText: 'NHIF Number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        widget.isUpdate ? "UPDATE" : "NEXT",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                      onPressed: () {
                        checkvalidation();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => EmergencyScreen()),
                        // );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    ));
  }

  void goBackToPage() {
    setState(() {
      Navigator.of(context).pop();
    });
  }

  void checkvalidation() {
    if (wristbandTF.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter Wristband Number',
                description: "",
                my_context: context,
              ));
    } else if (confwristbandTF.text != wristbandTF.text) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Wristband Number Do Not Match',
                description: "",
                my_context: context,
              ));
    } else if (bloodGroup == null || bloodGroup.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select Blood Group',
                description: "",
                my_context: context,
              ));
    } else if (insurer == null || insurer.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select Insurer',
                description: "",
                my_context: context,
              ));
    } else if (policyTF.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter Policy Number',
                description: "",
                my_context: context,
              ));
    } else if (nhifTF.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter NHIF Number',
                description: "",
                my_context: context,
              ));
    } else {
      getData();
    }
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);

    Map map = {
      "user_id": user_id,
      "wrist_band_no": wristbandTF.text,
      "blood_group": bloodGroup,
      "allergy": allergy == null ? "" : allergy,
      "insurer": insurer,
      "policy_no": policyTF.text,
      "NHIF_no": nhifTF.text
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context, textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await addBikeDetail(API.kinga_profile, map, context);
  }

  Future<http.Response> addBikeDetail(String url, Map jsonMap, BuildContext context) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body).then((http.Response response) {
        final int statusCode = response.statusCode;
        print(response);
        _progressDialog.dismissProgressDialog(context);
        progressDialog = false;

        if (statusCode < 200 || statusCode > 400 || json == null) {
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
          LoginResponse responseData = new LoginResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            SHDFClass.saveSharedPrefValueString(AppConstants.UserID, responseData.user_id);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.kingaProfile, true);
            Alert(
                context: context,
                title: "SUCCESS",
                desc: widget.isUpdate ? "Kinga Profile Updated Successfully." : "Kinga Profile Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      bool bikeDetail = preferences.getBool(AppConstants.emergencyContact);
                      bool colleague = preferences.getBool(AppConstants.collegueContact);
                      uploadedImage = null;

                      if (widget.isUpdate) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        if (bikeDetail == true && colleague == true) {
                          // goBackToPage();
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmergencyScreen(false)));
                        }
                      }
                    },
                    color: Color(0xFF2C51BE),
                    radius: BorderRadius.circular(5.0),
                  ),
                ]).show();
            setState(() {});
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
                title: 'Check your internet connections and settings !',
                description: "",
                my_context: context,
              ));
    }
    return responseInternet;
  }

  Future sendKingaProfileData() async {
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

    await getKingaProfile(API.get_kinga_profile, map, context);
  }

  Future<http.Response> getKingaProfile(String url, Map jsonMap, BuildContext context) async {
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
          KingaProfileResponse responseData = new KingaProfileResponse();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          print(responseData.kingaProfileDetails);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            setState(() {
              wristbandTF.text = responseData.kingaProfileDetails.wristBandNo;
              confwristbandTF.text = responseData.kingaProfileDetails.wristBandNo;
              bloodGroup = responseData.kingaProfileDetails.bloodGroup;
              allergy = responseData.kingaProfileDetails.allergy;
              insurer = responseData.kingaProfileDetails.insurer;
              policyTF.text = responseData.kingaProfileDetails.policyNo;
              nhifTF.text = responseData.kingaProfileDetails.nHIFNo;
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
}
