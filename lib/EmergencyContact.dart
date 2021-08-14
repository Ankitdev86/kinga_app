import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/DashboardScreen.dart';
import 'package:kinga/Data/API.dart';
import 'package:kinga/Data/EmergencyContactResponse.dart';
import 'package:kinga/Data/SignUpResponse.dart';
import 'package:kinga/MakePayment.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/Utils/AppConstant.dart';
import 'package:kinga/Utils/CustomAlertDialogue.dart';
import 'package:kinga/Utils/OkDialogue.dart';
import 'package:kinga/Utils/SHDF.dart';
import 'package:kinga/Utils/global.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinga/ContactList.dart';

class EmergencyScreen extends StatefulWidget {
  bool isUpdate;

  EmergencyScreen(this.isUpdate);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  ProgressDialog _progressDialog = ProgressDialog();
  bool isColleague;
  bool isKin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendEmergencyDetail();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sendEmergencyDetail();
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
                "Emergency Contact",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 50),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Next of Kin",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            iskinContactList = true;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyApp(
                                        isCollegue: false,
                                        isKin: true,
                                      )),
                            ).then((_) {
                              // This method gets callback after your SecondScreen is popped from the stack or finished.
                              sendEmergencyDetail();
                            });
                          },
                          child: Text(
                            "Add Contact",
                            style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    kinContact == null
                        ? SizedBox(
                            height: 1,
                          )
                        : Flexible(
                            child: ListView(
                              shrinkWrap: true,
                              itemExtent: 60,
                              children: List.generate(kinContact.length, (index) {
                                print(kinContact);

                                return ListTile(
                                  onTap: () {},
                                  onLongPress: () {},
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      child: Text((kinContact[index].name.substring(0, 1).toUpperCase()), style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  title: Text(kinContact[index].name.toString()),
                                  subtitle: Text(kinContact[index].contactNo.toString()),
                                );
                              }),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Colleague",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            iskinContactList = false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyApp(
                                        isCollegue: true,
                                        isKin: false,
                                      )),
                            ).then((_) {
                              // This method gets callback after your SecondScreen is popped from the stack or finished.
                              sendEmergencyDetail();
                            });
                          },
                          child: Text(
                            "Add Contact",
                            style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    collegueContact == null
                        ? SizedBox(
                            height: 1,
                          )
                        : Flexible(
                            child: ListView(
                              shrinkWrap: true,
                              itemExtent: 60,
                              children: List.generate(collegueContact.length, (index) {
                                print(collegueContact);
                                return ListTile(
                                  onTap: () {},
                                  onLongPress: () {},
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      child: Text((collegueContact[index].name.substring(0, 1).toUpperCase()), style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  title: Text(collegueContact[index].name.toString()),
                                  subtitle: Text(collegueContact[index].contactNo.toString()),
                                );
                              }),
                            ),
                          ),
                    SizedBox(
                      height: 8,
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
                      "NEXT",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    onPressed: () {
                      if (collegueContact == null || collegueContact.length == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context1) => OKDialogBox(
                                  title: 'Please Add Colleague Contact',
                                  description: "",
                                  my_context: context,
                                ));
                      } else if (kinContact == null || kinContact.length == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context1) => OKDialogBox(
                                  title: 'Please Add Next to Kin Contact',
                                  description: "",
                                  my_context: context,
                                ));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardPage()),
                        );
                      }
                    },
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  Future sendEmergencyDetail() async {
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

    await getEmergencyContact(API.getEmergencyDetails, map, context);
  }

  Future<http.Response> getEmergencyContact(String url, Map jsonMap, BuildContext context) async {
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
          GetEmergencyContact responseData = new GetEmergencyContact();
          responseData.fromJson(json.decode(response.body));
          print(response.body);
          Map<String, dynamic> data = responseData.toJson();
          if (responseData.status == "1") {
            _progressDialog.dismissProgressDialog(context);
            progressDialog = false;
            setState(() {
              kinContact = responseData.nextOfKin;
              collegueContact = responseData.colleague;
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
