

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/secondroute.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Check_Data extends StatefulWidget {
 // const HomePage({Key? key}) : super(key: key);
  @override
  _Check_DataState createState() => _Check_DataState();
}

class _Check_DataState extends State<Check_Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore pagination example'),
        centerTitle: true,
      ),
      body: PaginateFirestore(
        // Use SliverAppBar in header to make it sticky
        ////header: const SliverToBoxAdapter(child: Text('HEADER')),
      //  footer: const SliverToBoxAdapter(child: Text('FOOTER')),
        // item builder type is compulsory.
        itemBuilderType:
        PaginateBuilderType.listView,
        //Change types accordingly
        itemBuilder: (index, context, documentSnapshot) {
          final data = documentSnapshot.data() as Map;
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title:
            data == null ? const Text('Error in data') : Text(data['UserName'],style: TextStyle(color: Colors.black),),
            subtitle: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute(id:documentSnapshot.id)),
                  );
                },
              //  child: Text(documentSnapshot.id,style: TextStyle(color: Colors.black),)),
                child: Text(data['UserId'],style: TextStyle(color: Colors.amberAccent),)),
          );
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance.collection('User').orderBy('UserName'),
        // to fetch real-time data
        //isLive: true,
      ),
    );
  }
}