import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/api/AuthApi.dart';
import 'package:notala_apps/model/ResponseModel.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';
import 'package:notala_apps/utils/OPWidgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if(!Constants.IS_PRODUCTION) {
      setState(() {
        usernameField.text = 'user';
        passwordField.text = '12345678';
      });
    }
  }

  void loginAuth() async {
    var prefs = await SharedPreferences.getInstance();

    ResponseModel response = await apiAuthLogin(
      username: usernameField.text,
      password: passwordField.text,
    );

    if(response.code == 200) {
      setState(() {
        prefs.setString("user", jsonEncode(response.data['user']));
        prefs.setString("bearer_token", response.data['token_data']['access_token']);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfull login!'),
        backgroundColor: Colors.green,
      ));

      BottomNavigationScreen().launch(context);
    } else {
      setState(() {
        prefs.setString("user", jsonEncode({}));
        prefs.setString("bearer_token", '');
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${ response.message }'),
        backgroundColor: Colors.deepOrange,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 100),
                    applogo(),
                    24.height,
                    Text("Login", style: boldTextStyle(size: 24, letterSpacing: 0.2)),
                    24.height,
                    TextField(
                      controller: usernameField,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: secondaryTextStyle(size: 16),
                        fillColor: Colors.grey,
                        suffixIcon: Icon(Icons.person_outline, color: Colors.grey, size: 24),
                      ),
                    ),
                    16.height,
                    TextField(
                      controller: passwordField,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: secondaryTextStyle(size: 16),
                        fillColor: Colors.grey,
                        suffixIcon: Icon(Icons.lock_outline, color: Colors.grey, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                width: context.width() - 32,
                child: Text("Login", textAlign: TextAlign.center, style: primaryTextStyle(size: 16, color: Colors.white)),
                color: opPrimaryColor,
                onTap: () {
                  loginAuth();
                },
              ).cornerRadiusWithClipRRect(16),
            ],
          ).paddingOnly(left: 16, right: 16, bottom: 24),
        ),
      ),
    );
  }
}
