import 'dart:convert';
import 'dart:developer';

import 'package:erp_app/screens/dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import '../widgets/custom_dialog.dart';

late Size mq;

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final _formKey = GlobalKey<FormState>();
  String? parentName;
  String? uniRollNo;
  bool _isloading = false;
  bool _hasText = false;
  bool _hasT = false;
  String _fcmToken = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        _fcmToken = token!;
      });
      log('FCM Token anant parent: $_fcmToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Color.fromARGB(255, 13, 60, 160)));
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/student.jpg'))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * .08,
                      ),
                      SizedBox(
                        height: mq.height * .33,
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * .06),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Student Login",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mq.width * .06,
                            top: mq.height * .016,
                            right: mq.width * .06),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please Enter Your Unique ID Here With Your\nFull Name",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 19),
                            )),
                      ),
                      SizedBox(
                        height: mq.height * .036,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mq.width * .05, right: mq.width * .05),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: mq.width * .03, top: mq.height * .006),
                          height: mq.height * .06,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.length > 0) {
                                setState(() {
                                  _hasT = true;
                                });
                              } else {
                                setState(() {
                                  _hasT = false;
                                });
                              }
                            },
                            style: TextStyle(fontSize: 18),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                            onSaved: (value) => parentName = value,
                            decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .025,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mq.width * .05, right: mq.width * .05),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: mq.width * .03, top: mq.height * .005),
                          height: mq.height * .057,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.length > 0) {
                                setState(() {
                                  _hasText = true;
                                });
                              } else {
                                setState(() {
                                  _hasText = false;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the university roll no.";
                              }
                              return null;
                            },
                            onSaved: (value) => uniRollNo = value,
                            decoration: InputDecoration(
                                hintText: 'University Roll No.',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .163,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mq.width * .05, right: mq.width * .05),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height * .057),
                              backgroundColor: Colors.amber.shade600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () async {
                            if (_hasT == true && _hasText == true) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isloading = true;
                                });
                                _formKey.currentState!.save();
                                try {
                                  final dio = Dio();
                                  final response = await dio.post(
                                      'https://skinfotechies.in/demo/erp/api/login.php',
                                      data: {
                                        'userRole': 'student',
                                        'fullName': parentName,
                                        'universityRollNumber': uniRollNo
                                      });
                                  final Map<String, dynamic> jsonData =
                                      jsonDecode(response.data);
                                  print(response.data);

                                  if (jsonData['errorCode'] == '0000') {
                                    final box = await Hive.openBox('user');
                                    box
                                      ..put('isLogged', true)
                                      ..put('student_data', response.data);
                                    _sendToken();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => Dashboard()),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    if (jsonData['errorCode'] == '0001') {
                                      MyDialogs.showSnackbar(
                                          context: context,
                                          Color: Colors.amber.shade900,
                                          msg: 'Invalid Credentials');
                                    } else {
                                      MyDialogs.showSnackbar(
                                          context: context,
                                          Color: Colors.amber.shade900,
                                          msg: jsonData['errorMessage']);
                                    }
                                  }
                                } catch (e) {
                                  // Fluttertoast.showToast(msg: 'No Internet Connection');
                                } finally {
                                  setState(() {
                                    _isloading = false;
                                  });
                                }
                              }
                            } else {
                              MyDialogs.showSnackbar(
                                  context: context,
                                  Color: Colors.amber.shade900,
                                  msg: 'Please fill all the fields');

                              setState(() {
                                _isloading = false;
                              });
                            }
                          },
                          child: const Text(
                            "Proceed",
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'Roboto'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
            visible: _isloading,
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

  _sendToken() async {
    final dio = Dio();
    final box = await Hive.openBox('user');
    final userData = jsonDecode(box.get('student_data'));
    final String userId = userData['userId'];
    final response = await dio.post(
        'https://skinfotechies.in/demo/erp/api/saveUserToken.php',
        data: {'userId': userId, 'userRole': 'student', 'token': _fcmToken});
    final Map<String, dynamic> jsonData = jsonDecode(response.data);
    log('Student Token' + response.data);
  }
}
