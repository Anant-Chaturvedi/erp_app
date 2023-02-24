// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erp_app/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

import '../utils/shimmer_effect.dart';
import 'students_reports/view_report.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> _studentData = {};
  String userName = '';
  String presentPer = '';
  String absentPer = '';
  double per = 0;
  double ab = 0;
  late Size mq;
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
    getName();
  }

  getName() async {
    final box = await Hive.openBox('user');
    final userData = jsonDecode(box.get('student_data'));
    final String Name = userData['userName'];
    setState(() {
      userName = Name;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"Present": per, "Absent": ab};
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    mq = MediaQuery.of(context).size;
    final now = DateTime.now();
    final currentMonth = DateFormat('MMM').format(now);
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 1)) {
          _lastPressedAt = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.indigo.shade900,
            content: const Text('Press the back button again to exit!'),
            duration: const Duration(seconds: 1),
          ));
          return false;
        }
        SystemNavigator.pop(); // This will close the app
        return true;
      },
      child: Stack(
        children: [
          SafeArea(
              child: Scaffold(
            drawer: Drawer(
              // width: MediaQuery.of(context).size.width * 0.9,
              child: Container(
                color: const Color.fromARGB(255, 7, 31, 81),
                child: Column(
                  children: [
                    SizedBox(
                      height: mq.height * .046,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: mq.width * .06, right: mq.width * .025),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Menu",
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Urbanist',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .046,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: mq.width * .0,
                          left: mq.width * .0,
                          bottom: mq.height * .013),
                      child: const Divider(
                        color: Colors.white38,
                        thickness: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .05,
                            top: MediaQuery.of(context).size.height * .00),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/person.png",
                              height: mq.height * .033,
                            ),
                            const Text(
                              '   Profile Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 21,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: mq.width * .05,
                          left: mq.width * .05,
                          bottom: mq.height * .013,
                          top: mq.height * .013),
                      child: const Divider(
                        color: Colors.white38,
                        thickness: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .056,
                            top: MediaQuery.of(context).size.height * .00),
                        child: Row(
                          children: [
                            Container(
                                height: mq.height * .025,
                                width: mq.width * .06,
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: Colors.white, width: 1.2)),
                                child: Image.asset(
                                  "assets/images/graph.png",
                                  height: mq.height * .033,
                                )),
                            const Text(
                              '   Teacher Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 21,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: mq.width * .05,
                          left: mq.width * .05,
                          bottom: mq.height * .0,
                          top: mq.height * .013),
                      child: const Divider(
                        color: Colors.white38,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .572,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: mq.width * .0, left: mq.width * .00),
                      child: const Divider(
                        color: Colors.white38,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .007,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        onPressed: () {
                          showLogoutDialog();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 30,
                        ),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(
                              color: Colors.red,
                              letterSpacing: 1,
                              fontSize: 22,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            _studentData['motherName'].toString().isNotEmpty
                                ? 'assets/images/clear1.jpg'
                                : 'assets/images/a1.jpg'))),
                child: Column(
                  children: [
                    SizedBox(
                      height: mq.height * .045,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .06, right: mq.width * .05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => InkWell(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Container(
                                height: mq.height * .0407,
                                width: mq.width * .102,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Image.asset(
                                  'assets/images/menu.png',
                                  height: mq.height * .04,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/bell.png',
                            height: mq.height * .03,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .032,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .06),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Hello,",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 31,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .002,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .06),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 31,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),

                    //1387
                    //1521
                    SizedBox(
                      height: mq.height * .032,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .05, right: mq.width * .05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/profile.png',
                            height: mq.height * .16,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: _studentData['motherName']
                                        .toString()
                                        .isNotEmpty
                                    ? 0
                                    : 16),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    'Student Name',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${_studentData['studentName']}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 21,
                                        letterSpacing: 1,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: mq.height * .01,
                                  ),
                                  Text(
                                    'Branch, Year & Section',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        letterSpacing: 1,
                                        fontSize: 16,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${_studentData['branch']} - ${_studentData['year']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                            fontFamily: "Rob",
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Text(
                                        ' | ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: "Rob",
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${_studentData['mainSection']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            letterSpacing: 1,
                                            fontFamily: "Rob",
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .055,
                          right: mq.width * .055,
                          top: mq.height * .01),
                      child: Divider(
                        color: Colors.grey.shade200,
                        thickness: 3,
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .004,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .05),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Attendance Report",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 23,
                              color: Color.fromARGB(255, 12, 43, 110),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .009,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .05,
                          right: mq.width * .05,
                          top: mq.height * .0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 246,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 235, 241, 255),
                              Color.fromARGB(255, 243, 243, 243),
                            ],
                            stops: [0.33, 1.0],
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 13, bottom: 30),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 5.0,
                                          spreadRadius: 4.0,
                                          offset: const Offset(0.0, 0.0),
                                        ),
                                      ],
                                    ),
                                    child: PieChart(
                                      // dataMap: {
                                      //   "Present": double.parse(
                                      //       presentPer.replaceAll(
                                      //           RegExp(r'\.0$'), '')),
                                      //   "Absent": double.parse(
                                      //       absentPer.replaceAll(
                                      //           RegExp(r'\.0$'), ''))
                                      // },
                                      dataMap: dataMap,
                                      animationDuration:
                                          const Duration(milliseconds: 800),
                                      chartLegendSpacing: 32,
                                      chartRadius:
                                          MediaQuery.of(context).size.width /
                                              3.2,
                                      colorList: const [
                                        Colors.black,
                                        Colors.amber,
                                      ],
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 32,
                                      centerText:
                                          '${_studentData['attendancePercentage']}%',
                                      centerTextStyle: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 18),
                                      legendOptions: const LegendOptions(
                                        showLegendsInRow: false,
                                        showLegends: false,
                                        legendShape: BoxShape.rectangle,
                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        showChartValueBackground: false,
                                        showChartValues: false,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 10, right: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month Count ($currentMonth)',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: Color.fromARGB(
                                                255, 13, 60, 160),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: mq.height * .01,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 48,
                                            width: 53,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              '${_studentData['lecturesPresent']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Text(
                                            '  Lectures Present',
                                            style: TextStyle(
                                                fontSize: 18, letterSpacing: 1),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: mq.height * .01,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 48,
                                            width: 53,
                                            decoration: BoxDecoration(
                                                color: Colors.amber.shade600,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              '${_studentData['lecturesAbsent']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Text(
                                            '  Lectures Absent',
                                            style: TextStyle(
                                              fontSize: 18,
                                              letterSpacing: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: mq.height * .00,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => ViewReportA(
                                      absentLectures:
                                          '${_studentData['lecturesAbsent']}',
                                      percentage:
                                          '${_studentData['attendancePercentage']}',
                                      presentLectures:
                                          '${_studentData['lecturesAbsent']}',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "View full report ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 12, 43, 110),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1),
                                    ),
                                    Image.asset(
                                      'assets/images/arrow.png',
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mq.height * .03,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .05),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Class Teacher",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 12, 43, 110),
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .05,
                          right: mq.width * .05,
                          top: mq.height * .006),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/p_1.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_studentData['teacherName']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(height: mq.height * .006),
                                  Text(
                                    '(704) 555-0127',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: mq.height * .006),
                                  Text(
                                    '${_studentData['teacherEmail']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .025,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .05),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Parents",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromARGB(255, 12, 43, 110),
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .05,
                          right: mq.width * .05,
                          top: mq.height * .006),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              Container(
                                height: 80.0,
                                width: 80.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/p_3.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_studentData['fatherName']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(height: mq.height * .006),
                                  Text(
                                    '${_studentData['fatherMobileNumber']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: mq.height * .006),
                                  Text(
                                    'Cameronwilliamson@gmail.com',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _studentData['motherName'].toString().isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: mq.width * .05,
                                right: mq.width * .05,
                                top: mq.height * .01),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 80.0,
                                      width: 80.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/p_2.png'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_studentData['motherName']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        SizedBox(height: mq.height * .006),
                                        Text(
                                          '${_studentData['motherMobileNumber']}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            letterSpacing: 1,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: mq.height * .006),
                                        Text(
                                          'Cameronwilliamson@gmail.com',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            letterSpacing: 1,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    SizedBox(
                      height: mq.height * .025,
                    ),
                  ],
                ),
              ),
            ),
          )),
          Visibility(
              visible: _studentData.isEmpty,
              child: Positioned.fill(
                child: Scaffold(
                    backgroundColor: Colors.grey.withOpacity(0.4),
                    body: ShimmerEffectPage()),
              )),
        ],
      ),
    );
  }

  Future<void> fetchStudentData() async {
    try {
      final dio = Dio();
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('student_data'));
      final String userId = userData['userId'];
      dio.options.contentType = 'application/json';
      final Response response = await dio.post(
          'https://skinfotechies.in/demo/erp/api/fetch-dashboard.php',
          data: {"userId": userId, "userRole": "student"});
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      log(response.data);
      if (jsonData['errorCode'] == '0000') {
        calculateAttendance('${_studentData['lecturesPresent']}',
            '${_studentData['lecturesAbsent']}');
        _studentData = jsonData;
        setState(() {});
      } else {
        print(jsonData['errorMessage']);
      }
    } catch (error) {
      print(error);
    }
  }

  void calculateAttendance(String presentStr, String absentStr) {
    int present = int.tryParse(presentStr) ?? 0;
    int absent = int.tryParse(absentStr) ?? 0;

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int total = present + absent;

    double presentPercentage = 0.0;
    double absentPercentage = 0.0;
    double unmarkedPercentage = 0.0;

    if (total != 0) {
      int presentPercentage = ((present / total) * 100).round();
      int absentPercentage = ((absent / total) * 100).round();
      int unmarkedPercentage = 100 - presentPercentage - absentPercentage;
    }
    setState(() {
      presentPer = presentPercentage.toStringAsFixed(2);
      per = double.tryParse(presentPer)!;
    });
    setState(() {
      absentPer = absentPercentage.toStringAsFixed(2);
      ab = double.tryParse(presentPer)!;
    });

    print('presentPer: $presentPer');
    print('absentPer: $absentPer');

    log('Present percentage: ${presentPercentage.toStringAsFixed(2)}%');
    log('Absent percentage: ${absentPercentage.toStringAsFixed(2)}%');
    log('Unmarked percentage: ${unmarkedPercentage.toStringAsFixed(2)}%');
  }

  _logoutStudent() async {
    final dio = Dio();
    final box = await Hive.openBox('user');
    final userData = jsonDecode(box.get('student_data'));
    final String userId = userData['userId'];
    final response = await dio.post(
        'https://skinfotechies.in/demo/erp/api/logout.php',
        data: {'userId': userId, 'userRole': 'student'});
    final Map<String, dynamic> jsonData = jsonDecode(response.data);
    log('Student Logout' + response.data);
  }

  showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          content: Container(
            height: 193.5,
            width: 700,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 13, 60, 160),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 29.0, right: 22, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 33,
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Are you sure you want to sign out?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 35),
                const Divider(
                  height: 0,
                  color: Colors.black87,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '             No           ',
                        style: TextStyle(
                            color: Colors.blue.shade600,
                            fontFamily: 'Roboto',
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 50.8,
                      color: Colors.black87,
                      width: 0.7,
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final box = await Hive.openBox('user');
                        box.put('isLogged', false);
                        _logoutStudent();
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (_) => const HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        '          Yes           ',
                        style: TextStyle(
                            color: Colors.red.shade600,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
