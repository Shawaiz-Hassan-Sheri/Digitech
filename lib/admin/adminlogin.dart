import 'package:minomics/admin/admindashboard.dart';
import 'package:minomics/screens/login.dart';
import 'package:minomics/screens/signup.dart';
import 'package:minomics/widgets/changescreen.dart';
import 'package:minomics/widgets/mytextformField.dart';
import 'package:minomics/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/mybutton.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final TextEditingController password = TextEditingController();

bool obserText = true;

class _AdminLoginState extends State<AdminLogin> {


  void submit(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text, password: password.text);
      /*Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => AdminHomePage()));*/
      print(result);
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message;
      }
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message.toString()),
          duration: Duration(milliseconds: 800),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => AdminHomePage()));
    setState(() {
      isLoading = false;
    });
  }

  void vaildation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Both Flied Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (email.text != "admin@gmail.com" && password.text != "admin1234") {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Error"),
        ),
      );
    }
    else if (password.text.length < 8) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    }
    else {
      submit(context);

    }
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,

        body: Form(
          key: _formKey,
          child: Container(

            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomSizedBox(height*0.08),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                    child: Image.asset('images/logo.png'),

                  ),
                  CustomSizedBox(height*0.05),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: <Widget>[
                            MyTextFormField(
                              name: "Email",
                              controller: email,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            PasswordTextFormField(
                              obserText: obserText,
                              name: "Password",
                              controller: password,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  obserText = !obserText;
                                });
                              },
                            ),
                            CustomSizedBox(height*0.03),

                            isLoading == false
                                ?
                            MyButton(
                              onPressed: () {
                                vaildation();
                              },
                              name: "Login",
                            )
                                : Center(
                              child: CircularProgressIndicator(),
                            ),


                            CustomSizedBox(height*0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChangeScreen(
                                    name: "UserLogin",
                                    whichAccount: "Goto User Portal",
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (ctx) => Login(),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
