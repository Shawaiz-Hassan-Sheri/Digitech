import 'package:minomics/model/usermodel.dart';
import 'package:minomics/widgets/constants.dart';
import 'package:minomics/widgets/mybutton.dart';
import 'package:minomics/widgets/mytextformField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class CheckTransfermoney extends StatefulWidget {
  String tname;
  String tearning;
  String tuserid;

  CheckTransfermoney({this.tname, this.tuserid, this.tearning});

  @override
  _CheckTransfermoneyState createState() => _CheckTransfermoneyState();
}

class _CheckTransfermoneyState extends State<CheckTransfermoney> {
  final TextEditingController withdraw_number = TextEditingController();

  List<String> __accounts = ['Easypaisa', 'JazzCash', 'Bank Account Number'];
  String _selectedaccount = 'Easypaisa';

  showAlertDialog(BuildContext context, String content) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        amountcontroller.text = '';
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextStyle _textStyle(double x) {
    return TextStyle(
        fontSize: x, fontWeight: FontWeight.w600, color: Colors.white);
  }

  TextEditingController amountcontroller = new TextEditingController();
  var trans = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel userModel;
  String userUid;

  void getUserUid() {
    User myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser.uid;
  }

  void userDetailUpdate() async {
    FirebaseFirestore.instance.collection("User").doc(userUid).update({
      "Earning": '0',
    });
  }

  double height, width;

  bool transaupload = false;
  bool backhappy = false;

  void submit() async {
    UserCredential result;

    FirebaseFirestore.instance.collection("User").doc(result.user.uid).set({
      "Withdraw Number": withdraw_number.text,
      "UserId": result.user.uid,
    });

    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
    //  "Date": DateFormat().format(DateTime.now()),

  }

