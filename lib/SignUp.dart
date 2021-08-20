import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/SignUpResponse.dart';
import 'package:kinga/OTPfile.dart';
import 'package:kinga/PersnolDetail.dart';
import 'package:kinga/Utils/CustomAlertDialogue.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:kinga/Utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/Data/API.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailTF = TextEditingController();
  TextEditingController nameTF = TextEditingController();
  TextEditingController lastNameTF = TextEditingController();
  TextEditingController mobNoTF = TextEditingController();

  ProgressDialog _progressDialog = ProgressDialog();

  bool rememberMe = false;

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
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "KE +254",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
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
                                      controller: mobNoTF,
                                      decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                      ),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailTF,
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                  ),
                                  textInputAction: TextInputAction.next),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  controller: nameTF,
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                  ),
                                  textInputAction: TextInputAction.next),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  controller: lastNameTF,
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                  ),
                                  textInputAction: TextInputAction.done),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      focusColor: Colors.lightBlue,
                                      activeColor: Color(0xFF2C51BE),
                                      value: rememberMe,
                                      onChanged: (newValue) {
                                        setState(() => rememberMe = newValue);
                                      }),
                                  RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: 'By signing up, you agree to our ',
                                            style: TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: 'terms of use, \n',
                                            style: TextStyle(color: Colors.blueAccent),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUpPage()),
                                                );
                                              }),
                                        TextSpan(
                                            text:
                                            'and acknowledging that you have read the\n ',
                                            style: TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: 'Privacy policy',
                                            style: TextStyle(color: Colors.blueAccent),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUpPage()),
                                                );
                                              }),
                                        TextSpan(
                                            text: 'and the ',
                                            style: TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: 'Cookie policy',
                                            style: TextStyle(color: Colors.blueAccent),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUpPage()),
                                                );
                                              }),
                                      ])),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Already have an account? ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16)),
                                    TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 16),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SignUpPage()),
                                            );
                                          }),
                                  ])),
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
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          onPressed: () {
                            checkValidation();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => VerificationPage()),
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

  void checkValidation() {
    if (mobNoTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Phone number',
            description: "",
            my_context: context,
          ));
    } else if (emailTF.text.length == 0) {
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
    } else if (nameTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter First Name',
            description: "",
            my_context: context,
          ));
    } else if (lastNameTF.text.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Enter Last Name',
            description: "",
            my_context: context,
          ));
    } else if (!rememberMe) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Agree To Terms And Conditions',
            description: "",
            my_context: context,
          ));
    } else {
      print("Validate Successfull.....");
      checkEmaildata();
    }
  }

  Future getData() async {

    Map map = {
      "mobile_no": mobNoTF.text
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await verification(API.verifyOTP, map, context);
  }

  Future<http.Response> verification(
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
          VerifyOTP responseData = new VerifyOTP();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);

            setState(() {});

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationPage(nameTF.text,mobNoTF.text,emailTF.text,responseData.otp,lastNameTF.text)),
            );

            /*Fluttertoast.showToast(
                msg: "Repair Request Added Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Color((0xff52A0F8)),
                textColor: Colors.white,
                fontSize: 16.0);*/

            // Navigator.pop(context);
          } else {
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context1) => OKDialogBox(
            //       title: '' + responseData.msg,
            //       description: "",
            //       my_context: context,
            //     ));
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


  Future checkEmaildata() async {

    Map map = {
      "email": emailTF.text
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    await checkUserEmail(API.checkUserEmail, map, context);
  }

  Future<http.Response> checkUserEmail(
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
          EmailResponse responseData = new EmailResponse();
          responseData.fromJson(json.decode(response.body));
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            print(data);
            // SHDFClass.saveSharedPrefValueBoolean(AppConstants.Session, true);
            setState(() {});
            Alert(
                context: context,
                title: "",
                desc: "Email id already exist",
                image: Image.asset("Assets/warning.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    color: Color(0xFF2C51BE),
                    radius: BorderRadius.circular(5.0),
                  ),
                ]
            ).show();

          } else {
            getData();
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
