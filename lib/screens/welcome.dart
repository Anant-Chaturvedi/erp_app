
import 'package:erp_app/screens/parent_login.dart';
import 'package:erp_app/screens/student_login.dart';
import 'package:erp_app/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


late Size mq;
DateTime? _lastPressedAt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedOption;
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: const Color.fromARGB(255, 13, 60, 160)));
    mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 1)) {
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
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/student.jpg'))),
                child: Column(children: [
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
                    padding: EdgeInsets.only(left: mq.width * .05),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Welcome",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: mq.width * .05,
                        top: mq.height * .01,
                        right: mq.width * .05),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Before You Proceed To Login, Please Kindly Select If You Are A Student Or Parent",
                          maxLines: null,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 19),
                        )),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: mq.width * .05, right: mq.width * .05),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: MediaQuery.of(context).size.height * .058,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 1.7),
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          _selectedOption ?? 'Please Select',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.black,
                          size: 38,
                        ),
                        onTap: () {
                          _showOptionsDialog(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: mq.width * .05, right: mq.width * .05),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * .057),
                          backgroundColor: Colors.amber.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (_isSelected == true) {
                          if (_selectedOption == "Student") {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => const StudentLogin()));
                          } else if (_selectedOption == "Parent") {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => const ParentLogin()));
                          }
                        } else {
                          MyDialogs.showSnackbar(
                              context: context,
                              Color: Colors.red,
                              msg: 'Please Select Something to Proceed.');
                        }
                      },
                      child: const Text(
                        "Proceed",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .22,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Powered By:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            letterSpacing: 0.9,
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: mq.height * .03,
                        ),
                        Text(
                          'SK infotechies',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            letterSpacing: 0.9,
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            )),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Container(
            height: 174,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            width: 800,
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
                        left: 29.0, right: 22, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Please Select',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 140,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              '     Parent',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedOption = 'Parent';
                                _isSelected = true;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Divider(
                          height: 0,
                          color: Color.fromARGB(255, 206, 206, 206),
                          thickness: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 134,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('     Student',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            onTap: () {
                              setState(() {
                                _selectedOption = 'Student';
                                _isSelected = true;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
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