  void vaildation() async {
    if (withdraw_number.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Enter Credentials"),
        ),
      );
    }
  }

  Widget _buildAllTextFormField() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //parentid
          MyTextFormField(
            name: "Enter Account Number",
            controller: withdraw_number,
          ),
        ],
      ),
    );
  }

  Widget Easypaisa() {
    return Container(
      child: _buildAllTextFormField(),
    );
  }

  Widget JazzCash() {
    return Container(
      child: _buildAllTextFormField(),
    );
  }

  Widget BankAccount() {
    return Container(
      child: _buildAllTextFormField(),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserUid();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);

            // AlertDialog al = AlertDialog(
            //     title: Text("Congratulations"),
            //     content: Text('Withdraw Succesfull.'));
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return al;
            //   },
            // );

            setState(() {
              uploadcheck = 0;
            });
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
        title: const Text('Withdraw'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child:
          widget.tearning!='0'?
          Column(
            children: [
              Container(
                height: height * 0.13,
                child: PaginateFirestore(
                  // Use SliverAppBar in header to make it sticky
                  ///header: const SliverToBoxAdapter(child: Text('HEADER')),
                  //footer: const SliverToBoxAdapter(child: Text('FOOTER')),
                  // item builder type is compulsory.
                  itemBuilderType: PaginateBuilderType.listView,
                  //Change types accordingly
                  itemBuilder: (index, context, documentSnapshot) {
                    final data = documentSnapshot.data();

                    return Container(
                      height: height * 0.13,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 1, 83, 137),
                            )),
                        child: ListTile(
                          // leading: const CircleAvatar(child: Icon(Icons.person)),
                          leading: CircleAvatar(
                              maxRadius: 25,
                              backgroundImage: data['UserImage'] == null
                                  ? AssetImage("images/userImage.png")
                                  : NetworkImage(data['UserImage'])),

                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  data == null
                                      ? const Text('Error in data')
                                      : Text(
                                          data['UserName'],
                                          style: TextStyle(color: Colors.black),
                                        ),

                                  //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                                  Text(
                                    data['UserEmail'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    data['UserNumber'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 0.09,
                                child: VerticalDivider(
                                  width: 3,
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Earning is : \$",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    data['Earning'],
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance
                      .collection('User')
                      .where("UserId", isEqualTo: userUid),
                  //.orderBy('UserName'),
                  // to fetch real-time data
                  //isLive: false,
                ),
              ),

              CustomSizedBox(height * 0.03),
              //select bank
              Container(
                //height: height*0.06,
                width: width * 0.6,
                decoration: BoxDecoration(
                    color: Color(0XFFEFF3F6),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(6, 2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0),
                      BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          offset: Offset(-6, -2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0)
                    ]),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      value: _selectedaccount,
                      onChanged: (value) {
                        setState(() {
                          _selectedaccount = value;
                        });
                      },
                      items: __accounts.map((location) {
                        return DropdownMenuItem(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("$location")),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              CustomSizedBox(height * 0.03),

              //Functions call depend on bank select

              if (_selectedaccount == 'Easypaisa')
                Easypaisa()
              else if (_selectedaccount == 'JazzCash')
                JazzCash()
              else if (_selectedaccount == 'Bank Account Number')
                BankAccount(),

              //withdraw request to admin
              CustomSizedBox(height * 0.03),
              Container(
                  margin: EdgeInsets.all(30),
                  child: GestureDetector(
                    onTap: () {
                      vaildation();
                      userDetailUpdate();


                      FirebaseFirestore.instance
                          .collection("TransactionsAdmin")
                          .doc()
                          .set({
                        "AccountType" :_selectedaccount,
                        "WithdrawNumber": withdraw_number.text,
                        "TName": widget.tname,
                        "Date": DateFormat().format(DateTime.now()),
                        "Amount": widget.tearning,
                        "TUserId": userUid,
                        "Status": "Pending"

                      });
                      setState(() {
                        uploadcheck = 0;
                      });

                      Navigator.pop(context);

                      AlertDialog al = AlertDialog(
                          title: Text("Congratulations"),
                          content: Text('Inprogress Withdraw Succesfull.'));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return al;
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: InkWell(
                            child: ElevatedButton(

                              child: Text("withdraw Earning",
                                  style: TextStyle(fontSize: 16)),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 1, 83, 137),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
                                  ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )
          : Column(
            children: [
              Container(
                height: height * 0.13,
                child: PaginateFirestore(
                  // Use SliverAppBar in header to make it sticky
                  ///header: const SliverToBoxAdapter(child: Text('HEADER')),
                  //footer: const SliverToBoxAdapter(child: Text('FOOTER')),
                  // item builder type is compulsory.
                  itemBuilderType: PaginateBuilderType.listView,
                  //Change types accordingly
                  itemBuilder: (index, context, documentSnapshot) {
                    final data = documentSnapshot.data();

                    return Container(
                      height: height * 0.13,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 1, 83, 137),
                            )),
                        child: ListTile(
                          // leading: const CircleAvatar(child: Icon(Icons.person)),
                          leading: CircleAvatar(
                              maxRadius: 25,
                              backgroundImage: data['UserImage'] == null
                                  ? AssetImage("images/userImage.png")
                                  : NetworkImage(data['UserImage'])),

                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  data == null
                                      ? const Text('Error in data')
                                      : Text(
                                    data['UserName'],
                                    style: TextStyle(color: Colors.black),
                                  ),

                                  //Text(documentSnapshot.id,style: TextStyle(color: Colors.black),),
                                  Text(
                                    data['UserEmail'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    data['UserNumber'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 0.09,
                                child: VerticalDivider(
                                  width: 3,
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Earning is : \$",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    data['Earning'],
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance
                      .collection('User')
                      .where("UserId", isEqualTo: userUid),
                  //.orderBy('UserName'),
                  // to fetch real-time data
                  //isLive: false,
                ),
              ),

              CustomSizedBox(height * 0.03),
              //select bank

              //Functions call depend on bank select



              //withdraw request to admin
              CustomSizedBox(height * 0.03),
              Container(
                  margin: EdgeInsets.all(30),
                  child: GestureDetector(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: InkWell(
                            child: ElevatedButton(

                              child: Text("Not Enough Money To Withdraw",
                                  style: TextStyle(fontSize: 16)),
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 1, 83, 137),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )
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
