import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

late Size mq;

class WiseReportA extends StatefulWidget {
  const WiseReportA(
      {super.key,
      required this.subjects,
      required this.subjectId,
      required this.fromDate,
      required this.toDate});
  final String subjects;
  final String subjectId;
  final DateTime fromDate;
  final DateTime toDate;
  @override
  State<WiseReportA> createState() => _WiseReportAState();
}

class _WiseReportAState extends State<WiseReportA> {
  List<DateTime> attendanceDates = [];
  List<DateTime> attendanceDatesB = [];

  int totalLecture = 0;
  int totalAttendedLectures = 0;
  int totalNotAttendedLectures = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  DateTime startDate = DateTime.now();

  DateTime _selectedMonth = DateTime.now();

  Widget _buildCalendar() {
    List<DateTime?> daysInMonth = [];

    int firstWeekdayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;
    int daysInSelectedMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

    for (int i = 0; i < firstWeekdayOfMonth - 1; i++) {
      daysInMonth.add(null);
    }

    for (int i = 1; i <= daysInSelectedMonth; i++) {
      daysInMonth.add(DateTime(_selectedMonth.year, _selectedMonth.month, i));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              "Mon   ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Tue     ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Wed       ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Thu      ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Fri      ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Sat    ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
            Text(
              "Sun",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist'),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          children: List.generate(daysInMonth.length, (index) {
            DateTime? day = daysInMonth[index];
            if (day == null) return Container();

            bool isMarkedBlack = false;
            isMarkedBlack = attendanceDates.any((markedDate) =>
                day.year == markedDate.year &&
                day.month == markedDate.month &&
                day.day == markedDate.day);

            bool isMarkedYellow = false;
            isMarkedYellow = attendanceDatesB.any((markedDate) =>
                day.year == markedDate.year &&
                day.month == markedDate.month &&
                day.day == markedDate.day);

            return Container(
              margin: const EdgeInsets.all(14.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isMarkedBlack
                    ? const Color.fromARGB(255, 5, 14, 110)
                    : isMarkedYellow
                        ? Colors.amber.shade700
                        : Colors.transparent,
                shape: BoxShape.rectangle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: isMarkedBlack || isMarkedYellow
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'Urbanist',
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    _selectedMonth = widget.fromDate;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
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
                  top: mq.height * .05),
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
              height: mq.height * .07,
            ),
            Padding(
              padding: EdgeInsets.only(left: mq.width * .05),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.subjects} Details',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * .0045,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: mq.width * .05,
                  top: mq.height * .01,
                  right: mq.width * .05),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Here you can find the status of attendances if they were present or not with their dates",
                    maxLines: null,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                  )),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 8.0, bottom: 8, right: 38),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Colors.black,
                        ),
                        onPressed: () => _changeMonth(-1),
                      ),
                      Text(
                        DateFormat("MMMM yyyy").format(_selectedMonth),
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 35,
                          color: Colors.black,
                        ),
                        onPressed: () => _changeMonth(1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                  child: Container(
                      // height: mq.height *.25,
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 20, bottom: 0),
                      // height: mq.height * .4,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221)),
                          borderRadius: BorderRadius.circular(8)),
                      child: _buildCalendar()),
                ),
              ],
            ),
            SizedBox(
              height: mq.height * .01,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: mq.width * .05,
                  right: mq.width * .05,
                  top: mq.height * .03),
              child: Row(
                children: [
                  SizedBox(
                    width: mq.width * .026,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '$totalLecture',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Total Lectures',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      )
                    ],
                  ),
                  SizedBox(
                    width: mq.width * .1,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade900,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '$totalAttendedLectures',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Attended',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      )
                    ],
                  ),
                  SizedBox(
                    width: mq.width * .1,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '$totalNotAttendedLectures',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Not-Attended',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> fetchData() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFromDate = formatter.format(widget.fromDate);
    final String formattedToDate = formatter.format(widget.toDate);
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
            'subjectId': widget.subjectId
          });
      log(response.data);
      log(widget.fromDate.toString());
      log(widget.toDate.toString());
      Map<String, dynamic> data = json.decode(response.data);
      if (data['errorCode'] == '0000') {
        List<dynamic> dataList = data['dataList'];
        for (var item in dataList) {
          attendanceDates.add(DateTime.parse(item['attendanceDate']));
        }
        List<dynamic> dataListB = data['notAttendedList'];
        for (var item in dataListB) {
          attendanceDatesB.add(DateTime.parse(item['attendanceDate']));
        }
        totalLecture = data['totalLecture'];
        totalAttendedLectures = data['totalAttendedLectures'];
        totalNotAttendedLectures = data['totalNotAttendedLectures'];
        setState(() {});
      } else {
        print('Error: ${data['errorMessage']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
  }
}
