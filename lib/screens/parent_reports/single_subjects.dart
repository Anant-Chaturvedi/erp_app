// ignore_for_file: unused_element, depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class SingleSubject extends StatefulWidget {
  const SingleSubject(
      {super.key,
      required this.selDate,
      required this.fromDate,
      required this.toDate});
  final String selDate;
  final DateTime fromDate;
  final DateTime toDate;
  @override
  State<SingleSubject> createState() => _SingleSubjectState();
}

class _SingleSubjectState extends State<SingleSubject> {
  List<DateTime> markedDatesYellow = [];
  List<DateTime> markedDatesBlack = [];

  final Map<String, String> _subjects = {};
  List<String> _subjectNames = [];
  String _selectedSubject = '';
  String _selectedSubjectId = '';
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  int totalLecture = 0;
  int totalAttendedLectures = 0;
  int totalNotAttendedLectures = 0;
  String selectedDate = '';
  bool isTap = false;
  List<DateTime> attendanceDates = [];
  List<DateTime> attendanceDatesB = [];

//other class codes
  Size? mq;

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
              margin: const EdgeInsets.all(13.5),
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

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1900),
    );
    if (picked != null) {
      setState(() {
        // isTap = true;
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
        selectedDate =
            '${DateFormat.yMMMMd("en_US").format(_selectedStartDate)} - ${DateFormat.yMMMMd("en_US").format(_selectedEndDate)}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.fromDate;
    fetchSubjectData();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
              body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/ind.png'))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: mq!.width * .05,
                      right: mq!.width * .05,
                      top: mq!.height * .05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: mq!.height * .0408,
                          width: mq!.width * .104,
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
                  height: mq!.height * .077,
                ),
                Padding(
                  padding: EdgeInsets.only(left: mq!.width * .05),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Subject Report",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.indigo.shade900,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq!.height * .02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: mq!.width * .05,
                    right: mq!.width * .05,
                  ),
                  child: InkWell(
                    onTap: () {
                      showSubjectSelectionDialog(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: MediaQuery.of(context).size.height * .058,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 1.7,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: _selectedSubject.isEmpty
                          ? const Center(
                              child: Text(
                                'Fetching Subjects...',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 13, right: 13),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedSubject,
                                    // overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: _selectedSubject.length > 35
                                            ? 18
                                            : 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.black,
                                    size: 37,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq!.height * .02,
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: mq!.width * .05, right: mq!.width * .05),
                    child: Container(
                      padding: const EdgeInsets.only(left: 22, right: 22),
                      height: MediaQuery.of(context).size.height * .058,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 1.7),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isTap
                                ? Text(
                                    selectedDate,
                                    style: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                : Text(
                                    widget.selDate,
                                    style: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                            Image.asset(
                              'assets/images/calendar.png',
                              height: mq!.height * .033,
                            ),
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq!.height * .015,
                ),
                Divider(
                  color: Colors.grey.shade200,
                  thickness: 1.7,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: mq!.width * .05),
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 20, bottom: 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 221, 221, 221)),
                              borderRadius: BorderRadius.circular(8)),
                          child: _buildCalendar()),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq!.height * .024,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mq!.width * .06,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        )
                      ],
                    ),
                    SizedBox(
                      width: mq!.width * .09,
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
                          '     Attended     ',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        )
                      ],
                    ),
                    SizedBox(
                      width: mq!.width * .08,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        )
                      ],
                    ),
                    SizedBox(
                      width: mq!.width * .00,
                    ),
                  ],
                )
              ],
            ),
          )),
        ),
        Visibility(
            visible: _selectedSubject.isEmpty,
            child: Positioned.fill(
              child: Scaffold(
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Colors.amber.shade600,
                  ))),
            )),
      ],
    );
  }

  Future<void> fetchSubjectData() async {
    try {
      final dio = Dio();
      final box = await Hive.openBox('child');
      final selectedChildId = box.get('selected_child_id');
      dio.options.contentType = 'application/json';
      final Response response = await dio.post(
          'https://skinfotechies.in/demo/erp/api/fetch-subjects-list.php',
          data: {'userId': selectedChildId});
      log(response.data);
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      if (jsonData['errorCode'] == '0000') {
        if (jsonData['dataList'].length != 0) {
          _subjects.clear();
          jsonData['dataList'].forEach((subject) {
            _subjects[subject['subjectName']] = subject['subjectId'];
          });
          _subjectNames = _subjects.keys.toList();
          if (_subjectNames.isNotEmpty) {
            _selectedSubject = _subjectNames[0];
            _selectedSubjectId = _subjects[_selectedSubject]!;
            await fetchDataN();
          }
          setState(() {});
        } else {}
      }
    } catch (error) {}
  }

  fetchData() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFromDate = formatter.format(widget.fromDate);
    final String formattedToDate = formatter.format(widget.toDate);
    final dio = Dio();
    try {
      final box = await Hive.openBox('child');
      final selectedChildId = box.get('selected_child_id');
      log('Anant$_selectedSubjectId');
      log(formattedFromDate);
      log(formattedToDate);
      final response = await dio.post(
          'https://skinfotechies.in/demo/erp/api/fetch-attendance-report.php',
          data: {
            'userId': selectedChildId,
            'fromDate': formattedFromDate,
            'toDate': formattedToDate,
            'subjectId': _selectedSubjectId
                .toString() // use the extracted subjectId here
          });
      log(response.data);
      final decodedData = json.decode(response.data);
      final dataList = decodedData['dataList'];
      final dataListB = decodedData['notAttendedList'];

      totalAttendedLectures = decodedData['totalAttendedLectures'];
      totalNotAttendedLectures = decodedData['totalNotAttendedLectures'];
      totalLecture = decodedData['totalLecture'];
      final markedDates = dataList
          .map((data) => DateTime.parse(data['attendanceDate'])
              .toLocal()) // convert UTC time to local time
          .toList()
          .cast<DateTime>(); // cast to List<DateTime>
      markedDatesYellow.addAll(markedDates);
      for (var i = 0; i < markedDates.length; i++) {
        //black dates
        final markedDatesB = dataListB
            .map((data) => DateTime.parse(data['attendanceDate'])
                .toLocal()) // convert UTC time to local time
            .toList()
            .cast<DateTime>(); // cast to List<DateTime>
        markedDatesBlack.addAll(markedDatesB);
        for (var i = 0; i < markedDatesB.length; i++) {
          setState(() {
            markedDatesYellow = markedDates;
            markedDatesBlack = markedDatesB;
          });
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
  }

  showSubjectSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 500,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 13, 60, 160),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 29.0, right: 22, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Subjects',
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
                const SizedBox(
                  height: 7,
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1.5,
                          color: Colors.grey[300],
                          height: 10,
                        );
                      },
                      itemCount: _subjectNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        final value = _subjectNames[index];
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedSubject = value;
                              _selectedSubjectId = _subjects[_selectedSubject]!;
                              Navigator.pop(context);
                              fetchDataN();
                              // fetchSubjectData();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchDataN() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFromDate = formatter.format(widget.fromDate);
    final String formattedToDate = formatter.format(widget.toDate);
    try {
      final box = await Hive.openBox('child');
      final selectedChildId = box.get('selected_child_id');
      final response = await Dio().post(
          'https://skinfotechies.in/demo/erp/api/fetch-attendance-report.php',
          data: {
            'userId': selectedChildId,
            'fromDate': formattedFromDate,
            'toDate': formattedToDate,
            'subjectId': _selectedSubjectId
          });
      log(response.data);
      log(widget.fromDate.toString());
      log(widget.toDate.toString());
      Map<String, dynamic> data = json.decode(response.data);
      if (data['errorCode'] == '0000') {
        attendanceDates.clear();
        attendanceDatesB.clear();
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
}
