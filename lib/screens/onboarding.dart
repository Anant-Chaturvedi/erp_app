// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:erp_app/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

late Size mq;

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  _OnboardingScreen1State createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  int _currentPage = 0;

  final List<String> _titles = [
    "Easy Attendance System",
    "GPS Based Attendance ",
    "Clean Report View"
  ];

  final List<String> _subtitles = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  ];

  final List<String> _images = ["o_1", "o_2", "o_3"];

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 5, 27, 75)));
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 5, 13, 104),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,

// fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/new.jpg'))),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: mq.height * .03, right: mq.width * .05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(''),
                    GestureDetector(
                      onTap: () async {
                        final box = await Hive.openBox('skip');
                        box.put('isLogged', true);

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == _titles.length - 1
                                ? "Skip"
                                : "Skip",
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                letterSpacing: 1),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mq.height * .1,
              ),
              Image.asset(
                'assets/images/${_images[_currentPage]}.png',
                height: mq.height * .3,
              ),
              Expanded(
                child: Container(
                  // height: 400,
                  width: double.maxFinite,

                  padding: EdgeInsets.only(
                    top: mq.height * .08,
                    bottom: 32.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .068),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _titles[_currentPage],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: mq.width * .068, right: mq.width * .068),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _subtitles[_currentPage],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 19.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * .06,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: mq.height * .013,
                                  width: mq.width * .36,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _titles.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            right: mq.width * .01),
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: _currentPage == index
                                                    ? Colors.transparent
                                                    : Colors.white),
                                            color: _currentPage == index
                                                ? Colors.amber.shade600
                                                : Colors.transparent,
                                            shape: BoxShape.circle),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width * .3,
                                      MediaQuery.of(context).size.height * .05),
                                  backgroundColor: Colors.amber.shade600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                if (_currentPage == _titles.length - 1) {
                                  final box = await Hive.openBox('skip');
                                  box.put('isLogged', true);
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => const HomePage()));
                                } else {
                                  setState(() {
                                    _currentPage =
                                        (_currentPage + 1) % _titles.length;
                                  });
                                }
                              },
                              child: Text(
                                _currentPage == _titles.length - 1
                                    ? "Continue"
                                    : "Next",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    letterSpacing: 0.9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
