import 'dart:io';
import 'package:minomics/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minomics/model/usermodel2.dart';
import 'package:minomics/screens/login.dart';
import 'package:minomics/widgets/changescreen.dart';
import 'package:minomics/widgets/mybutton.dart';
import 'package:minomics/widgets/mytextformField.dart';
import 'package:minomics/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obserText = true;
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final TextEditingController phoneNumber = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController address = TextEditingController();

final TextEditingController parentid = TextEditingController();

final TextEditingController fatherName = TextEditingController();
final TextEditingController cnic = TextEditingController();
final TextEditingController city = TextEditingController();

bool isMale = true;
bool isLoading = false;

class _SignUpState extends State<SignUp> {
  List<int> _packages = [5,10,15,17];
  int _selectedPackage = 5;
  String userUid;


  int uploadcheck =0;
  bool uploadimage=false;
 String progresscheck="Inprogress";
  /* void NotificationButton(){
  submit();
   }*/







  void userDetailUpdate(String id,int sum) async {
    FirebaseFirestore.instance.collection("User").doc(id).update({
      "SelectedPackage": sum,
    });
  }







  void getCurrentUserData(String idnext,int packagenext ) async{
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('User').doc(idnext).get();


      int enrollpacakge=packagenext;

      int checkpackage = ds.get('SelectedPackage');
      int usrid = ds.get('UserId');
      int sum1=checkpackage+enrollpacakge;

      userDetailUpdate(idnext,sum1);

      if(usrid=="XtEkn1xgC3dzhYoza3BNjYKtHy53"){
        return;

      }
      else{
        String checkid = ds.get('ParentId');
        getCurrentUserData(checkid,enrollpacakge);
      }





    }catch(e){
      print(e.toString());
      return null;
    }
  }




  void submit() async {
    UserCredential result;
    try {
      setState(() {
        isLoading = true;
      });
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print(result);
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message;
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message.toString()),
        duration: Duration(milliseconds: 600),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: Duration(milliseconds: 600),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      print(error);
    }

    _pickedImage != null
        ? imageMap = await _uploadImage(image: _pickedImage)
        : print("not working");
    FirebaseFirestore.instance.collection("User").doc(result.user.uid).set({
      "UserName": userName.text,
      "UserId": result.user.uid,
      "UserEmail": email.text,
      "UserAddress": address.text,
      "UserGender": isMale == true ? "Male" : "Female",
      "UserNumber": phoneNumber.text,
      "ParentId": parentid.text,
      "FatherName": fatherName.text,
      "CNIC": cnic.text,
      "CITY": city.text,
      "SelectedPackage": _selectedPackage,
      "Progress":progresscheck,
      "UserTransactionImage": imageMap,
      "Date" :  DateFormat().format(DateTime.now()),


    });


    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
    setState(() {
      isLoading = false;
    });
  }

  void vaildation() async {
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        parentid.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        fatherName.text.isEmpty &&
        cnic.text.isEmpty &&
        city.text.isEmpty &&
        address.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty"),
        ),
      );
    }
    else if (parentid.text.length < 28 || parentid.text.length >28) {
      _scaffoldKey.currentState.showSnackBar(

        SnackBar(
          content: Text("Parent Id Needed"),
        ),

      );
    }
    else if (userName.text.length < 6) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 "),
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
    } else if (password.text.length < 8) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11 "),
        ),
      );
    } else if (address.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Adress Is Empty "),
        ),
      );
    } else {
      getCurrentUserData(parentid.text,_selectedPackage);
      submit();
    }
  }

  Widget _buildAllTextFormField() {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //parentid
          MyTextFormField(
            name: "ParentId",
            controller: parentid,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "UserName",
            controller: userName,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Father Name",
            controller: fatherName,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "CNIC",
            controller: cnic,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "City",
            controller: city,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Email",
            controller: email,
          ),
          SizedBox(
            height: 10,
          ),
          PasswordTextFormField(
            obserText: obserText,
            controller: password,
            name: "Password",
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                obserText = !obserText;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      isMale == true ? "Male" : "Female",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Phone Number",
            controller: phoneNumber,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Address",
            controller: address,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            //height: height*0.06,
            // width: width,
            decoration: BoxDecoration(
                color: Color(0XFFEFF3F6),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(6, 2),
                      blurRadius: 6.0,
                      spreadRadius: 3.0
                  ),
                  BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.9),
                      offset: Offset(-6, -2),
                      blurRadius: 6.0,
                      spreadRadius: 3.0
                  )
                ]
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: _selectedPackage,
                  onChanged: (value) {
                    setState(() {
                      _selectedPackage = value;

                    });
                  },
                  items: _packages.map((location) {
                    return DropdownMenuItem(
                      child: new Text("\$ $location"),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildAllTextFormField(),
            SizedBox(
              height: 15,
            ),
             MyButton(
              name: "Upload transaction image",
              onPressed: () {
                myDialogBox(context);
               // vaildation();
              },
            ),
            SizedBox(
              height: 15,
            ),
            isLoading == false
                ? MyButton(
                    name: "SignUp",
                    onPressed: () {
                      vaildation();
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            SizedBox(
              height: 15,
            ),
            ChangeScreen(
              name: "Login",
              whichAccount: "I Have Already An Account!",
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => Login(),
                  ),
                );
              },

            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
  //upload transaction image to admin
  UserModel2 userModel2;
  bool check=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  File _pickedImage;
  PickedFile _image;
  Future<void> getImage({ImageSource source}) async {
    _image = await ImagePicker().getImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
        check=true;
      });
    }
  }
  String userUid2;
  Future<String> _uploadImage({File image}) async {
    String date=DateFormat().format(DateTime.now());

    StorageReference storageReference = FirebaseStorage.instance.ref().child("UserTransactionImage/$date");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;

  }
  var imageMap;
  String userImage;
  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            height: 90,
         
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height12,
            child: _buildBottomPart(),
          ),
        ],
      ),
    );
  }
  Widget CustomSizedBox(double s){
    return SizedBox(
      height: s,
    );
  }
}
