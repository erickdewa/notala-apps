import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';
import 'package:notala_apps/utils/OPWidgets.dart';


class TransactionDetailsScreen extends StatefulWidget {
  final String type;
  final String amount;
  final int? categoryId;
  final String title;
  final String? description;

  TransactionDetailsScreen({
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.title,
    required this.description,
  });

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
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
                          Text(widget.description ?? '~',
                            style: secondaryTextStyle(size: 17),
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
                        title: 'Print',
                        icon: Icons.print,
                        color: opPrimaryColor,
                      ),
                      ButtonBars(
                        size: size,
                        title: 'Hapus',
                        icon: Icons.delete_outline_outlined,
                        color: Colors.red,
                        onPressed: () {},
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
