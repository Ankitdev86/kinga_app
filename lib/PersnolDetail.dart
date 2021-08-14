import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinga/BikeDetailScreen.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/CountyResponse.dart';
import 'package:kinga/Data/PersonaldetailResponse.dart';
import 'package:kinga/Data/SignUpResponse.dart';
import 'package:kinga/KingaProfile.dart';
import 'package:kinga/PhotoReqScreen.dart';
import 'package:kinga/Utils/AppConstant.dart';
import 'package:kinga/Utils/CustomAlertDialogue.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:kinga/Utils/SHDF.dart';
import 'package:kinga/Utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Appbar.dart';

class PersonalDetail extends StatefulWidget {

  bool isUpdate;

  PersonalDetail(this.isUpdate);

  @override
  _PersonalDetailState createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  String valueChoose;

  TextEditingController bakTF = TextEditingController();
  TextEditingController passwordTF = TextEditingController();
  TextEditingController confPasswordTF = TextEditingController();
  ProgressDialog _progressDialog = ProgressDialog();

  List<String> genderList = ['Male', 'Female', 'Other']; // Option 2
  List<String> countyList = [];
  List<String> subCountyList = [];
  List<String> saccoList = [];

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
  String profileImageBase64 = "";
  String networkimage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    print(API.get_county_list);
    if (dateOfBirth != null) {
      showDate = dateOfBirth;
    }

    if (selectedgender != null) {
      gender = selectedgender;
    }

    if (selectedCounty != null) {
      county = selectedCounty;
    }

    if (selectedSubcounty != null) {
      subCounty = selectedSubcounty;
    }

    if (selectedsacco != null) {
      sacco = selectedsacco;
    }

    if (dateOfBirth != null) {
      showDate = dateOfBirth;
      sendDOB = selectedsendDOB;
    }

    bakTF.text = selectedbak;
    passwordTF.text = selectedpassword;
    confPasswordTF.text = selectedconPassword;

