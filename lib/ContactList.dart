import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:kinga_app/Appbar.dart';
import 'package:kinga_app/ContactList.dart';
import 'package:kinga_app/Data/CustomContact.dart';
import 'package:kinga_app/Utils/OkDialogue.dart';
import 'package:kinga_app/Utils/global.dart';


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
  IconData icon;




  void initState() {
    // TODO: implement initState
    super.initState();
    refreshContacts();
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
                  title: Text('ID: ' + _allContacts[index].contact.displayName.toString()),
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
}

