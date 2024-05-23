import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/screens/TransactionEditScreen.dart';
import 'package:notala_apps/utils/Constants.dart';
import 'package:notala_apps/utils/OPWidgets.dart';


class TransactionDetailsScreen extends StatefulWidget {
  final int index;
  final String type;
  final String amount;
  final String? date;
  final int? categoryId;
  final String title;
  final String? description;

  TransactionDetailsScreen({
    required this.index,
    required this.type,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.title,
    required this.description,
  });

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
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

  void delete() async {
    var prefs = await SharedPreferences.getInstance();

    dynamic data = datas[widget.index];
    if(data['type'] == 'debit') {
      total -= int.parse(data['amount']);
      totalDebit -= int.parse(data['amount']);
    } else {
      total += int.parse(data['amount']);
      totalCredit -= int.parse(data['amount']);
    }

    datas.removeAt(widget.index);

    prefs.setInt(Constants.totalFinance, total);
    prefs.setInt(Constants.totalDebitFinance, totalDebit);
    prefs.setInt(Constants.totalCreditFinance, totalCredit);
    prefs.setString(Constants.dataFinance, jsonEncode(datas));

    finish(context);
    DashboardScreen().launch(context);
  }

  void edit() {
    TransactionEditScreen(index: widget.index).launch(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
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
                              Navigator.pop(context),
                            },
                            icon: Icon(Icons.arrow_back_rounded, size: 30),
                          ),
                          SizedBox(width: 5),
                          Text("Detail Transaksi", style: TextStyle(
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
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 30),
                      margin: EdgeInsets.all(16),
                      decoration: boxDecoration(radius: 16, shadowColor: Colors.black.withOpacity(0.2), backGroundColor: Colors.black),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(formatRupiah(int.parse(widget.amount)),
                              style: boldTextStyle(size: 30, color: Colors.white),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.white30,
                          ),
                          Text(categories.length > 0 ? categories[(widget.categoryId ?? 1) - 1]['name'] : '',
                            style: primaryTextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Tanggal: ${ widget.date }",
                            style: secondaryTextStyle(size: 15),
                          ),
                          SizedBox(height: 5),
                          Text(widget.description ?? '~',
                            style: secondaryTextStyle(size: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 10, bottom: 20),
                            child: Divider(
                              thickness: 0.8,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ButtonBars(
                        title: 'Edit',
                        icon: Icons.edit_note_outlined,
                        color: Colors.amber,
                        onPressed: () {
                          TransactionEditScreen(index: widget.index).launch(context);
                        }
                      ),
                      ButtonBars(
                        size: size,
                        title: 'Hapus',
                        icon: Icons.delete_outline_outlined,
                        color: Colors.red,
                        onPressed: () {
                          delete();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
