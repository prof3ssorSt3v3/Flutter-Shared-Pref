import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//screens
import './screens/login_screen.dart';
import './screens/secure_screen.dart';

enum screens { LOGIN, SECURE } //our list of possible pages

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  //connect to SharedPreferences

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //inital screen to load
  Enum currentPage = screens.LOGIN;
  //pretend JWTtoken. When set, will be put into SharedPreferences
  String? JWTtoken = null;
  //this is the token we will use in all our API calls
  bool isLoggedIn = false;
  var prefs;

  @override
  initState() {
    //initState gets called when your Widget is added to the Widget tree
    // State lifecycle method  - like 'DOMContentLoaded'
    //connect to Shared Preferences when the screen is loaded
    () async {
      prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('JWTtoken');
      if (token != null) {
        //if token exists then save it and set logged in to true
        setState(
          () {
            JWTtoken =
                token; //put from SharedPreferences into State variable JWTtoken
            isLoggedIn = true;
          },
          //MAKE an API call to see if the token is actually valid
        );
      } else {
        setState(
          () {
            JWTtoken = null;
            isLoggedIn = false;
            //clear the old token from SharedPreferences
          },
        );
      }
    }();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //clear out SharedPreferences token
  }

  @override
  Widget build(BuildContext context) {
    print('build called again with ${currentPage.name}');
    //Call the loadPage function which decides which page to load
    //Pass the current value of state variable currentPage
    return loadPage(currentPage);
  }

  Widget loadPage(Enum screen) {
    //gets called from the build method
    print(screen);
    switch (screen) {
      case screens.LOGIN:
        return LoginScreen(
            nav: _gotoSecure,
            login: _login,
            isLoggedIn: isLoggedIn,
            logout: _logout);
      case screens.SECURE:
        return SecureScreen(
            nav: _gotoLogin, logout: _logout, isLoggedIn: isLoggedIn);
      default:
        return LoginScreen(
            nav: _gotoSecure,
            login: _login,
            isLoggedIn: isLoggedIn,
            logout: _logout);
    }
  }

  void _gotoSecure() {
    setState(() => currentPage = screens.SECURE);
  }

  void _gotoLogin() {
    setState(() => currentPage = screens.LOGIN);
  }

  void _login() async {
    //real world we would call an API to login first
    String token = 'this is my fake token';
    //save the token in SharedPreferences
    await prefs.setString('JWTtoken', token);
    setState(() {
      JWTtoken = token;
      isLoggedIn = true;
    });
  }

  void _logout() async {
    //clear the token from SharedPreferences
    await prefs.remove('JWTtoken');
    //here or inside the login_screen and secure_screen
    setState(() {
      JWTtoken = null;
      isLoggedIn = false;
    });
  }
}
