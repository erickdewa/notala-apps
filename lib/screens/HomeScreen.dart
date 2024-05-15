import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/model/OPModel.dart';
import 'package:notala_apps/screens/op_transaction_screen.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/OPDataProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<OPPickVerifyModel> transactionList = getTransactionListItems();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
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
                        onPressed: () => { },
                        icon: Icon(Icons.notifications_none_outlined, size: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
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
                        Text("Rp. 1.000.000",
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
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
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
                                Text('Rp. 1.200.000',
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
                      Container(
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
                                Text('Rp. 200.000',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Transaction', style: secondaryTextStyle(size: 18, fontFamily: fontMedium)),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 5, top: 5),
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text("Lihat Semua", style: secondaryTextStyle(size: 13, fontFamily: fontMedium)),
                )
              ],
            ),
          ),
          Container(
            height: context.height() * 43.5 / 100,
            child: ListView.separated(
              separatorBuilder: (_, index) => Divider(),
              padding: EdgeInsets.all(8),
              itemCount: transactionList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                OPPickVerifyModel data = transactionList[index];
        
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
                                backgroundColor: data.cardColor?.withOpacity(0.2),
                                radius: 20,
                                child: Icon(data.icon, color: data.cardColor, size: 20),
                              ),
                              SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(data.cardTitle!, style: primaryTextStyle(fontFamily: fontMedium, size: 18)),
                                  SizedBox(height: 4),
                                  Text(data.cardSubTitle!, style: secondaryTextStyle(size: 12)),
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
                                Text(data.cardNumber!, style: boldTextStyle(color: data.cardColor, size: 14)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ).onTap(() {
                  OPTransactionDetailsScreen().launch(context);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