    if (widget.isUpdate) {
      sendPersonalDetail();
    } else {
      getCountyList(API.get_county_list, context);
      getSubCountyList(API.get_sub_county_list, context);
      getSaccoList(API.get_sacco_list, context);

    }
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
                            uploadedImage == null ? Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xFFECECEC)),
                                child: networkimage == null || networkimage.isEmpty ? IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      assignValue();
                                      isBikeDetail = false;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhotoReqScreen()),
                                      );
                                    }) :
                                InkWell(
                                  child: Container(
                                      height : 60,width:60,
                                      // margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blueGrey[100], //                   <--- border color
                                            width: 2,
                                          ),
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(networkimage),
                                          )
                                      )),
                                  onTap: () {
                                    assignValue();
                                    isBikeDetail = false;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PhotoReqScreen()),
                                    );
                                  },
                                )

                            ) : InkWell(
                              child: Container(
                                  height : 60,width:60,
                                  // margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blueGrey[100], //                   <--- border color
                                        width: 2,
                                      ),
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image:  FileImage(uploadedImage)
                                      )
                                  )),
                              onTap: () {
                                assignValue();
                                isBikeDetail = false;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoReqScreen()),
                                );
                              },
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
                                  style: gender == null ? placeholderStyle : selectedValueStyle,
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
                                    style: county == null ? placeholderStyle : selectedValueStyle,
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
                                    style: county == null ? placeholderStyle : selectedValueStyle,
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
                                    style: sacco == null ? placeholderStyle : selectedValueStyle,
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
                      widget.isUpdate == true ? "UPDATE" : "NEXT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      if (widget.isUpdate) {
                        checkUpdateValidation();
                      } else {
                        checkValidation();
                      }
                    },
                  ),
                ))
          ],
        ),
      ),
    );

  }

  void assignValue() {
    if (showDate != null) {
      dateOfBirth = showDate;
    }

    if (gender != null) {
      selectedgender = gender;
    }

    if (county != null) {
      selectedCounty = county;
    }

    if (subCounty != null) {
      selectedSubcounty = subCounty;
    }

    if (sacco != null) {
      selectedsacco = sacco;
    }

    if (showDate != null) {
      dateOfBirth = showDate;
      selectedsendDOB = sendDOB;
    }

    selectedbak = bakTF.text;
    selectedpassword = passwordTF.text;
    selectedconPassword = confPasswordTF.text;


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
    } else if (uploadedImage == null) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Upload Profile image',
            description: "",
            my_context: context,
          ));
    } else {
      getData();
    }
  }

  void checkUpdateValidation() {
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
    } else {
      getData();
    }
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
     Map map;
    if (widget.isUpdate) {
      map = {
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

    } else {
      List<int> imageBytes = uploadedImage.readAsBytesSync();
      print(imageBytes);
      String base64ImageTemp = base64Encode(imageBytes);
      profileImageBase64 = base64ImageTemp;

      map = {
        "user_id": user_id,
        "county": county,
        "sub_county": subCounty,
        "sacco": sacco,
        "bak_no": bakTF.text,
        "password": passwordTF.text,
        "gender": gender,
        "birth_date": sendDOB,
        "profile_img": profileImageBase64
      };


    }


    if (progressDialog == false) {
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
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.personalDetail, true);
            uploadedImage = null;
            Alert(
                context: context,
                title: "SUCCESS",
                desc: widget.isUpdate == true ? "Personal Detail Updated Successfully." : "Personal Detail Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      bool bikeDetail = preferences.getBool(AppConstants.bikeDetail);

                      if (widget.isUpdate) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        if (bikeDetail == true) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => BikeDetail(false)));

                        }

                      }



                    },

                    // => Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BikeDetail()),
                    // ),
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


  Future<http.Response> getCountyList(
      String url, BuildContext context) async {
    var responseInternet;
    try {
      responseInternet = await http
          .get(Uri.parse(url))
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
          CountyListResponse responseData = new CountyListResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            setState(() {
              countyList.clear();
              countyList = responseData.county_list;
              print("CCCCOOOOOOUUUUUNNNNNNTTTTTYYYYYYY");
              print(countyList);
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

  Future<http.Response> getSubCountyList(
      String url, BuildContext context) async {
    var responseInternet;
    try {
      responseInternet = await http
          .get(Uri.parse(url))
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
          SubCountyListResponse responseData = new SubCountyListResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            setState(() {
              subCountyList.clear();
              subCountyList = responseData.sub_county_list;
              print("SSSSSUUUUUBBBBBCCCCOOOOOOUUUUUNNNNNNTTTTTYYYYYYY");
              print(subCountyList);

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

  Future<http.Response> getSaccoList(
      String url, BuildContext context) async {
    var responseInternet;
    try {
      responseInternet = await http
          .get(Uri.parse(url))
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
          SaccoListREsponse responseData = new SaccoListREsponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            setState(() {
              saccoList = responseData.sacco_list;
              print("SSSSAAAAACCCCCCOOOOOOOO");
              print(saccoList);
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

  Future sendPersonalDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');
    print(API.get_kinga_profile);

    Map map = {
      "user_id": user_id,
    };

    if (progressDialog == false) {

      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await getPersonalProfile(API.get_personal_details, map, context);
  }

  Future<http.Response> getPersonalProfile(
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
          GetPersonalData responseData = new GetPersonalData();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            setState(() {
              getCountyList(API.get_county_list, context);
              getSubCountyList(API.get_sub_county_list, context);
              getSaccoList(API.get_sacco_list, context);

              gender = responseData.personalDetails.gender;
              sendDOB = responseData.personalDetails.birthDate;
              county = responseData.personalDetails.county;
              subCounty = responseData.personalDetails.subCounty;
              sacco = responseData.personalDetails.sacco;
              bakTF.text = responseData.personalDetails.bakNo;
              // passwordTF.text = responseData.personalDetails.pa;
              networkimage = API.baseUrl + responseData.personalDetails.profileImg;
              if (!responseData.personalDetails.birthDate.isEmpty) {
                DateTime parseDate =
                new DateFormat("yyyy-MM-dd").parse(sendDOB);
                var inputDate = DateTime.parse(parseDate.toString());
                var outputFormat = DateFormat('dd/MM/yyyy');
                var outputDate = outputFormat.format(inputDate);
                showDate = outputDate;
                print(outputDate);

              }

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
