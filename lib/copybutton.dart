import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Copy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  TextEditingController _textController = TextEditingController();
  String name='hussain';
  // This key will be used to show the snack bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: name));
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Kindacode.com'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Row(
          children: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: _copyToClipboard,
            ),
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text('$name' ),
                )),
          ],
        ));
  }
}