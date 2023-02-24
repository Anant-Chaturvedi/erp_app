// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:erp_app/screens/dashboard_stu.dart';
import 'package:erp_app/screens/selection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import '../widgets/custom_dialog.dart';
import 'dashboard.dart';
import 'dart:convert';

late Size mq;

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final _formKeyC = GlobalKey<FormState>();
  String? mobileNumber;
  String? password;
  bool _isloading = false;
  String _fcmToken = '';
  bool _hasText = false;
  bool _hasT = false;
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
        .copyWith(statusBarColor: Color.fromARGB(255, 252, 163, 17)));
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
                        image: AssetImage('assets/images/orange.jpg'))),
                child: Form(
                  key: _formKeyC,
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * .08,
                      ),
                      SizedBox(
                        height: mq.height * .33,
                      ),
                      // Image.asset(
                      //   'assets/images/main_logo.png',
                      //   height: mq.height * .33,
                      // ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * .06),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Parent Login",
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(fontSize: 18),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }
                              return null;
                            },
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
                            onSaved: (value) => mobileNumber = value,
                            decoration: InputDecoration(
                                hintText: 'Mobile Number',
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
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 18),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }
                              return null;
                            },
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
                            onSaved: (value) => password = value,
                            decoration: InputDecoration(
                                hintText: 'Password',
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
                              backgroundColor:
                                  Color.fromARGB(255, 252, 163, 17),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () async {
                            if (_hasText == true && _hasT == true) {
                              if (_formKeyC.currentState!.validate()) {
                                setState(() {
                                  _isloading = true;
                                });
                                _formKeyC.currentState!.save();
                                try {
                                  final dio = Dio();
                                  final response = await dio.post(
                                      'https://skinfotechies.in/demo/erp/api/login.php',
                                      data: {
                                        'userRole': 'parent',
                                        'mobileNumber': mobileNumber,
                                        'password': password
                                      });
                                  final Map<String, dynamic> jsonData =
                                      jsonDecode(response.data);
                                  print(response.data);

                                  if (jsonData['errorCode'] == '0000') {
                                    final box =
                                        await Hive.openBox('user_parent');
                                    box
                                      ..put('isLogged', true)
                                      ..put('parent_data', response.data);
                                    _sendToken();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => RadioButtonPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    if (jsonData['errorCode'] == '0001') {
                                      MyDialogs.showSnackbar(
                                          context: context,
                                          Color: Colors.indigo.shade900,
                                          msg: 'Invalid Credentials');
                                    } else {
                                      MyDialogs.showSnackbar(
                                          context: context,
                                          Color: Colors.blue,
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
                                  Color: Colors.blue,
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
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
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
    final box = await Hive.openBox('user_parent');
    final userData = jsonDecode(box.get('parent_data'));
    final String userId = userData['userId'];
    final response = await dio.post(
        'https://skinfotechies.in/demo/erp/api/saveUserToken.php',
        data: {'userId': userId, 'userRole': 'parent', 'token': _fcmToken});
    final Map<String, dynamic> jsonData = jsonDecode(response.data);
    log('Anant' + response.data);
  }
}
