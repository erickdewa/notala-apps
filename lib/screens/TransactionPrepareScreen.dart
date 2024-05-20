import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/screens/TransactionCreateScreen.dart';
import 'package:notala_apps/utils/Constants.dart';

class TransactionPrepareScreen extends StatefulWidget {
  @override
  TransactionPrepareScreenState createState() => TransactionPrepareScreenState();
}

class TransactionPrepareScreenState extends State<TransactionPrepareScreen> {
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
                            finish(context),
                            DashboardScreen().launch(context)
                          },
                          icon: Icon(Icons.arrow_back_rounded, size: 30),
                        ),
                        SizedBox(width: 5),
                        Text("Pilih", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Image.asset("images/notala/note.png",
                          width: context.width() * 50 / 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => {
                        TransactionCreateScreen(type: 'debit').launch(context)
                      },
                      child: Container(
                        width: context.width(),
                        decoration: BoxDecoration(
                          color: Color(0XFF232323),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline, size: 50, color: Colors.white),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pemasukan", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                                  SizedBox(height: 5),
                                  Text("Catat pemasukan uang Anda", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => {
                        TransactionCreateScreen(type: 'credit').launch(context)
                      },
                      child: Container(
                        width: context.width(),
                        decoration: BoxDecoration(
                          color: Color(0XFF232323),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Row(
                            children: [
                              Icon(Icons.remove_circle_outline, size: 50, color: Colors.white),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pengeluaran", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                                  SizedBox(height: 5),
                                  Text("Catat pengeluaran uang Anda", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
