import 'package:flutter/material.dart';

enum screens { LOGIN, SECURE } //our list of possible pages

class LoginScreen extends StatefulWidget {
  LoginScreen(
      {Key? key,
      required this.nav,
      required this.login,
      required this.logout,
      required this.isLoggedIn})
      : super(key: key);
  //the function we can use to go to the secure screen
  Function nav;
  Function login;
  Function logout;
  bool isLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  //state value for user login
  Map<String, dynamic> user = {'email': '', 'pass': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SharedPref App'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEmail(),
                    SizedBox(height: 16),
                    _buildPassword(),
                    SizedBox(height: 16),
                    ElevatedButton(
                      //the text should say login or logout based on the token
                      child: widget.isLoggedIn ? Text('Logout') : Text('Login'),
                      onPressed: () {
                        if (widget.isLoggedIn) {
                          //log out
                          widget.logout();
                        } else {
                          //try to login after validating form

                          if (_formKey.currentState!.validate()) {
                            //validation has been passed so we can save the form
                            _formKey.currentState!.save();
                            //triggers the onSave in each form field
                            //call the API function to post the data
                            //accept the response from the server and
                            //save the token in SharedPreferences
                            //go to the secure screen
                            print('call login and save token in sharedPref');
                            widget.login();
                          } else {
                            //form failed validation so exit
                            return;
                          }
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      //the text should say login or logout based on the token
                      child: Text('Go to Secure Page'),
                      onPressed: () {
                        //go to the secure page
                        //we would normally check for the token first
                        //but will do that on the secure page instead
                        widget.nav();
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }

  InputDecoration _styleField(String label, String hint) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black),
      hintText: hint, //placeholder
      border: OutlineInputBorder(),
      enabled: !widget.isLoggedIn,
      disabledBorder: InputBorder.none,
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      decoration: _styleField('Email', 'Email'),
      controller: emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        print('called validator in email');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['email'] = value;
        });
      },
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      decoration: _styleField('Password', ''),
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['password'] = value;
        });
      },
    );
  }
}
