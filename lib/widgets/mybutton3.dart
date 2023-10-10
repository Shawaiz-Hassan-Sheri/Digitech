import 'package:flutter/material.dart';

class MyButton3 extends StatelessWidget {
  final Function onPressed;
  final String name;
  MyButton3({this.name, this.onPressed});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height*.06,
      width: width*.65,
      child: ElevatedButton(
        child: Text(
            name,
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

        onPressed: onPressed,
      ),
    );
    /*Container(
      height: 45,
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        color:Color.fromARGB(255, 1, 83, 137),
        onPressed: onPressed,
      ),
    );*/
  }
}
