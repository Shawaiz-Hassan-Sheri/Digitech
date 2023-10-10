
import 'package:animated_sliced_button/animated_sliced_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/screens/history/allwithdraws.dart';
import 'package:minomics/screens/history/checktransfermoney.dart';
import 'package:minomics/tree/accounts.dart';
import 'package:minomics/model/categoryicon.dart';
import 'package:minomics/model/usermodel.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:async';
import 'package:minomics/screens/contactus.dart';


import 'package:minomics/screens/profilescreen.dart';
import 'package:minomics/widgets/drawer/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/product_provider.dart';
import '../provider/category_provider.dart';
import 'package:minomics/screens/listproduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}
double width;
double height12;
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
   AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

   bool _canBeDragged;

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / width * 0.835;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: new Text(
          "Exit Application",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: new Text("Are You Sure?"),
        actions: <Widget>[
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              exit(0);
            },
          ),
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              "No",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ) as FutureOr<bool>)) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

     width = MediaQuery.of(context).size.width;
     height12 = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Material(
              color: Color.fromARGB(255, 1, 83, 137),
                child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(
                          width * 0.835 * (animationController.value - 1), 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              math.pi / 2 * (1 - animationController.value)),
                        alignment: Alignment.centerRight,
                        child: MyDrawer(),
                      ),
                    ),

                    Transform.translate(
                      offset: Offset(
                          width * 0.835 * animationController.value, 0),
                      child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(-math.pi / 2 * animationController.value),
                          alignment: Alignment.centerLeft,
                          child: MainScreen()),
                    ),
                    Positioned(
                      top: height12*0.01,
                      left: width * 0.01 + animationController.value *  width * 0.835,
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: toggle,
                        color:
                        Colors.white
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}








class MainScreen extends StatefulWidget {


  @override
  _MainScreenState createState() => _MainScreenState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
String checkprogres = '';

Product menData;
CategoryProvider categoryProvider;
ProductProvider productProvider;

Product womenData;

Product bulbData;

Product smartPhoneData;


class _MainScreenState extends State<MainScreen> {

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


  String earnig = "";
  bool checkoutColor = false;

  bool aboutColor = false;

  bool contactUsColor = false;
  bool profileColor = false;
  MediaQueryData mediaQuery;

  String day_select = DateFormat.d().format(DateTime.now());


  Widget showalert(String text) {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$text"),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget Check_inprogress() {
    List<UserModel> userModel = productProvider.userModelList;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color.fromARGB(255, 1, 83, 137),
      ),

