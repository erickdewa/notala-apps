import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/screens/GetToKnowScreen.dart';
import 'package:notala_apps/utils/Constants.dart';

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
    await Future.delayed(Duration(seconds: 2));
    finish(context);

    var prefs = await SharedPreferences.getInstance();
    String callname = prefs.getString(Constants.callnameFinance) ?? '';
    bool firstLook = prefs.getBool("first_look") ?? true;

    prefs.setBool("first_look", false);
    if(firstLook) {
      WalkThroughScreen().launch(context);
    } else {
      if (callname == '') {
        GetToKnowScreen().launch(context);
      } else {
        finish(context);
        DashboardScreen().launch(context);
      }
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
          Text("NOTALA", style: boldTextStyle(size: 20)),
        ],
      ).center(),
      bottomNavigationBar: Container(
        height: 100,
        child: Column(
          children: [
            Text("Support By :", style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600
            )),
            SizedBox(height: 10),
            Image.asset('images/notala/logo-support-by.png', height: 35,)
          ],
        ),
      ),
    );
  }
}
