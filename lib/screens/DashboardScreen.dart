import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/CategoryListScreen.dart';
import 'package:notala_apps/screens/TransactionCreateScreen.dart';
import 'package:notala_apps/screens/TransactionPrepareScreen.dart';
import 'package:notala_apps/screens/TransactionDetailsScreen.dart';
import 'package:notala_apps/screens/TransactionListScreen.dart';
import 'package:notala_apps/screens/op_user_detail.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int total = 0;
  int totalDebit = 0;
  int totalCredit = 0;
  List<dynamic> categories = [];
  List<dynamic> datas = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      categories = jsonDecode(prefs.getString(Constants.categoryFinance) ?? "[]");
      datas = jsonDecode(prefs.getString(Constants.dataFinance) ?? "[]");
      total = prefs.getInt(Constants.totalFinance) ?? 0;
      totalDebit = prefs.getInt(Constants.totalDebitFinance) ?? 0;
      totalCredit = prefs.getInt(Constants.totalCreditFinance) ?? 0;
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
              decoration: BoxDecoration(
                color: Color(0XFF232323),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 25, right: 10, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: ClipOval(
                                  child: Image.asset("images/orapay/op_profile.png", width: 250, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hi Person", 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text("Good Morning!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          visualDensity: VisualDensity.comfortable,
                          onPressed: () => {
                            TransactionPrepareScreen().launch(context)
                          },
                          icon: Icon(Icons.add, size: 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      OPUserDetailsScreen().launch(context)
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Total Keuangan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(formatRupiah(total),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            TransactionCreateScreen(type: 'debit').launch(context)
                          },
                          child: Container(
                            width: context.width() * 43 / 100,
                            decoration: BoxDecoration(
                              color: Color(0XFF393939),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text('Pemasukan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                      )
                                    ),
                                    SizedBox(height: 2),
                                    Text(formatRupiah(totalDebit),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            TransactionCreateScreen(type: 'credit').launch(context)
                          },
                          child: Container(
                            width: context.width() * 43 / 100,
                            decoration: BoxDecoration(
                              color: Color(0XFF393939),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text('Pengeluaran',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                      )
                                    ),
                                    SizedBox(height: 2),
                                    Text(formatRupiah(totalCredit),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        CategoryListScreen().launch(context)
                      },
                      child: Container(
                        width: context.width() * 28 / 100,
                        margin: EdgeInsets.only(top: 20, bottom: 20, left: 0),
                        decoration: BoxDecoration(
                          color: Color(0XFF232323),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Column(
                            children: [
                              Icon(Icons.star_outline, size: 35, color: Colors.white),
                              SizedBox(height: 3),
                              Text("Kategori", style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: context.width() * 28 / 100,
                      margin: EdgeInsets.only(top: 20, bottom: 20, left: 15),
                      decoration: BoxDecoration(
                        color: Color(0XFF232323),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Column(
                          children: [
                            Icon(Icons.area_chart_rounded, size: 35, color: Colors.white),
                            SizedBox(height: 3),
                            Text("Statistik", style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        TransactionListScreen().launch(context)
                      },
                      child: Container(
                        width: context.width() * 28 / 100,
                        margin: EdgeInsets.only(top: 20, bottom: 20, left: 15),
                        decoration: BoxDecoration(
                          color: Color(0XFF232323),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Column(
                            children: [
                              Icon(Icons.newspaper_outlined, size: 35, color: Colors.white),
                              SizedBox(height: 3),
                              Text("Transaksi", style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text('Transaksi Terbaru', textAlign: TextAlign.start, style: secondaryTextStyle(size: 18, fontFamily: fontMedium)),
            ),
            Container(
              height: context.height() * 40 / 100,
              child: SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (_, index) => Divider(),
                  padding: EdgeInsets.all(8),
                  itemCount: datas.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic data = datas[index];
                        
                    return Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: (data['type'] == 'debit' ? Colors.green : Colors.red).withOpacity(0.2),
                                    radius: 20,
                                    child: Icon(
                                      (data['type'] == 'debit' ? Icons.call_received : Icons.call_made),
                                      color: (data['type'] == 'debit' ? Colors.green : Colors.red), size: 20),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(data['title'] ?? '~', style: primaryTextStyle(fontFamily: fontMedium, size: 18)),
                                      SizedBox(height: 4),
                                      Text((data['category_id'] != '' ? categories[data['category_id'] - 1]['name'] : '~'), style: secondaryTextStyle(size: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Text(formatRupiah(int.parse(data['amount'])), 
                                      style: boldTextStyle(color: (data['type'] == 'debit' ? Colors.green : Colors.red), size: 14)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ).onTap(() {
                      TransactionDetailsScreen(
                        type: data['type'],
                        amount: data['amount'],
                        title: data['title'],
                        categoryId: data['categoryId'],
                        description: data['description'],
                      ).launch(context);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
