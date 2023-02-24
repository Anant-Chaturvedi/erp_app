// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erp_app/screens/students_reports/array.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../parent_reports/list_arrays.dart';

import 'package:intl/intl.dart';

late Size mq;

class AttendanceA extends StatefulWidget {
  final String selDate;
  final DateTime fromDate;
  final DateTime toDate;

  const AttendanceA(
      {super.key,
      required this.selDate,
      required this.fromDate,
      required this.toDate});

  @override
  State<AttendanceA> createState() => _AttendanceAState();
}

class _AttendanceAState extends State<AttendanceA> {
  List<Map<String, dynamic>> dataList = [];
  List<Color> colors = [
    Colors.indigo.shade900,
    Colors.blue.shade700,
    Colors.red,
    Colors.green,
    Colors.pink.shade800,
    Colors.yellow.shade800,
    Colors.purple,
    Colors.red.shade800
  ];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFromDate = formatter.format(widget.fromDate);
    final String formattedToDate = formatter.format(widget.toDate);
    log(widget.fromDate.toString());
    log(widget.toDate.toString());
    try {
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('student_data'));
      final String userId = userData['userId'];
      final response = await Dio().post(
          'https://skinfotechies.in/demo/erp/api/fetch-attendance-report.php',
          data: {
            'userId': userId,
            'fromDate': formattedFromDate,
            'toDate': formattedToDate,
          });
      final jsonList = json.decode(response.data)['dataList'];
      log(response.data);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(jsonList);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/images/ind.png'))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: mq.width * .05,
                  right: mq.width * .05,
                  top: mq.height * .048),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: mq.height * .0408,
                      width: mq.width * .104,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                  const Text(
                    '      Attendance Report             ',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mq.height * .08,
            ),
            Padding(
              padding: EdgeInsets.only(left: mq.width * .07),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Subject Report",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.7),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: mq.width * .07, right: mq.width * .07),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 18, right: 9),
                height: MediaQuery.of(context).size.height * .058,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        width: 1.7),
                    borderRadius: BorderRadius.circular(15)),
                child: const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    'All Subject',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.black,
                    size: 38,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            InkWell(
              onTap: () {
                // _showDateRangePicker();
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: mq.width * .07, right: mq.width * .07),
                child: Container(
                  padding: const EdgeInsets.only(left: 26, right: 20),
                  height: MediaQuery.of(context).size.height * .058,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 1.7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selDate,
                          style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 21,
                              fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          'assets/images/calendar.png',
                          height: mq.height * .031,
                        ),
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * .015,
            ),
            Divider(
              color: Colors.grey.shade600,
            ),
            SizedBox(
              height: mq.height * .0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: mq.width * .05,
                  right: mq.width * .05,
                  top: mq.height * .015),
              child: dataList == null
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: mq.height * .54,
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final data = dataList[index];
                          final color = colors[index % colors.length];
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Array(
                                  strip: color,
                                  subjects: data['subjectName'],
                                  total: '${data['totalLecture']}',
                                  totalA: '${data['totalNotAttendedLectures']}',
                                  totalP: '${data['totalAttendedLectures']}',
                                  subId: '${data['subjectId']}',
                                  fromDate: widget.fromDate,
                                  toDate: widget.toDate,
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
