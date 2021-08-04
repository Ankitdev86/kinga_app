import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/Data/API.dart';
import 'package:kinga_app/Data/CustomContact.dart';
import 'package:kinga_app/Data/SignUpResponse.dart';
import 'package:kinga_app/Utils/AppConstant.dart';
import 'package:kinga_app/Utils/CustomAlertDialogue.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/SHDF.dart';
import 'package:kinga_app/Utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyApp extends StatefulWidget {
  @override

  _MyAppState createState() => _MyAppState();
  bool isCollegue;
  bool isKin;

  MyApp({Key key, @required this.isCollegue, this.isKin}) : super(key: key);

}

class _MyAppState extends State<MyApp> {
  double padValue = 0;


  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  ProgressDialog _progressDialog = ProgressDialog();

  IconData icon;




  void initState() {
    // TODO: implement initState
    super.initState();
    _askPermissions(null);
    }


  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }
  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      // _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: IAppBar(
          height: 80,
          color: Color(0xFF2C51BE),
          child: Container(
            margin: const EdgeInsets.only(left: 0, right: 10, top: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  widget.isKin == true ? "Next of Kin" : "Colleague",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                // TextButton(onPressed: (){
                //   if (widget.isKin == true) {
                //      if (_uiCustomContacts.length == 0) {
                //        showDialog(
                //            context: context,
                //            builder: (BuildContext context1) => OKDialogBox(
                //              title: 'Please Select Atleast One Contact',
                //              description: "",
                //              my_context: context,
                //            ));
                //      } else {
                //        kinContact = _uiCustomContacts;
                //      }
                //   } else {
                //     if (_uiCustomContacts.length == 0) {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context1) => OKDialogBox(
                //             title: 'Please Select Atleast One Contact',
                //             description: "",
                //             my_context: context,
                //           ));
                //     } else {
                //       collegueContact = _uiCustomContacts;
                //     }
                //   }
                // },
                //     child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),)
                // )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: List.generate(_allContacts.length, (index) {
                CustomContact userContact = _allContacts[index];
                var _phonesList = userContact.contact.phones.toList();
                return ListTile(
                  onTap: (){
                    setState(() {
                      _allContacts[index].isChecked = !_allContacts[index].isChecked;
                      if (_uiCustomContacts.contains(_allContacts[index])) {
                        _uiCustomContacts.remove(_allContacts[index]);
                        print(_uiCustomContacts.length);
                      } else {
                        _uiCustomContacts.add(_allContacts[index]);
                        print(_uiCustomContacts.length);
                      }
                      log(_allContacts[index].isChecked.toString());
                    });

                  },
                  onLongPress: () {

                  },
                  selected: _allContacts[index].isChecked,
                  leading: Container(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: (_allContacts[index].contact.avatar != null)
                        ? CircleAvatar(backgroundImage: MemoryImage(_allContacts[index].contact.avatar))
                        : CircleAvatar(
                      child: Text(
                          (_allContacts[index].contact.displayName[0] +
                              _allContacts[index].contact.displayName[1].toUpperCase()),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  title: Text(_allContacts[index].contact.displayName.toString()),
                  subtitle: _phonesList.length >= 1 && _phonesList[0]?.value != null
                      ? Text(_phonesList[0].value)
                      : Text(''),
                  trailing: (_allContacts[index].isChecked)
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                );
              }),
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
                      "SAVE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    onPressed: () {
                      checkvalidation();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => PaymentScreen()),
                      // );
                    },
                  ),
                ))
          ],
        )
      ),
    );
  }

  void checkvalidation() {
    if (_uiCustomContacts.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context1) => OKDialogBox(
            title: 'Please Select Contact',
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

    List<Map<String, dynamic>> send=[] ;


    for (CustomContact cont in _uiCustomContacts) {
      print(cont);
      var _phonesList = cont.contact.phones.toList();
      print(_phonesList);
      Map<String, dynamic> myObject = {
        "name" : cont.contact.displayName,
        "phone": _phonesList[0].value
      };
      send.add(myObject);
    }

    print(send);

    Map map = {
      "user_id": user_id,
      "kin_of_contact": send
    };

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'Please wait...', dismissAfter: null);
    }

    if (widget.isKin) {
      addKinContact(API.addKinData, map, context);
    } else {
      addColleagueContact(API.addColleagueData, map, context);
    }

  }

  Future<http.Response> addKinContact(
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
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.emergencyContact, true);
            // kinContact = _uiCustomContacts;
            Alert(
                context: context,
                title: "SUCCESS",
                desc: "Contact Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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

  Future<http.Response> addColleagueContact(
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
            SHDFClass.saveSharedPrefValueBoolean(AppConstants.collegueContact, true);
            // collegueContact = _uiCustomContacts;
            Alert(
                context: context,
                title: "SUCCESS",
                desc: "Contact Added Successfully.",
                image: Image.asset("Assets/success.png"),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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

  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      } else {
        refreshContacts();
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



}

