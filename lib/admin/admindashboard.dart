import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/admin/chain/admin_profile.dart';
import 'package:minomics/admin/checkApproval/updateprogress.dart';
import 'package:minomics/admin/withdraw_demand/all_withdraw_applications.dart';
import 'package:minomics/model/usermodel.dart';
import 'package:flutter/cupertino.dart';

import '../provider/product_provider.dart';
import '../provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import 'chain/admin_accounts.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

Product menData;
CategoryProvider categoryProvider;
ProductProvider productProvider;

Product womenData;

Product bulbData;

Product smartPhoneData;

class _AdminHomePageState extends State<AdminHomePage> {
  Widget _buildCategoryProduct({String image, int color}) {
    return CircleAvatar(
      maxRadius: height * 0.1 / 2.1,
      backgroundColor: Color(color),
      child: Container(
        height: 40,
        child: Image(
          color: Colors.white,
          image: NetworkImage(image),
        ),
      ),
    );
  }

  double height, width;
  bool homeColor = true;

  bool checkoutColor = false;

  bool aboutColor = false;

  bool contactUsColor = false;
  bool profileColor = false;
  MediaQueryData mediaQuery;
  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
        children: userModel.map((e) {
          return UserAccountsDrawerHeader(
            accountName: Text(
              e.userName,
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: e.userImage == null
                  ? AssetImage("images/userImage.png")
                  : NetworkImage(e.userImage),
            ),
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            accountEmail: Text(e.userEmail, style: TextStyle(color: Colors.black)),
          );
        }).toList());
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),

         /* ListTile(
            selected: checkoutColor,
            onTap: () {
              setState(() {
                checkoutColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => CheckOut()));
            },
            leading: Icon(Icons.shopping_cart),
            title: Text("Checkout"),
          ),*/
         /* ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => About()));
            },
            leading: Icon(Icons.info),
            title: Text("About"),
          ),*/
          ListTile(
            selected: checkoutColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                checkoutColor = true;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => AdminProfileScreen(),
                ),
              );
            },
            leading: Icon(Icons.info),
            title: Text("Profile"),
          ),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                homeColor = true;
                profileColor = false;
                checkoutColor = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApdateAccountProgress()),
              );

            },
            leading: Icon(Icons.account_box_sharp),
            title: Text("Inprogress Accounts"),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                homeColor = false;
                profileColor = true;
                checkoutColor = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllWithdrawApplications()),
              );

            },
            leading: Icon(Icons.monetization_on_rounded),
            title: Text(" Withdraw Applications"),
          ),
          /*ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                checkoutColor = false;
                profileColor = false;
                homeColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ContactUs()));
            },
            leading: Icon(Icons.phone),
            title: Text("Contant Us"),
          ),*/
         /* ListTile(
            onTap: () {
               FirebaseAuth.instance.signOut();
            *//*  Navigator.of(context)
                  .pushAndRemoveUntil(
                CupertinoPageRoute(
                    builder: (context) => Login()
                ),
                    (_) => false,
              );*//*
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),*/
        ],
      ),
    );
  }





  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  void getCallAllFunction() {
    categoryProvider.getShirtData();
    categoryProvider.getDressData();
    categoryProvider.getShoesData();
    categoryProvider.getPantData();
    categoryProvider.getTieData();
    categoryProvider.getDressIconData();
    productProvider.getNewAchiveData();
    productProvider.getFeatureData();
    productProvider.getHomeFeatureData();
    productProvider.getHomeAchiveData();
    categoryProvider.getShirtIcon();
    categoryProvider.getshoesIconData();
    categoryProvider.getPantIconData();
    categoryProvider.getTieIconData();
    productProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);
    getCallAllFunction();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Text(
          "HomePage",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              _key.currentState.openDrawer();
            }),
        /*  actions: <Widget>[
          NotificationButton(),
        ],*/
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomSizedBox(height*0.1),


                  /* GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Accounts()),
                      );
                    },
                    child: Container(
                      child:Text("Accounts") ,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GestureDetector(
                      onTap:(){
                        _onPressed();
                      },
                      child: Container(
                        child:Text("check") ,
                      ),
                    ),
                  ),*/

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(

                        height: height*0.15,
                        child: ElevatedButton(
                          child: Text(
                              "Admin Chain",
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
                              MaterialPageRoute(builder: (context) => AdminAccounts()),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
          ],
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
/*
void _onPressed() async {
  var  result = await FirebaseFirestore.instance
      .collection("User")
      .where("UserName", isEqualTo: "hussain")
  //.where("population", isGreaterThan: 4000)
      .get();

  result.docs.forEach((res) {




    print(res.data());
  });
}*/
