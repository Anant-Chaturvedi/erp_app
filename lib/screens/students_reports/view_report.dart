import 'package:erp_app/screens/dashboard.dart';
import 'package:erp_app/screens/students_reports/single_subjects.dart';
import 'package:erp_app/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'report.dart';

late Size mq;

class ViewReportA extends StatefulWidget {
  final String presentLectures;
  final String absentLectures;
  final String percentage;
  const ViewReportA(
      {super.key,
      required this.presentLectures,
      required this.absentLectures,
      required this.percentage});

  @override
  State<ViewReportA> createState() => _ViewReportAState();
}

class _ViewReportAState extends State<ViewReportA> {
  final legendLabels = <String, String>{"Present": '25', "Absent": "05"};
  String _selectedSubject = 'Single Subject';

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 7));
  String selectedDate = '';
  bool isSingleDate = false;

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1900),
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        selectedDate = DateFormat.yMMMMd("en_US").format(_selectedDate);
        isSingleDate = true;
      });
    }
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1900),
    );
    if (picked != null) {
      final fromDate = picked.start;
      final toDate = picked.end;
      setState(() {
        _selectedStartDate = fromDate;
        _selectedEndDate = toDate;
        selectedDate =
            '${DateFormat.d("en_US").format(_selectedStartDate)} ${DateFormat.MMM("en_US").format(_selectedStartDate)} ${DateFormat.y("en_US").format(_selectedStartDate)} - '
            '${DateFormat.d("en_US").format(_selectedEndDate)} ${DateFormat.MMM("en_US").format(_selectedEndDate)} ${DateFormat.y("en_US").format(_selectedEndDate)}';
        isSingleDate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"Present": 0, "Absent": 0};
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    final now = DateTime.now();
    final currentMonth = DateFormat('MMM').format(now);
    mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context,
            CupertinoPageRoute(builder: (_) => const Dashboard()), (route) => false);
        return true;
      },
      child: SafeArea(
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
                    left: mq.width * .05,
                    right: mq.width * .05,
                    top: mq.height * .05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (_) => const Dashboard()),
                          (Route<dynamic> route) => false,
                        );
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
                height: mq.height * .06,
              ),
              SizedBox(
                height: mq.height * .0,
              ),
              SizedBox(
                height: mq.height * .015,
              ),
              Padding(
                padding: EdgeInsets.only(left: mq.width * .05),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Current Month Report",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 23,
                        color: Color.fromARGB(255, 5, 27, 75),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .006,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: mq.width * .05,
                    right: mq.width * .05,
                    top: mq.height * .01),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 200,
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
                        height: mq.height * .00,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 14, bottom: 0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6.0,
                                    spreadRadius: 8.0,
                                    offset: const Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              child: PieChart(
                                dataMap: dataMap,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                colorList: [
                                  Colors.black,
                                  Colors.amber,
                                ],
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32,
                                centerText: '${widget.percentage}%',
                                centerTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendLabels: legendLabels,
                                  // legendPosition: LegendPosition.,
                                  showLegends: false,
                                  // legendShape: _BoxShape.circle,
                                  legendShape: BoxShape.rectangle,
                                  legendTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: const ChartValuesOptions(
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
                                top: 10.0, right: 14, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Month Count ($currentMonth)',
                                  style: const TextStyle(
                                      fontSize: 23,
                                        letterSpacing: 1,
                                      color: Color.fromARGB(255, 13, 60, 160),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: mq.height * .01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 47,
                                      width: 52,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        widget.presentLectures,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Text(
                                      '  Lectures Present',
                                      style: TextStyle(fontSize: 18,letterSpacing: 1),
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
                                      height: 47,
                                      width: 52,
                                      decoration: BoxDecoration(
                                          color: Colors.amber.shade600,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        widget.absentLectures,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Text(
                                      '  Lectures Absent',
                                      style: TextStyle(fontSize: 18,letterSpacing: 1),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
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
                    "View Attendance By",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 24,
                         letterSpacing: 1,
                        color: Color.fromARGB(255, 5, 27, 75),
                        fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        content: Container(
                          height: 179,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          width: 800,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    color:
                                        Color.fromARGB(255, 13, 60, 160),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 22,
                                      top: 12,
                                      bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('  Subjects',
                                          style: TextStyle(
                                              fontSize: 22,
                                               letterSpacing: 1,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 32,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildListItem('Single Subject'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    height: 0,
                                    color: Color.fromARGB(255, 206, 206, 206),
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildListItem('All Subject'),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .05, right: mq.width * .05),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 18, right: 20),
                    height: MediaQuery.of(context).size.height * .058,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        width: 1.7,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedSubject,
                          style: const TextStyle(
                            color: Colors.black,
                             letterSpacing: 1,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black,
                          size: 35,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              InkWell(
                onTap:datePicker,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .05, right: mq.width * .05),
                  child: Container(
                    padding: const EdgeInsets.only(left: 18, right: 20),
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
                            selectedDate.isEmpty
                                ? 'Select Date Range'
                                : selectedDate,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                 letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto'),
                          ),
                          Image.asset(
                            'assets/images/calendar.png',
                            height: mq.height * .035,
                          )
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .25,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: mq.width * .07, right: mq.width * .07),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        elevation: 0,

                      minimumSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * .053),
                      backgroundColor: Colors.amber.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    if (selectedDate.isNotEmpty) {
                      if (_selectedSubject == "All Subject") {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => AttendanceA(
                                      selDate: selectedDate,
                                      fromDate: isSingleDate
                                          ? _selectedDate
                                          : _selectedStartDate,
                                      toDate: 
                                      isSingleDate ? _selectedDate :
                                      _selectedEndDate,
                                    )));
                      } else if (_selectedSubject == "Single Subject") {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => SingleSubjectA(
                                      fromDate: isSingleDate
                                          ? _selectedDate
                                          : _selectedStartDate,
                                      toDate: isSingleDate
                                          ? _selectedDate
                                          : _selectedEndDate,
                                      selDate: selectedDate,
                                    )));
                      }
                    } else {
                      MyDialogs.showSnackbar(
                          context: context,
                          Color: Colors.red.shade600,
                          msg: 'Please select a date range!');
                    }
                  },
                  child: const Text(
                    "View Report",
                    style: TextStyle(
                        color: Colors.black,
                          letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

    Widget _buildListItem(String value) {
    return GestureDetector(
      onTap: () {
        // Update state with selected value
        setState(() {
          _selectedSubject = value;
        });
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                 letterSpacing: 1,
                fontSize: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  datePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 176,
            width: 800,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        const Text('Please Select',
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showDateRangePicker();
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment:Alignment.center,
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color.fromARGB(255, 206, 206, 206), width: 2)),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.date_range,
                              size: 27,
                              color: Colors.orange.shade600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Date Range',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Perform single date selection action
                        Navigator.pop(context);
                        _showDatePicker();
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color.fromARGB(255, 206, 206, 206), width: 2)),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.calendar_today,
                              size: 25,
                              color: Colors.orange.shade600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Single Date',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8),
                          ),
                        ],
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
