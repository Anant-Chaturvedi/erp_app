// ignore_for_file: unused_element, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erp_app/screens/student_login.dart';
import 'package:erp_app/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dashboard_stu.dart';

late Size mq;

class RadioButtonPage extends StatefulWidget {
  const RadioButtonPage({super.key});
  @override
  _RadioButtonPageState createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage> {
  int? _selectedRadio;
  String selectedChildId = '';
  // Data source for kid profiles
  final List<Map<String, dynamic>> kidProfiles = [];

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedRadio = value!;
    });
  }

  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (_) => const ParentLogin()),
            (route) => false);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/kids.jpg'),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: mq.width * .05,
                    right: mq.width * .05,
                    top: mq.height * .04,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const ParentLogin()),
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
                      const Text(''),
                    ],
                  ),
                ),
                SizedBox(
                  height: mq.height * .055,
                ),
                Padding(
                  padding: EdgeInsets.only(left: mq.width * .06),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Welcome,",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: mq.width * .06,
                    top: mq.height * .01,
                    right: mq.width * .06,
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Please select the Kid’s profile you\nwant to check",
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white70, fontSize: 19),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .029,
                ),
                SizedBox(
                  height: mq.height * .04,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .00, right: mq.width * .05),
                  child: SizedBox(
                    height: 500,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: mq.height * .03,
                      crossAxisSpacing: mq.width * .05,
                      children: List.generate(kidProfiles.length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(kidProfiles[index]['image']),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  _selectedRadio = index;
                                  selectedChildId =
                                      kidProfiles[index]['childId'];
                                  isSelected = true;
                                });

                                // Save selected child ID to Hive box
                                final box = await Hive.openBox('child');
                                await box.put(
                                    'selected_child_id', selectedChildId);
                                final selectedChildIdd =
                                    box.get('selected_child_id');
                                log('Selected child ID: $selectedChildIdd');
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: mq.height * .01, left: mq.width * .05),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 36),
                                      height: 28,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: _selectedRadio == index
                                              ? Colors.amber.shade700
                                              : Colors.amber.shade700,
                                        ),
                                      ),
                                      child: _selectedRadio == index
                                          ? Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.amber.shade700,
                                              ),
                                            )
                                          : Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kidProfiles[index]['name'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontFamily: 'Urbanist'),
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          kidProfiles[index]['class'],
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18,
                                              fontFamily: 'Urbanist'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .085,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: mq.width * .05,
                    right: mq.width * .05,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: Size(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height * .056),
                        backgroundColor: Colors.amber.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      isSelected
                          ? Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const StudentDash()),
                              // (Route<dynamic> route) => false,
                            )
                          : MyDialogs.showSnackbar(
                              context: context,
                              Color: Colors.red,
                              msg: 'Please select the child to continue');
                    },
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String wrapText(String text) {
    return text.replaceAllMapped(
        RegExp(r"(.{1,12})(?:\s+|$)"), (match) => "${match.group(1)}- ");
  }

  Future<void> fetchData() async {
    try {
      final box = await Hive.openBox('user_parent');
      final userData = jsonDecode(box.get('parent_data'));
      final String userId = userData['userId'];
      Response response = await Dio().post(
          'https://skinfotechies.in/demo/erp/api/fetch-childs-list.php',
          data: {"userId": userId, "userRole": "parent"});
      log(response.data);
      dynamic data = json.decode(response.data);

      if (data['errorCode'] == '0000') {
        List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(data['dataList']);
        final box = await Hive.openBox('child');
        box.put('child_data', response.data);

        for (var item in dataList) {
          kidProfiles.add({
            'childId': item['childId'], // add childId to the profile
            'name': item['childName'],
            'class': '${'Branch-' + item['branch']} \nSection-' +
                item['childMainSection'],
            'image': 'assets/images/k_1.png' // add your image here
          });
        }

        setState(() {});
      } else {
        // Handle error here
        print('Error: ${data['errorMessage']}');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
