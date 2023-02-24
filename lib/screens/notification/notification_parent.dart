import 'package:flutter/material.dart';

late Size mq;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Tween<Offset> _offsetTween;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'First notification',
      subtitle: 'We believe in the power of mobile computing.',
      date: '2022-02-21',
      time: '09:00',
    ),
    NotificationItem(
      title: 'Second notification',
      subtitle: 'We believe in the power of mobile computing.',
      date: '2022-02-20',
      time: '12:30',
    ),
    NotificationItem(
      title: 'Third notification',
      subtitle: 'We believe in the power of mobile computing.',
      date: '2022-02-19',
      time: '18:45',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetTween =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _removeNotification(int index) {
    _notifications.removeAt(index);
    _controller.forward();
  }

  Widget _buildNotificationItem(
      BuildContext context, int index, Animation<double> animation) {
    final item = _notifications[index];
    return SlideTransition(
      position: animation.drive(_offsetTween),
      child: Dismissible(
        key: Key(item.hashCode.toString()),
        onDismissed: (_) => _removeNotification(index),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 10),
          child: Card(
              elevation: 2,
              surfaceTintColor: Colors.yellow,
              shadowColor: Colors.cyanAccent,
              color: const Color(0xFFF1F1F1).withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 18, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Message',
                          style: TextStyle(fontSize: 16, letterSpacing: 0.6),
                        ),
                        Text('Today 10.48 PM',
                            style: TextStyle(fontSize: 16, letterSpacing: 0.6))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 39),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Icon(
                            Icons.account_circle,
                            size: 54,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                  fontSize: 19,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.subtitle.replaceAllMapped(RegExp("(.{34})"),
                                  (match) => "${match.group(0)}\n"),
                              style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.8,
                                  color: Colors.black87,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
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
                    top: mq.height * .03),
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
                      '   Notifications                   ',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mq.height * .08,
              ),
              SizedBox(
                height: mq.height * .0,
              ),
              SizedBox(
                height: mq.height * .015,
              ),
              SizedBox(
                height: 800,
                child: AnimatedList(
                  controller: _scrollController,
                  initialItemCount: _notifications.length,
                  itemBuilder: (context, index, animation) =>
                      _buildNotificationItem(context, index, animation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String date;
  final String time;

  NotificationItem(
      {required this.title,
      required this.subtitle,
      required this.date,
      required this.time});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          date == other.date &&
          time == other.time;

  @override
  int get hashCode =>
      title.hashCode ^ subtitle.hashCode ^ date.hashCode ^ time.hashCode;
}
