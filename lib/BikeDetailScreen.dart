import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/Data/API.dart';
import 'package:kinga_app/Data/BikeDetailResponse.dart';
import 'package:kinga_app/Data/CountyResponse.dart';
import 'package:kinga_app/Data/SignUpResponse.dart';
import 'package:kinga_app/KingaProfile.dart';
import 'package:kinga_app/PhotoReqScreen.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:kinga_app/Utils/CustomAlertDialogue.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/SHDF.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class BikeDetail extends StatefulWidget {

  bool isUpdate;

  BikeDetail(this.isUpdate);

  @override
  _BikeDetailState createState() => _BikeDetailState();
}

class _BikeDetailState extends State<BikeDetail> {
  DateTime selectedDate = DateTime.now();
  String selectedYear;
  String selectedModel;
  ProgressDialog _progressDialog = ProgressDialog();
  String profileImageBase64 = "";
  String networkImage;

  TextStyle placeholderStyle =
  TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle selectedValueStyle =
  TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);
  List<String> modelList = ['Model1', 'Model2', "Model3"];

  TextEditingController numberTF = TextEditingController();
  TextEditingController colorTF = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (year != null) {
      selectedYear = year;
    }

    if (model != null) {
      selectedModel = model;
    }

    colorTF.text = color;
    numberTF.text = numberPlate;
    if (widget.isUpdate) {
      sendBikeDetail();
    } else {


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
                  "Bike Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 0, bottom: 50),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Bike Details",
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
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      uploadedImage == null ? Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Color(0xFFECECEC)),
                                          child:  networkImage == null || networkImage.isEmpty ? IconButton(
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                assignedVal();
                                                isBikeDetail = true;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => PhotoReqScreen()),
                                                );
                                              }) : InkWell(
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
                                                        image:  NetworkImage(networkImage)
                                                    )
                                                )),
                                            onTap: () {
                                              assignedVal();
                                              isBikeDetail = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => PhotoReqScreen()),
                                              );
                                            },
                                          ),

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
                                          assignedVal();
                                          isBikeDetail = true;
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
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                    child: TextField(
                                      // keyboardType: TextInputType.emailAddress,
                                        controller: numberTF,
                                        decoration: InputDecoration(
                                          hintText: 'Number Plate',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedYear == null
                                              ? "Year"
                                              : selectedYear,
                                          style: selectedYear == null
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
                                      handleReadOnlyInputClick(context);
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
                                    height: 12,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                    child: DropdownButton(
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedModel = newValue;
                                        });
                                      },
                                      items: modelList.map((location) {
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
                                      style: selectedModel == null
                                          ? placeholderStyle
                                          : selectedValueStyle,
                                      value: selectedModel,
                                      hint: Text(
                                        "Model",
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
                                    height: 12,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                    child: TextField(
                                      // keyboardType: TextInputType.emailAddress,
                                        controller: colorTF,
                                        decoration: InputDecoration(
                                          hintText: 'Color',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        checkvalidation();
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void assignedVal() {
    if (selectedModel != null) {
      model = selectedModel;
    }

    if (selectedYear != null) {
      year = selectedYear;
    }

    color = colorTF.text;
    numberPlate = numberTF.text;
  }

  void goBackToPage() {
    setState(() {
      Navigator.of(context).pop();
    });
  }


  void checkvalidation() {
    if (numberTF.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Number Plate',
            description: "",
            my_context: context,
          ));
    } else if (selectedModel == null || selectedModel.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Select Model',
            description: "",
            my_context: context,
          ));
    } else if (selectedYear == null || selectedYear.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Select Year',
            description: "",
            my_context: context,
          ));
    } else if (colorTF.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Bike Color',
            description: "",
            my_context: context,
          ));
    } else {
        if (widget.isUpdate) {
          getData();
        } else {
          if (uploadedImage == null) {
            showDialog(
                context: context,
                builder: (BuildContext context1) => OKDialogBox(
                  title: 'Please Upload Bike image',
                  description: "",
                  my_context: context,
                ));
          } else {
            getData();
          }
        }

    }
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);

    Map map;

    if (widget.isUpdate == true) {
      if (uploadedImage == null) {
        map = {
          "user_id": user_id,
          "number_plate": numberTF.text,
          "year": selectedYear,
          "model": selectedModel,
          "color": colorTF.text,
          "bike_photo":  ""
        };

      } else {
        List<int> imageBytes = uploadedImage.readAsBytesSync();
        print(imageBytes);
        String base64ImageTemp = base64Encode(imageBytes);
        profileImageBase64 = base64ImageTemp;

        map = {
          "user_id": user_id,
          "number_plate": numberTF.text,
          "year": selectedYear,
          "model": selectedModel,
          "color": colorTF.text,
          "bike_photo": profileImageBase64
        };


      }
    } else {
      List<int> imageBytes = uploadedImage.readAsBytesSync();
      print(imageBytes);
      String base64ImageTemp = base64Encode(imageBytes);
      profileImageBase64 = base64ImageTemp;


       map = {
        "user_id": user_id,
        "number_plate": numberTF.text,
        "year": selectedYear,
        "model": selectedModel,
        "color": colorTF.text,
        "bike_photo": base64ImageTemp
      };

    }


    if (progressDialog == false) {
      print("Statttttttttt");
      print(_progressDialog);
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await addBikeDetail(API.bikeDetail, map, context);
  }

  Future<http.Response> addBikeDetail(
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
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.bikeDetail, true);
            year = null;
            color = null;
            model = null;
            numberPlate = null;
            Alert(
                context: context,
                title: "SUCCESS",
                desc: widget.isUpdate ? "Bike Detail Updated Successfully." : "Bike Detail Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      bool bikeDetail = preferences.getBool(AppConstants.kingaProfile);
                      uploadedImage = null;
                      if (widget.isUpdate) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        if (bikeDetail == true) {

                          goBackToPage();
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => KingaProfileScreen(false)));

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

  void handleReadOnlyInputClick(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.07),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: YearPicker(
                          selectedDate: DateTime.now(),
                          firstDate: DateTime(1995),
                          lastDate: DateTime.now(),
                          onChanged: (val) {
                            print(val);
                            selectedDate = val;
                            print(selectedDate);
                            final DateTime now = val;
                            final DateFormat formatter = DateFormat('yyyy');
                            final String formatted = formatter.format(now);
                            print("formated date" +
                                formatted); // something like 2013-04-20
                            setState(() {
                              selectedYear = formatted;
                            });

                            Navigator.pop(context);
                          },
                        ),
                      )),
                ],
              ));
        });
  }


  Future<http.Response> getModelList(
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
          ModelListREsponse responseData = new ModelListREsponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            setState(() {
              modelList.clear();
              modelList = responseData.model_list;
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

  Future sendBikeDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString(AppConstants.UserID);
    print('Userrrrrrrrrrr');

    Map map = {
      "user_id": user_id,
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await getBikeDetail(API.get_bike_details, map, context);
  }

  Future<http.Response> getBikeDetail(
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
          GetBikeData responseData = new GetBikeData();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            setState(() {
              getModelList(API.get_model_list, context);
              selectedYear = responseData.bikeDetails.year;
              numberTF.text = responseData.bikeDetails.numberPlate;
              selectedModel = responseData.bikeDetails.model;
              colorTF.text = responseData.bikeDetails.color;
              networkImage = API.baseUrl + responseData.bikeDetails.bikePhoto;
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
