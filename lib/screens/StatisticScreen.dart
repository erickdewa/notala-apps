import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'package:notala_apps/utils/Constants.dart';

class StatisticScreen extends StatefulWidget {
  @override
  StatisticScreenState createState() => StatisticScreenState();
}

class StatisticScreenState extends State<StatisticScreen> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  List<dynamic> datas = [];
  List<dynamic> categories = [];
  Map<String, dynamic> weekData = {};
  List<int> weekDebit = [1, 1, 1, 1, 1, 1, 1];
  List<int> weekCredit = [1, 1, 1, 1, 1, 1, 1];
  int heightAmount = 10000;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    init();

    final barGroup1 = makeGroupData(0, weekDebit[0].toDouble(), weekCredit[0].toDouble());
    final barGroup2 = makeGroupData(1, weekDebit[1].toDouble(), weekCredit[1].toDouble());
    final barGroup3 = makeGroupData(2, weekDebit[2].toDouble(), weekCredit[2].toDouble());
    final barGroup4 = makeGroupData(3, weekDebit[3].toDouble(), weekCredit[3].toDouble());
    final barGroup5 = makeGroupData(4, weekDebit[4].toDouble(), weekCredit[4].toDouble());
    final barGroup6 = makeGroupData(5, weekDebit[5].toDouble(), weekCredit[5].toDouble());
    final barGroup7 = makeGroupData(6, weekDebit[6].toDouble(), weekCredit[6].toDouble());

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      categories = jsonDecode(prefs.getString(Constants.categoryFinance) ?? "[]");
      datas = jsonDecode(prefs.getString(Constants.dataFinance) ?? "[]");
    });

    getData();
  }

  void getData() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(startOfWeek.add(Duration(days: i)));
    }

    setState(() {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      int index = 0;
      weekDates.forEach((date) {
        String dateStr = dateFormat.format(date);
        weekData[dateStr] = [];
        for (dynamic data in datas) {
          if(data['date'] == dateStr) {
            weekData[dateStr].add(data);

            if(data['type'] == 'credit') {
              weekCredit[index] += int.parse(data['amount']);
            } else {
              weekDebit[index] += int.parse(data['amount']);
            }

            if(weekCredit[index] > weekDebit[index]){
              if(weekCredit[index] > heightAmount) {
                heightAmount = weekCredit[index];
              }
            } else {
              if(weekDebit[index] > heightAmount) {
                heightAmount = weekDebit[index];
              }
            }
          }
        }

        if(weekDebit[index] > 1) {
          weekDebit[index] -= 1;
        }

        if(weekCredit[index] > 1) {
          weekCredit[index] -= 1;
        }

        index += 1;
      });

      final barGroup1 = makeGroupData(0, getY(weekDebit[0]), getY(weekCredit[0]));
      final barGroup2 = makeGroupData(1, getY(weekDebit[1]), getY(weekCredit[1]));
      final barGroup3 = makeGroupData(2, getY(weekDebit[2]), getY(weekCredit[2]));
      final barGroup4 = makeGroupData(3, getY(weekDebit[3]), getY(weekCredit[3]));
      final barGroup5 = makeGroupData(4, getY(weekDebit[4]), getY(weekCredit[4]));
      final barGroup6 = makeGroupData(5, getY(weekDebit[5]), getY(weekCredit[5]));
      final barGroup7 = makeGroupData(6, getY(weekDebit[6]), getY(weekCredit[6]));

      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
        barGroup6,
        barGroup7,
      ];

      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text("Statistik", style: TextStyle(
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
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                maxY: 20,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem: (a, b, c, d) => null,
                                  ),
                                  touchCallback: (FlTouchEvent event, response) {
                                    if (response == null || response.spot == null) {
                                      setState(() {
                                        touchedGroupIndex = -1;
                                        showingBarGroups = List.of(rawBarGroups);
                                      });
                                      return;
                                    }
                    
                                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    
                                    setState(() {
                                      if (!event.isInterestedForInteractions) {
                                        touchedGroupIndex = -1;
                                        showingBarGroups = List.of(rawBarGroups);
                                        return;
                                      }
                                      showingBarGroups = List.of(rawBarGroups);
                                      if (touchedGroupIndex != -1) {
                                        var sum = 0.0;
                                        for (final rod
                                            in showingBarGroups[touchedGroupIndex].barRods) {
                                          sum += rod.toY;
                                        }
                                        final avg = sum /
                                            showingBarGroups[touchedGroupIndex]
                                                .barRods
                                                .length;
                    
                                        showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                                          barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                            if(rod.color == Color(0xff90caf9)) {
                                              return rod.copyWith(toY: avg, color: Colors.blue.shade700);
                                            } else {
                                              return rod.copyWith(toY: avg, color: Colors.red.shade700);
                                            }
                                          }).toList(),
                                        );
                                      }
                                    });
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitles,
                                      reservedSize: 42,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: leftTitles,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups,
                                gridData: FlGridData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text('Transaksi Minggu Ini', textAlign: TextAlign.start, style: secondaryTextStyle(size: 18, fontFamily: fontMedium)),
              ),
              (datas.length != 0 ?Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: context.height() * 35 / 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: weekData.entries.map((entry) {
                      if(entry.value.length == 0) {
                        return Container();
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10, top: 5),
                            child: Text(entry.key, style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500
                            )),
                          ),
                          Column(
                            children: entry.value.map<Widget>((data) {
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
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ) : Container(
                width: context.width(),
                height: context.height() * 30 / 100,
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
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value == 0) {
      text = getCurrencyOfMoney(value);
    } else if (value == (20 / 2)) {
      text = getCurrencyOfMoney((heightAmount / 2));
    } else if (value == 20) {
      text = getCurrencyOfMoney(heightAmount);
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  String getTextOfMoney(val) {
    if (val >= 0 && val < 1000000) {
      return 'K';
    } else if (val >= 1000000 && val < 1000000000) {
      return 'Jt';
    } else if (val > 1000000000 && val <= 1000000000000) {
      return 'M';
    } else {
      return 'T';
    }
  }

  String getCurrencyOfMoney(val) {
    if (val >= 0 && val < 1000000) {
      return "${ (val / 1000).toInt().toString() }${ getTextOfMoney(val) }";
    } else if (val >= 1000000 && val < 1000000000) {
      return "${ (val / 1000000).toInt().toString() }${ getTextOfMoney(val) }";
    } else if (val > 1000000000 && val <= 1000000000000) {
      return "${ (val / 1000000000).toInt().toString() }${ getTextOfMoney(val) }";
    } else {
      return "${ (val / 1000000000000).toInt().toString() }${ getTextOfMoney(val) }";
    }
  }

  double getY(val) {
    return (20 / heightAmount) * val;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.red.shade200,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.blue.shade200,
          width: width,
        ),
      ],
    );
  }
}