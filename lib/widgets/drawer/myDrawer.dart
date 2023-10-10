
import 'package:minomics/model/usermodel.dart';
import 'package:minomics/screens/contactus.dart';
import 'package:minomics/screens/homepage.dart';
import 'package:minomics/screens/profilescreen.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  myListTile(
      BuildContext context,
      double height,
      IconData tileIcon,
      String title,
      String pushName,
      Color color,
      ) {
    return Card(
      color: color,
      child: ListTile(
        leading: Icon(tileIcon, size: height * 0.035),
        title: Text(title),
        onTap: () => Navigator.pushNamed(context, pushName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final themeChange = Provider.of<DarkThemeProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget _buildUserAccountsDrawerHeader() {
      List<UserModel> userModel = productProvider.userModelList;
      return Column(

          children: userModel.map((e) {
            return UserAccountsDrawerHeader(

              accountName: Text(
                e.userName,


                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: e.userImage == null
                    ? AssetImage("images/userImage.png")
                    : NetworkImage(e.userImage),
              ),
              //decoration: BoxDecoration(color: Color(0xfff2f2f2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 1, 83, 137),),
              accountEmail: Text(
                  e.userEmail, style: TextStyle(color: Colors.white)),
            );
          }).toList()


      );
    }
    return SizedBox(
      width: width * 0.835,
      height: height,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildUserAccountsDrawerHeader(),
              CustomSizedBox(height * 0.02),
              Divider(
                height: 2,
                thickness: 2,
                color: Colors.grey,
              ),
              CustomSizedBox(height * 0.04),
              Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => HomePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => ProfileScreen(),
                          ),
                        );
                      },
                      leading: Icon(Icons.info),
                      title: Text("Profile"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => ContactUs()));
                      },
                      leading: Icon(Icons.phone),
                      title: Text("Contant Us",style: TextStyle(color: Colors.black),),
                    ),
                  ),

                ],
              ),
              CustomSizedBox(height * 0.09),

              Align(
                alignment: Alignment.bottomCenter,
                child:Image.asset(
                    "images/logo.png",
                  width:width*0.2 ,
                  height:height*0.2 ,

                )
              ),

              
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "DigiTech Marketing",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:  Text(
                  "Version: 1.0.0\n",
                  style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height * 0.015),
                )
              ),


            ],
          ),
        ),
      ),
    );
  }
  Widget CustomSizedBox(double s) {
    return SizedBox(
      height: s,
    );
  }
}



/*

import 'package:minomics/model/usermodel.dart';
import 'package:minomics/screens/contactus.dart';
import 'package:minomics/screens/homepage.dart';
import 'package:minomics/screens/profilescreen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(

        children: userModel.map((e) {
          return UserAccountsDrawerHeader(

            accountName: Text(
              e.userName,


              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: e.userImage == null
                  ? AssetImage("images/userImage.png")
                  : NetworkImage(e.userImage),
            ),
            //decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            decoration: BoxDecoration(color: Color.fromARGB(255, 1, 83, 137),),
            accountEmail: Text(
                e.userEmail, style: TextStyle(color: Colors.white)),
          );
        }).toList()


    );
  }
  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.835,
      height: height,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListView(

                children: <Widget>[
                  _buildUserAccountsDrawerHeader(),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),

                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => ProfileScreen(),
                        ),
                      );
                    },
                    leading: Icon(Icons.info),
                    title: Text("Profile"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => ContactUs()));
                    },
                    leading: Icon(Icons.phone),
                    title: Text("Contant Us",style: TextStyle(color: Colors.black),),
                  ),

                ],
              ),
            //  AppVersion()
            ],
          ),
        ),
      ),
    );
  }
}
*/
