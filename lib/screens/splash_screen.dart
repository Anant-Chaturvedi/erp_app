// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:erp_app/screens/dashboard.dart';
import 'package:erp_app/screens/dashboard_stu.dart';
import 'package:erp_app/screens/onboarding.dart';
import 'package:erp_app/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

late Size mq;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic checkUser() async {
    final userBox = await Hive.openBox('user');
    final parentBox = await Hive.openBox('user_parent');
    final skipBox = await Hive.openBox('skip');

    if (userBox.get('isLogged') ?? false) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const Dashboard()),
          (route) => false);
    } else if (parentBox.get('isLogged') ?? false) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const StudentDash()),
          (route) => false);
    } else if (skipBox.get('isLogged') ?? false) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const OnboardingScreen1()),
          (route) => false);
    }
  }

  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), checkUser);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 5, 13, 104),
        body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    // fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/splash.png'))),
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * .67,
                ),
                const Text(
                  '\nERP PORTAL FOR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.9,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                const Text(
                  'JSS ACADEMY OF TECHNICAL EDUCATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // letterSpacing: 0.9,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: mq.height * .14,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Powered By:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.9,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: mq.height * .04,
                      ),
                      const Text(
                        'SK infotechies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          letterSpacing: 0.9,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
