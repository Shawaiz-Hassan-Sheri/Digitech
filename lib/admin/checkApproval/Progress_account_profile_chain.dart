import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/admin/checkApproval/updateprogress.dart';
import 'package:minomics/model/usermodel.dart';
import 'package:minomics/screens/homepage.dart';
import 'package:minomics/widgets/mybutton.dart';
import 'package:minomics/widgets/mytextformField.dart';
import 'package:minomics/widgets/notification_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class ProgressProfileChain extends StatefulWidget {
  String id;

  ProgressProfileChain({this.id});
  @override
  _ProfileChainState createState() => _ProfileChainState();
}

class _ProfileChainState extends State<ProgressProfileChain> {
  //  TextEditingController _textController = TextEditingController();
  String name='hussain';
  // This key will be used to show the snack bar
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: userUid));
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }
  UserModel userModel;
  TextEditingController phoneNumber;
  TextEditingController address;
  TextEditingController userName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  bool isMale = false;
  void vaildation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty"),
        ),
      );
    } else if (userName.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Name Is Empty "),
        ),
      );
    } else if (userName.text.length < 6) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 "),
        ),
      );
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11 "),
        ),
      );
    } else {
      userDetailUpdate();
    }
  }

  File _pickedImage;

  PickedFile _image;
  Future<void> getImage({ImageSource source}) async {
    _image = await ImagePicker().getImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }

  String userUid;

  Future<String> _uploadImage({File image}) async {
    StorageReference storageReference =
    FirebaseStorage.instance.ref().child("UserImage/$userUid");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = widget.id;
  }

  bool centerCircle = false;
  var imageMap;
  void userDetailUpdate() async {
    setState(() {
      centerCircle = true;
    });
    _pickedImage != null
        ? imageMap = await _uploadImage(image: _pickedImage)
        : Container();
    FirebaseFirestore.instance.collection("User").doc(userUid).update({
      "UserName": userName.text,
      "UserGender": isMale == true ? "Male" : "Female",
      "UserNumber": phoneNumber.text,
      "UserImage": imageMap,
      "UserAddress": address.text
    });
    setState(() {
      centerCircle = false;
    });
    setState(() {
      edit = false;
    });
  }

  Widget _buildSingleContainer(
      {Color color, String startText, String endText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: edit == false
              ? BorderRadius.circular(30)
              : BorderRadius.circular(0),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                startText,
                style: TextStyle(fontSize: 17, color: Colors.black45),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  endText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String userImage;
  bool edit = false;
  Widget _buildContainerPart() {
    address = TextEditingController(text: userModel.userAddress);
    userName = TextEditingController(text: userModel.userName);
    phoneNumber = TextEditingController(text: userModel.userPhoneNumber);
    if (userModel.userGender == "Male") {
      isMale = true;
    } else {
      isMale = false;
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            _buildSingleContainer(
              endText: userModel.userName,
              startText: "Name",
            ),
            _buildSingleContainer(
              endText: userModel.userEmail,
              startText: "Email",
            ),
            _buildSingleContainer(
              endText: userModel.userGender,
              startText: "Gender",
            ),
            _buildSingleContainer(
              endText: userModel.userPhoneNumber,
              startText: "Phone Number",
            ),
            _buildSingleContainer(
              endText: userModel.userAddress,
              startText: "Address",
            ),


          ],
        ),
      ),
    );
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTextFormFliedPart() {



    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyTextFormField(
            name: "UserName",
            controller: userName,
          ),
          _buildSingleContainer(
            color: Colors.grey[300],
            endText: userModel.userEmail,
            startText: "Email",
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: _buildSingleContainer(
              color: Colors.white,
              endText: isMale == true ? "Male" : "Female",
              startText: "Gender",
            ),
          ),
          MyTextFormField(
            name: "Phone Number",
            controller: phoneNumber,
          ),
          MyTextFormField(
            name: "Address",
            controller: address,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    getUserUid();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile",
          style: TextStyle(fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ),
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
      ),
      /*appBar: AppBar(
        leading: edit == true
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    edit = false;
                  });
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => HomePage(),
                      ),
                    );
                  });
                },
              ),
        backgroundColor: Colors.white,
        actions: [
          edit == false
              ? NotificationButton()
              : IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 30,
                    color:Color.fromARGB(255, 1, 83, 137),
                  ),
                  onPressed: () {
                    vaildation();
                  },
                ),
        ],
      ),*/
      body: centerCircle == false
          ? ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var myDoc = snapshot.data.docs;
                myDoc.forEach((checkDocs) {
                  if (checkDocs.data()["UserId"] == userUid) {
                    userModel = UserModel(
                      userEmail: checkDocs.data()["UserEmail"],
                      userImage: checkDocs.data()["UserImage"],
                      userAddress: checkDocs.data()["UserAddress"],
                      userGender: checkDocs.data()["UserGender"],
                      userName: checkDocs.data()["UserName"],
                      userPhoneNumber: checkDocs.data()["UserNumber"],
                      parentId: checkDocs.data()["ParentId"],
                      progress: checkDocs.data()["Progress"],
                    );
                  }
                });
                return Container(
                  height: height,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomSizedBox(height*0.05),
                      Container(
                        height: height*0.18,
                        width: double.infinity,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                maxRadius: 50,
                                backgroundImage: _pickedImage == null
                                    ? userModel.userImage == null
                                    ? AssetImage(
                                    "images/userImage.png")
                                    : NetworkImage(
                                    userModel.userImage)
                                    : FileImage(_pickedImage)),


                            /*  Container(
                              height:height*0.06,
                              child:Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    myDialogBox(context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                    Colors.transparent,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color:Color.fromARGB(255, 1, 83, 137),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/

                            /* Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: _copyToClipboard,
                                  ),
                                  Text(
                                    userUid,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),*/

                          ],
                        ),
                      ),
                      Container(
                        height: height*0.6,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                child: edit == true
                                    ? Container(
                                  //height:height*0.06,
                                    child: _buildTextFormFliedPart())
                                    : Container(
                                  //height:height*0.06,
                                    child: _buildContainerPart()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: edit == false
                              ? MyButton(
                            name: "Edit Profile",
                            onPressed: () {
                              setState(() {
                                edit = true;
                              });
                            },
                          )
                              : Container(),
                        ),
                      ),*/
                    ],
                  ),
                );
              }),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget CustomSizedBox(double s){
    return SizedBox(
      height: s,
    );
  }
}