      width: width * 0.3,
      height: height * 0.15,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: userModel.map((e) {
            return InkWell(
              onTap: () {



                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>
                //       CheckTransfermoney(tname: e.userName,
                //         tearning: e.earning,
                //         tuserid: userUid,)),
                // );
              },
              child: Container(
                child: Text("Withdraw",
                  style: TextStyle(color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),

                ),
              ),
            );
          }).toList()


      ),
    );
  }

  Widget _buildNextClass() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: userModel.map((e) {
          return SizedBox(
            width: width * 0.6,
            height: height * 0.091,
            child: PushableButton(
              //width: width * 0.3,
              //height: height * 0.15,
              height: 60,
              elevation: 8,
              hslColor: HSLColor.fromAHSL(1.0, 204, .99, 0.27),

              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
              child:  Text("Withdraw",
                style: TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),

              ),
              onPressed: () {
                day_select=="15"?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckTransfermoney(tname: e.userName,tearning: e.earning,tuserid: userUid,)),
                ): showalert("You can only withdraw on 15 ");
              },
            ),
          );
        }).toList()


    );
  }

  Widget show_earning() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
        children: userModel.map((e) {
          return Container(
            width: width * 0.3,
            height: height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Earning",

                  style: TextStyle(color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  "\$ ${e.earning}",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )

              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 1, 83, 137),
            ),

          );
        }).toList()


    );
  }
  String userUid;
  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser.uid;
  }







  Widget _buildImageSlider() {
    return Container(
      width: width,
      height: height * 0.3,
      child: Image.asset("images/banner.jpeg"),
    );
  }

  Widget _buildDressIcon() {
    List<CategoryIcon> dressIcon = categoryProvider.getDressIcon;
    List<Product> dress = categoryProvider.getDressList;
    return Row(
        children: dressIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ListProduct(
                        name: "Dress",
                        snapShot: dress,
                      ),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xff33dcfd),
          );
        }).toList());
  }

  Widget _buildShirtIcon() {
    List<Product> shirts = categoryProvider.getShirtList;
    List<CategoryIcon> shirtIcon = categoryProvider.getShirtIconData;
    return Row(
        children: shirtIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ListProduct(
                        name: "Shirt",
                        snapShot: shirts,
                      ),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xfff38cdd),
          );
        }).toList());
  }

  void _getdata() async {
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection('User')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        checkprogres = userData.data()['Progress'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  Widget _buildShoeIcon() {
    List<CategoryIcon> shoeIcon = categoryProvider.getShoeIcon;
    List<Product> shoes = categoryProvider.getshoesList;
    return Row(
        children: shoeIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ListProduct(
                        name: "Shoes",
                        snapShot: shoes,
                      ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff4ff2af,
            ),
          );
        }).toList());
  }

  Widget _buildPantIcon() {
    List<CategoryIcon> pantIcon = categoryProvider.getPantIcon;
    List<Product> pant = categoryProvider.getPantList;
    return Row(
        children: pantIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ListProduct(
                        name: "Pant",
                        snapShot: pant,
                      ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff74acf7,
            ),
          );
        }).toList());
  }

  Widget _buildTieIcon() {
    List<CategoryIcon> tieIcon = categoryProvider.getTieIcon;
    List<Product> tie = categoryProvider.getTieList;
    return Row(
        children: tieIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ListProduct(
                        name: "Tie",
                        snapShot: tie,
                      ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xfffc6c8d,
            ),
          );
        }).toList());
  }

  /*Widget _buildCategory() {
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1 - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Category",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          child: Row(
            children: <Widget>[
              _buildDressIcon(),
              _buildShirtIcon(),
              _buildShoeIcon(),

            ],
          ),
        ),
      ],
    );
  }*/


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
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    getUserUid();
    return SafeArea(
      child: Scaffold(

          key: _key,
          // drawer: _buildMyDrawer(),

          appBar: AppBar(

           title: Text('DigiTech Marketing',style: TextStyle(color: Colors.white),),
            centerTitle: true,
            elevation: 0.0,
            // backgroundColor: Colors.grey[100],
            backgroundColor: Color.fromARGB(255, 1, 83, 137),

          ),
          body:  checkprogres!="Inprogress"?

          Container(
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

                      _buildImageSlider(),
                      //_buildCategory(),
                      SizedBox(
                        height: 20,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.6,
                            height: height * 0.091,
                            child: PushableButton(
                              //width: width * 0.3,
                              //height: height * 0.15,
                              height: 60,
                              elevation: 8,
                              hslColor: HSLColor.fromAHSL(1.0, 204, .99, 0.27),

                              shadow: BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                              child: Text("Mentor",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),

                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Accounts()),
                                );
                              },
                            ),
                          ),

                          CustomSizedBox(height * 0.02),
                          _buildNextClass(),
                          CustomSizedBox(height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              show_earning(),
                              Container(

                                width: width * 0.3,
                                height: height * 0.15,
                                child: ElevatedButton(

                                  child: Text("History", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),),

                                  style: ButtonStyle(

                                      foregroundColor: MaterialStateProperty.all<
                                          Color>(Colors.white),
                                      backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                        Color.fromARGB(255, 1, 83, 137),),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(30),
                                            // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
                                          )
                                      )

                                  ),



                                  onPressed: () {
                                    // Next();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllWithdraws()),
                                    );
                                  },
                                ),
                              ),

                            ],
                          ),
                          CustomSizedBox(height * 0.03),


                          Container(
                            width: width * 0.25,
                            height: height * 0.1,
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


                                return  Container(
                                  width: width * 0.25,
                                  height: height * 0.1,
                                  child: ElevatedButton(
                                    child: Shimmer.fromColors(
                                        baseColor: Colors.black,
                                        highlightColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Points", style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),),
                                            Text('${data['SelectedPackage']}', style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),),
                                          ],
                                        )
                                    ),
                                    style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<
                                            Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<
                                            Color>(Colors.yellowAccent,),
                                        // backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 1, 83, 137),),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(

                                              borderRadius: BorderRadius.circular(50),
                                              // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
                                            )
                                        )
                                    ),

                                    onPressed: () {

                                      /* Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Accounts()),
                                    );*/
                                    },
                                  ),
                                );
                              },
                              // orderBy is compulsory to enable pagination
                              query: FirebaseFirestore
                                  .instance
                                  .collection('User')
                                  .where("UserId", isEqualTo:userUid ),
                              //.orderBy('UserName'),
                              // to fetch real-time data
                              //isLive: false,
                            ),
                          ),




                        ],
                      ),
                    ],
                  ),
                )

              ],
            ),
          )
        : Center(child: Text("Your Account is not Approved...",style: TextStyle(
            fontWeight: FontWeight.w900
          ),),)


      ),
    );
  }

  Widget CustomSizedBox(double s) {
    return SizedBox(
      height: s,
    );
  }

  Widget Next() {
    print("yes next class");
  }

  Widget Next2() {
    print("yes next class 2");
  }


}

void _onPressed() async {
  var result = await FirebaseFirestore.instance
      .collection("User")
      .where("UserName", isEqualTo: "hussain")
  //.where("population", isGreaterThan: 4000)
      .get();

  result.docs.forEach((res) {
    print(res.data());
  });
}
