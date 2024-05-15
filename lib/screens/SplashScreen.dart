import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/api/AuthApi.dart';
import 'package:notala_apps/model/ResponseModel.dart';
import 'package:notala_apps/screens/LoginScreen.dart';

import 'WalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    checkAuthentication();

    await Future.delayed(Duration(seconds: 2));
    finish(context);

    var prefs = await SharedPreferences.getInstance();
    bool firstLook = prefs.getBool("first_look") ?? true;

    prefs.setBool("first_look", false);
    if(firstLook) {
      WalkThroughScreen().launch(context);
    } else {
      LoginScreen().launch(context);
    }
  }

  void checkAuthentication() async {
    var prefs = await SharedPreferences.getInstance();
    
    ResponseModel response = await apiAuthCheck();

    if(response.data != null){
      prefs.setString("user", jsonEncode(response.data));
      prefs.setBool("is_auth", true);
    } else {
      prefs.setString("bearer_token", '');
      prefs.setBool("is_auth", false);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('images/orapay/opsplash.png', width: 75, height: 75, fit: BoxFit.fill),
          SizedBox(height: 10),
          Text("OraPay", style: boldTextStyle(size: 20)),
        ],
      ).center(),
    );
  }
}
