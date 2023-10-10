import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SecondRoute extends StatefulWidget {
  String id;

  SecondRoute({this.id});

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                widget.id,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
  }
}


void _onPressed() async {
  var result = await FirebaseFirestore.instance
      .collection("User")
      .where("UserName", isEqualTo: "hussain")
      //.where("population", isGreaterThan: 4000)
      .getDocuments();
  result.docs.forEach((res) {
    print(res.data());
  });
}