import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/CategoryCreateScreen.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  CategoryListScreenState createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      categories = jsonDecode(prefs.getString(Constants.categoryFinance) ?? "[]");
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => {
                            DashboardScreen().launch(context)
                          },
                          icon: Icon(Icons.arrow_back_rounded, size: 30),
                        ),
                        SizedBox(width: 5),
                        Text("Katogori", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        onPressed: () => {
                          CategoryCreateScreen().launch(context)
                        },
                        icon: Icon(Icons.add, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (categories.length != 0 ? Container(
              height: context.height() * 85 / 100,
              child: SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (_, index) => Container(),
                  padding: EdgeInsets.all(8),
                  itemCount: categories.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic data = categories[index];
                        
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text((data['name'] ?? 'N').substring(0, 1), style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        )),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(data['name'] ?? '', style: primaryTextStyle(fontFamily: fontMedium, size: 18)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ) : Container(
              width: context.width(),
              height: context.height() * 80 / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/notala/empty.png", width: 100),
                  Text("Tidak ada data transaksi saat ini", style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  )),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
