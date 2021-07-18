import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kinga_app/BikeDetailScreen.dart';
import 'package:kinga_app/Data/API.dart';
import 'package:kinga_app/Data/SignUpResponse.dart';
import 'package:kinga_app/KingaProfile.dart';
import 'package:kinga_app/PhotoReqScreen.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:kinga_app/Utils/CustomAlertDialogue.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/SHDF.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Appbar.dart';

class PersonalDetail extends StatefulWidget {
  @override
  _PersonalDetailState createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  String valueChoose;

  TextEditingController bakTF = TextEditingController();
  TextEditingController passwordTF = TextEditingController();
  TextEditingController confPasswordTF = TextEditingController();
  ProgressDialog _progressDialog = ProgressDialog();

  List<String> genderList = ['Male', 'Female']; // Option 2
  List<String> countyList = ['County1', 'County2', "County3"];
  List<String> subCountyList = ['SubCounty1', 'SubCounty2', "SubCounty3"];
  List<String> saccoList = ['Sacco1', 'Sacco2', "Sacco3"];

  TextStyle placeholderStyle =
      TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle selectedValueStyle =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);

  String gender; // Option 2
  String county;
  String subCounty;
  String sacco;
  String showDate;
  String sendDOB;

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
                  "Personal Details",
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
            SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 100),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Personal Details",
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
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color(0xFFECECEC)),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoReqScreen()),
                                    );
                                  }),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Upload profile photo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: DropdownButton(
                                  onChanged: (newValue) {
                                    setState(() {
                                      gender = newValue;
                                    });
                                  },
                                  items: genderList.map((location) {
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  value: gender,
                                  hint: Text(
                                    "Gender",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
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
                                height: 15,
                              ),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      showDate == null
                                          ? "Date Of Birth"
                                          : showDate,
                                      style: showDate == null
                                          ? placeholderStyle
                                          : selectedValueStyle,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios_sharp),
                                      onPressed: () {},
                                      iconSize: 20,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  _selectDateofBirth(context);
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: DropdownButton(
                                  onChanged: (newValue) {
                                    setState(() {
                                      county = newValue;
                                    });
                                  },
                                  items: countyList.map((location) {
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  value: county,
                                  hint: Text(
                                    "County",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
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
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: DropdownButton(
                                  onChanged: (newValue) {
                                    setState(() {
                                      subCounty = newValue;
                                    });
                                  },
                                  items: subCountyList.map((location) {
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  value: subCounty,
                                  hint: Text(
                                    "SubCounty",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
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
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: DropdownButton(
                                  onChanged: (newValue) {
                                    setState(() {
                                      sacco = newValue;
                                    });
                                  },
                                  items: saccoList.map((location) {
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  value: sacco,
                                  hint: Text(
                                    "Sacco",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
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
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: TextField(
                                    // keyboardType: TextInputType.emailAddress,
                                    controller: bakTF,
                                    decoration: InputDecoration(
                                      hintText: 'Bak#',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: TextField(
                                  controller: passwordTF,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: TextField(
                                  controller: confPasswordTF,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Confirm password',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                      "NEXT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      checkValidation();
                    },
                  ),
                ))
          ],
        ),
      ),
    );

  }

  void selectDateofBirth() {
    _selectDateofBirth(context);
  }

  Future<Null> _selectDateofBirth(BuildContext context) async {
    String strmonth = "";
    String strday = "";
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (picked != null)
      setState(() {
        strmonth = picked.month.toString();
        strday = picked.day.toString();

        if (strmonth.length == 1) {
          strmonth = "0" + strmonth;
        }
        if (strday.length == 1) {
          strday = "0" + strday;
        }

        // mm/dd/yyyy
        //2000-12-12
        showDate = strmonth + "/" + strday + "/" + picked.year.toString();
        sendDOB = picked.year.toString() + "-" + strmonth + "-" + strday;
        //
        //
        setState(() {});
      });
  }

  void checkValidation() {
    if (gender == null || gender.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter Email Address',
                description: "",
                my_context: context,
              ));
    } else if (showDate == null || showDate.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select Date Of Birth',
                description: "",
                my_context: context,
              ));
    } else if (county == null || county.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select County',
                description: "",
                my_context: context,
              ));
    } else if (subCounty == null || subCounty.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select Subcounty',
                description: "",
                my_context: context,
              ));
    } else if (sacco == null || sacco.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Select Sacco',
                description: "",
                my_context: context,
              ));
    } else if (bakTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter Bak',
                description: "",
                my_context: context,
              ));
    } else if (passwordTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Please Enter Password',
                description: "",
                my_context: context,
              ));
    } else if (passwordTF.text.length < 6) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Password Length Must Be Greater Than 6 Digit',
                description: "",
                my_context: context,
              ));
    } else if (passwordTF.text != confPasswordTF.text) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
                title: 'Password Do Not Match',
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
      "county": county,
      "sub_county": subCounty,
      "sacco": sacco,
      "bak_no": bakTF.text,
      "password": passwordTF.text,
      "gender": gender,
      "birth_date": sendDOB,
      "profile_img": ""
    };

    if (_progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await addPersonalDetail(API.personalDetail, map, context);
  }

  Future<http.Response> addPersonalDetail(
      String url, Map jsonMap, BuildContext context) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http
          .post(Uri.parse(url),
              headers: {"Content-Type": "application/json"}, body: body)
          .then((http.Response response) {
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
            SHDFClass.saveSharedPrefValueString(
                AppConstants.UserID, responseData.user_id);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            Alert(
                context: context,
                title: "SUCCESS",
                desc: "Personal Detail Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BikeDetail()),
                    ),
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
}
