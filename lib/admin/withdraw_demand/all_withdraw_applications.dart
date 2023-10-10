

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/admin/admindashboard.dart';
import 'package:minomics/admin/checkApproval/Progress_account_profile_chain.dart';
import 'package:minomics/admin/checkApproval/checkprogress.dart';
import 'package:minomics/model/usermodel.dart';
import 'package:minomics/screens/homepage.dart';
import 'package:minomics/secondroute.dart';
import 'package:minomics/tree/account_profile_chain.dart';
import 'package:minomics/tree/subaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AllWithdrawApplications extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  @override
  _AllWithdrawApplicationsState createState() => _AllWithdrawApplicationsState();
}

class _AllWithdrawApplicationsState extends State<AllWithdrawApplications> {
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




  void userDetailUpdate(String checkid) async {


    FirebaseFirestore.instance.collection("TransactionsAdmin").doc(checkid).update({

      "Status": "Approved",
    });
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
        title: const Text('All Withdraw Applications'),
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

                title:Text("Account Type : ${data['AccountType']}",style: TextStyle(color: Colors.black),),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [




                    //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                    Text("Status : ${data['Status']}",


                      style: TextStyle(color: Colors.red),


                    ),



                    Text("Account Number : ${data['WithdrawNumber']}",style: TextStyle(color: Colors.black),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(

                          child: ElevatedButton(
                            child: Text(
                                "Accept Withdraw",
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
                              userDetailUpdate(documentSnapshot.id);
                              Navigator.pop(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => CheckProgress(id:documentSnapshot.id)),
                              // );
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
                                MaterialPageRoute(builder: (context) => ProgressProfileChain(id:data['TUserId'])),
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
              .collection('TransactionsAdmin')
              .where("Status", isEqualTo:"Pending")

        //.orderBy('UserName'),
        // to fetch real-time data
        //isLive: false,
      ),
    );
  }
}