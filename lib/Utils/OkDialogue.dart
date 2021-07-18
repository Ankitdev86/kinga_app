import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OKDialogBox extends StatelessWidget {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final String title, description;
  final Image image;
  final BuildContext my_context;
  BuildContext dialog_context;

  OKDialogBox({
    @required this.title,
    @required this.description,
    this.image,
    @required this.my_context,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    this.dialog_context = context;
    return
      Container(
          width: double.infinity,
          child: new Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20, top: 30),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Image.asset("Assets/warning.png",),
                      SizedBox(height: 15),
                      Center(
                        child: new Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'MontserratBold',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: new Text(
                          description,
                          style: TextStyle( fontFamily: 'Lato',
                              color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 0),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 80,
                        margin: const EdgeInsets.only(top: 00),
                        child:RaisedButton(
                          color: Color((0xff244589)),
                          child: Text(
                            "OK".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'MontserratBold',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed:(){
                            Navigator.of(dialog_context).pop();
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
  }
}
