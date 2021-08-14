import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/BikeDetailScreen.dart';
import 'package:kinga/DashboardScreen.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/SignUpResponse.dart';
import 'package:kinga/OnboardingScreen.dart';
import 'package:kinga/PersnolDetail.dart';
import 'package:kinga/SignUp.dart';
import 'package:kinga/Utils/AppConstant.dart';
import 'package:kinga/Utils/CustomAlertDialogue.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:kinga/Utils/SHDF.dart';
import 'package:kinga/Utils/global.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTF = TextEditingController();
  TextEditingController passwordTF = TextEditingController();
  ProgressDialog _progressDialog = ProgressDialog();

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    backgroundColor: Colors.blueAccent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

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
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTF,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: passwordTF,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            checkValidation();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xFF2C51BE),
                            ),
                            height: 45,
                            child: Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                )),
                            width: MediaQuery.of(context).size.width - 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )),
                      ],
                    ),
                    Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'Dont have an account? ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: 'Register',
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUpPage()),
                                        );
                                      }),
                              ])),
                        ))
                  ],
                ))),
      ),
    );
  }

  void checkValidation() {
    if (emailTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Email Address',
            description: "",
            my_context: context,
          ));
    } else if (!EmailValidator.Validate(emailTF.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Valid Email Address',
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
    } else {
      print("Validate Successfull.....");
      getData();
    }
  }


  Future getData() async {

    Map map = {
      "email": emailTF.text,
      "password": passwordTF.text
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await signInUser(API.userlogin, map, context);
  }

  Future<http.Response> signInUser(
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
        print("Status Code..................");
        print(statusCode);
        if (statusCode < 200 || statusCode > 400 || json == null) {
          showDialog(
              context: context,
              builder: (BuildContext context1) => OKDialogBox(
                title: response.statusCode.toString(),
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
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            setState(() {
              Map map = {
                "user_id": responseData.user_id,
              };
              checkUerStatus(API.checkuserStatus, map, context);
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

  Future<http.Response> checkUerStatus(
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
                title: response.statusCode.toString(),
                description: "",
                my_context: context,
              ));

          throw new Exception("Error while fetching data");
        } else {
          print(response.body);
          UserStatusResponse responseData = new UserStatusResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            SHDFClass.saveSharedPrefValueString(AppConstants.UserID, responseData.user_id);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.personalDetail, responseData.personal_profile_status);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.kingaProfile, responseData.kingaPofile);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.bikeDetail, responseData.bike_profile_status);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.emergencyContact, responseData.next_of_kin_status);
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.emergencyContact, responseData.colleague_status);

            print(responseData.kingaPofile);

            setState(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardPage()),
              );
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
