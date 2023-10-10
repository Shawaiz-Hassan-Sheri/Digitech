

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/model/usermodel.dart';
import 'package:minomics/secondroute.dart';
import 'package:minomics/tree/account_profile_chain.dart';
import 'package:minomics/tree/subaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AdminEdit extends StatefulWidget {
  String id;
  AdminEdit({this.id});
  @override
  _AdminEditState createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  File _pickedImage;
  TextEditingController userName = TextEditingController();
  String points;
  PickedFile _image;
  Future<void> getImage({ImageSource source}) async {
    _image = await ImagePicker().getImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel userModel;
  String userUid;
  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser.uid;
  }
  void vaildation() async {
    if (userName.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Earning not found "),
        ),
      );
    } else {
      userDetailUpdate();
    }
  }
  void userDetailUpdate() async {
    FirebaseFirestore.instance.collection("User").doc(widget.id).update({
      "Earning": points,
    });
  }
  @override
  Widget build(BuildContext context) {
    getUserUid();
    double height = MediaQuery.of(context).size.height;
    double  width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
        title: const Text('Update Earning '),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                height: height*0.13,
                child: PaginateFirestore(
                  // Use SliverAppBar in header to make it sticky
                  ///header: const SliverToBoxAdapter(child: Text('HEADER')),
                  //footer: const SliverToBoxAdapter(child: Text('FOOTER')),
                  // item builder type is compulsory.
                  itemBuilderType:
                  PaginateBuilderType.listView,
                  //Change types accordingly
                  itemBuilder: (index, context, documentSnapshot) {

                    final data = documentSnapshot.data();


                    return Container(
                      height: height*0.13,
                      child: Card(

                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(width: 1, color:Color.fromARGB(255, 1, 83, 137),)),
                        child: ListTile(

                          // leading: const CircleAvatar(child: Icon(Icons.person)),
                          leading:   CircleAvatar(
                            maxRadius: 25,
                              backgroundImage:  data['UserImage'] == null
                                  ? AssetImage(
                                  "images/userImage.png")
                                  : NetworkImage(
                                  data['UserImage'])
                          ),

                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [



                                  data == null ? const Text('Error in data') : Text(data['UserName'],style: TextStyle(color: Colors.black),),

                                  //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                                  Container(width:width*0.43,child: SingleChildScrollView(scrollDirection:Axis.horizontal,child: Text(data['UserEmail'],style: TextStyle(color: Colors.black),))),
                                  Text(data['UserNumber'],style: TextStyle(color: Colors.black),),


                                ],
                              ),
                              Container(
                                height: height*0.09,
                                child: VerticalDivider(

                                  width: 3,
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text("Earning is : \$",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),),
                                  Text(data['Earning'],style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900),),
                                ],
                              ),
                            ],
                          ),


                        ),
                      ),
                    );
                  },
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore
                      .instance
                      .collection('User')
                      .where("UserId", isEqualTo:widget.id ),
                  //.orderBy('UserName'),
                  // to fetch real-time data
                  //isLive: false,
                ),
              ),
              CustomSizedBox(height*0.03),
              Container(
                height: height*0.1,
                child: TextFormField(

                  controller: userName,

                  onChanged: (value) {
                    //Do something with the user input.
                    setState(() {
                      points = value;

                    });
                  },
                  cursorColor: Colors.black,
                  style: TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: 'Earning',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(

                    child: InkWell(
                      child: ElevatedButton(
                        child: Text(
                            "Update Earning",
                            style: TextStyle(fontSize: 16)
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 1, 83, 137),),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
                                )
                            )
                        ),

                        onPressed: (){
                          vaildation();
                          Navigator.pop(context);
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubAccounts(id:documentSnapshot.id)),
                          );*/
                        },
                      ),
                    ),
                  ),

                ],
              ),






            ],
          ),
        ),
      ),
    );
  }
  Widget CustomSizedBox(double s){
    return SizedBox(
      height: s,
    );
  }

}