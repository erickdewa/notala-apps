import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/screens/TransactionDetailsScreen.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';

class TransactionListScreen extends StatefulWidget {
  @override
  TransactionListScreenState createState() => TransactionListScreenState();
}

class TransactionListScreenState extends State<TransactionListScreen> {
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
                        Text("Semua Transaksi", style: TextStyle(
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
              height: context.height() * 85 / 100,
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
