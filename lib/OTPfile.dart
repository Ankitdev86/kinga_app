import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/DashboardScreen.dart';
import 'package:kinga_app/Data/API.dart';
import 'package:kinga_app/Data/SignUpResponse.dart';
import 'package:kinga_app/PersnolDetail.dart';
import 'package:kinga_app/ProfileView.dart';
import 'package:kinga_app/Utils/CustomAlertDialogue.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/SHDF.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/AppConstant.dart';

class VerificationPage extends StatefulWidget {
  String Name = "", Phone = "", Email = "", LastName = "", OTP = "";


  VerificationPage(this.Name, this.Phone, this.Email, this.OTP, this.LastName);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  FocusNode _focusDigit1 = FocusNode();
  FocusNode _focusDigit2 = FocusNode();
  FocusNode _focusDigit3 = FocusNode();
  FocusNode _focusDigit4 = FocusNode();
  ProgressDialog _progressDialog = ProgressDialog();

  String enteredOTP = "";

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
                    "Verify Phone Number",
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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  children: [
                    Text(
                      "Verify phone number",
                      style: TextStyle(fontSize: 35),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "A verification code has been sent to" +
                          widget.Phone +
                          "\n Please enter the code below",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PinEntryTextField(
                            showFieldAsBox: false,
                            onSubmit: (String pin) {
                              if (pin == widget.OTP) {
                                getData();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text('Please Enter Valid OTP'),
                                      );
                                    }); //end showDialog()
                              }
                            }, // end onSubmit
                          ), // end PinEntryTextField()
                        ), // end Padding()
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 40,
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black,
                                    width: 0,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(
                                  5,
                                )),
                            color: Colors.white,
                            highlightColor: Colors.white,
                            splashColor: Colors.blue.withAlpha(100),
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PersonalDetail(false)),
                              );
                            },
                            child: Center(
                              child: Text(
                                "RESEND",
                                style: TextStyle(
                                    fontFamily: "EuclidCircularA-SemiBold",
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    color: Color(0xFF2C51BE)),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future getData() async {

    Map map = {
      "mobile_no": widget.Phone,
      "first_name": widget.Name,
      "last_name": widget.LastName,
      "email": widget.Email
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await registerUser(API.signUp, map, context);
  }

  Future<http.Response> registerUser(
      String url, Map jsonMap, BuildContext context) async {
    var body = json.encode(jsonMap);
    var responseInternet;
    try {
      responseInternet = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
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
          SignUpResponse responseData = new SignUpResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            SHDFClass.saveSharedPrefValueString(AppConstants.UserID, responseData.user_id);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.personalDetail, false);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.kingaProfile, false);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.bikeDetail, false);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.emergencyContact, false);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.collegueContact, false);

            // SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            setState(() {});
            Alert(
                context: context,
                title: "SUCCESS",
                desc: "Signup Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalDetail(false)),
                    ),
                    color: Color(0xFF2C51BE),
                    radius: BorderRadius.circular(5.0),
                  ),
                ]
            ).show();

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

class OTPDigitTextFieldBox extends StatelessWidget {
  final bool first;
  final bool last;
  const OTPDigitTextFieldBox(
      {Key key, @required this.first, @required this.last})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          // autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          // style: MyStyles.inputTextStyle,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
