

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/admin/admindashboard.dart';
import 'package:minomics/admin/checkApproval/Progress_account_profile_chain.dart';
import 'package:minomics/admin/checkApproval/checkprogress.dart';
import 'package:minomics/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ApdateAccountProgress extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  @override
  _Check_DataState createState() => _Check_DataState();
}

class _Check_DataState extends State<ApdateAccountProgress> {
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
  UserModel userModel;
  String userUid;
  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    getUserUid();
    return Scaffold(
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
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
        title: const Text('Accounts'),
        centerTitle: true,
      ),
      body: PaginateFirestore(
        // Use SliverAppBar in header to make it sticky
        ///header: const SliverToBoxAdapter(child: Text('HEADER')),
        //footer: const SliverToBoxAdapter(child: Text('FOOTER')),
        // item builder type is compulsory.
        itemBuilderType:
        PaginateBuilderType.listView,
        //Change types accordingly
        itemBuilder: (index, context, documentSnapshot) {

          final data = documentSnapshot.data();


          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(width: 1, color:Color.fromARGB(255, 1, 83, 137),)),
            child: ListTile(

              // leading: const CircleAvatar(child: Icon(Icons.person)),
              leading:   CircleAvatar(
                //maxRadius: 25,
                  backgroundImage:  data['UserImage'] == null
                      ? AssetImage(
                      "images/userImage.png")
                      : NetworkImage(
                      data['UserImage'])
              ),
              title: data == null ? const Text('Error in data') : Text(data['UserName'],style: TextStyle(color: Colors.black),),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [




                  //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                  Text(data['UserEmail'],style: TextStyle(color: Colors.black),),
                  Text(data['UserNumber'],style: TextStyle(color: Colors.black),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(

                        child: ElevatedButton(
                          child: Text(
                              "Check Progress",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CheckProgress(id:documentSnapshot.id)),
                            );
                          },
                        ),
                      ),
                      Container(

                        child: ElevatedButton(
                          child: Text(
                              "Profile",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProgressProfileChain(id:documentSnapshot.id)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),


            ),
          );
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore
            .instance
            .collection('User')
            .where("Progress", isEqualTo:"Inprogress")

        //.orderBy('UserName'),
        // to fetch real-time data
        //isLive: false,
      ),
    );
  }
}