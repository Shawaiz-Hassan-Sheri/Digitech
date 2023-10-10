

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

class AllWithdraws extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  @override
  _AllWithdrawsState createState() => _AllWithdrawsState();
}

class _AllWithdrawsState extends State<AllWithdraws> {
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
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
        title: const Text('Transaction history'),
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

              title:Text("Account Type : ${data['AccountType']}",style: TextStyle(color: Colors.black),),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text("Status : ${data['Status']}",


                    style: TextStyle(color: Colors.green),


                  ),



                  //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                  Text("Account Number : ${data['WithdrawNumber']}",style: TextStyle(color: Colors.black),),
                  Text("Date : ${data['Date']}",style: TextStyle(color: Colors.black),),

                ],
              ),


            ),
          );
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore
            .instance
            .collection('TransactionsAdmin')
            .where("TUserId", isEqualTo:userUid ),
        //.orderBy('UserName'),
        // to fetch real-time data
        //isLive: false,
      ),
    );
  }
}