import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/Appbar.dart';
import 'package:kinga/PersnolDetail.dart';
import 'package:kinga/SurePhotoScreen.dart';
import 'dart:io';


class PhotoReqScreen extends StatefulWidget {
  @override
  _PhotoReqScreenState createState() => _PhotoReqScreenState();
}

class _PhotoReqScreenState extends State<PhotoReqScreen> {

  String profileImageBase64 = "";
  bool flagImgLoaded = true;
  File profImage;
  File image;
  File cropped;


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
                    "Take your profile photo",
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Photo Requirements",
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
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "1. Show your whole face and tops of your shoulder\n\n2. Take your sunglasses off\n\n3. Take your photo in a well-lit place",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 100,
                              child: Image(image: AssetImage('Assets/Profile Image.png'))),
                        )
                      ],
                    ),
                  )
                ],
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
                        "TAKE PHOTO",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        selectPhoto();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => SurePhotoScreen()),
                        // );
                      },
                    ),
                  )),
            ],
          ),
        ));
  }

  void selectPhoto() {
    //  var _loadImage = new AssetImage('assets/images/ic_circle.png');
    showDialog(
      context: context,
      builder: (context1) {
        return StatefulBuilder(
          builder: (context1, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Select Photo",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'LatoBold',
                        color: Color((0xff44536a)),)),
                  new GestureDetector(
                    onTap: () {
                      Navigator.pop(context1);
                    },
                    child: new Image.asset(
                      "assets/images/ic_cancel.png",
                      height: 15,
                      width: 15,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              content: new Wrap(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new SizedBox(
                        height: 20,
                      ),
                      new Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: ()  {
                              openGalleryPicker();
                              Navigator.pop(context1);
                            },
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      new Color(0xff0A004D),
                                      new Color(0xff0A004D).withAlpha(150),
                                      new Color(0xff0A004D),
                                    ],
                                  ),
                                ),
                                child: GestureDetector(
                                  child: Center(
                                    child: new Column(
                                      children: <Widget>[
                                        new Image.asset(
                                          "Assets/ic_gallary.png",
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        ),
                                        new GestureDetector(
                                            child: new Text("Gallery",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Lato',
                                                  letterSpacing: 1,)))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: ()  {
                              openCameraPicker();
                              Navigator.pop(context1);
                            },
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      new Color(0xff0A004D),
                                      new Color(0xff0A004D).withAlpha(150),
                                      new Color(0xff0A004D),
                                    ],
                                  ),
                                ),
                                child: GestureDetector(
                                  child: Center(
                                    child: new Column(
                                      children: <Widget>[
                                        new Image.asset(
                                          "Assets/ic_camera.png",
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        ),
                                        new GestureDetector(
                                            child: new Text("Camera",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Lato',
                                                  letterSpacing: 1,
                                                  color: Colors.white,)))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          new SizedBox(
                            height: 10,
                          ),

                        ],
                      ),
                      new SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future openGalleryPicker() async {

    await ImagePicker().pickImage(source: ImageSource.gallery).then((image) async {

      if (image != null) {
        File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
                toolbarColor: Colors.blueGrey,
                toolbarTitle: "Crop Image",
                statusBarColor: Colors.blueGrey.shade900,
                backgroundColor: Colors.white,
                hideBottomControls: true
            ));

        this.setState(() {
          profImage = cropped;
          List<int> imageBytes = profImage.readAsBytesSync();
          print(imageBytes);
          String base64ImageTemp = base64Encode(imageBytes);
          flagImgLoaded = false;
          profileImageBase64 =base64ImageTemp;

          print("base 64 ================"+profileImageBase64);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SurePhotoScreen(profileImage: profImage, isFileUploaded: true,)),
          );
          // flagImgLoaded = false;
          // profileImageBase64;
          // profImage;

        });
      } else {}

    });

  }

  Future openCameraPicker() async {

    await ImagePicker().pickImage(source: ImageSource.camera).then((image) async {

      if (image != null) {
        try {


          cropped = await ImageCropper.cropImage(
              sourcePath: image.path,
              aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
              compressQuality: 100,
              maxWidth: 700,
              maxHeight: 700,
              compressFormat: ImageCompressFormat.jpg,
              androidUiSettings: AndroidUiSettings(
                  toolbarColor: Colors.blueGrey,
                  toolbarTitle: "Crop Image",
                  statusBarColor: Colors.blueGrey.shade900,
                  backgroundColor: Colors.white,
                  hideBottomControls: true
              ));
        } catch (e) {

        }
        try {

          this.setState(() {

            profImage = cropped;
            List<int> imageBytes = profImage.readAsBytesSync();
            print(imageBytes);
            String base64ImageTemp = base64Encode(imageBytes);
            flagImgLoaded = false;
            profileImageBase64 = base64ImageTemp;
            print("base64ProfileImage ================"+profileImageBase64);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SurePhotoScreen(profileImage: profImage, isFileUploaded: true,)),
            );
          });
        } catch (e) {
          //  ShowToast.showToast(Colors.green,"error 2 "+ e.toString());

        }
      } else {

      }
    });
  }

}
