import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum screens { LOGIN, SECURE } //our list of possible pages

class SecureScreen extends StatefulWidget {
  SecureScreen(
      {Key? key,
      required this.nav,
      required this.logout,
      required this.isLoggedIn})
      : super(key: key);

  Function nav;
  Function logout;
  bool isLoggedIn;

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  var prefs;
  String? token;

  @override
  initState() {
    //connect to Shared Preferences when the screen is loaded
    () async {
      prefs = await SharedPreferences.getInstance();

      //update token to update the interface
      setState(() {
        token = prefs.getString('JWTtoken');
      });
      print('token is "$token"');
      //if token does not exist then send them back to the login screen
      if (token == null) {
        widget.nav();
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPref App'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.nav();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout alone will leave us on the secure page
              widget.logout();
              //remove the token in state for this page too to trigger build
              setState(() => token = null);
              //OR send them back to the login page
              // widget.nav();
              //OR both...
            },
          ),
        ],
      ),
      body: Center(
        child: token == null
            ? Text(
                'No Soup For You',
                style: TextStyle(fontSize: 40),
              )
            : Text(
                'Secure Info',
                style: TextStyle(fontSize: 40),
              ),
      ),
    );
  }
}
