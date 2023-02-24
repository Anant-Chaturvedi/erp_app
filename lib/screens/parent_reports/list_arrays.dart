import 'package:erp_app/screens/parent_reports/wise_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_deccoration.dart';
import '../../utils/color_constant.dart';
import '../../utils/size.dart';
import '../../widgets/custom_button.dart';

// ignore: must_be_immutable
class Listframefortyfour1ItemWidget extends StatefulWidget {
  const Listframefortyfour1ItemWidget(
      {super.key,
      required this.subjects,
      required this.strip,
      required this.totalP,
      required this.totalA,
      required this.total,
      required this.subId,
      required this.fromDate,
      required this.toDate});
  final String subjects;
  final Color strip;
  final String totalP;
  final String totalA;
  final String total;
  final String subId;
  final DateTime fromDate;
  final DateTime toDate;
  @override
  State<Listframefortyfour1ItemWidget> createState() =>
      _Listframefortyfour1ItemWidgetState();
}

class _Listframefortyfour1ItemWidgetState
    extends State<Listframefortyfour1ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      decoration: AppDecoration.outlineBluegray9003f3.copyWith(
        border: Border.all(color: const Color.fromARGB(255, 221, 221, 221)),
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: getVerticalSize(
                  widget.subjects.length > 29 ? 99.00 : 80,
                ),
                width: getHorizontalSize(
                  10.00,
                ),
                decoration: BoxDecoration(
                  color: widget.strip,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      getHorizontalSize(
                        010.00,
                      ),
                    ),
                    bottomLeft: Radius.circular(
                      getHorizontalSize(
                        10.00,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 12,
                  bottom: 9,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.subjects.replaceAllMapped(
                          RegExp("(.{29})"), (match) => "${match.group(0)}\n"),
                      style: TextStyle(
                        color: widget.strip,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Attended",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                    fontFamily: 'Urbanist'),
                              ),
                              Text(
                                widget.totalP,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Urbanist'),
                              ),
                            ],
                          ),
                          Container(
                            height: getVerticalSize(
                              15.00,
                            ),
                            width: getHorizontalSize(
                              1.5,
                            ),
                            margin: getMargin(
                              left: 7,
                              top: 1,
                              bottom: 17,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.blueGray900Bf01,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Not-Attended",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade800,
                                      fontFamily: 'Urbanist'),
                                ),
                                Text(
                                  widget.totalA,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Urbanist'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: getVerticalSize(
                              15.00,
                            ),
                            width: getHorizontalSize(
                              1.5,
                            ),
                            margin: getMargin(
                              left: 7,
                              top: 1,
                              bottom: 17,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.blueGray900Bf01,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Total",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade800,
                                      fontFamily: 'Urbanist'),
                                ),
                                Text(
                                  widget.total,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Urbanist'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomButton(
            height: 28,
            width: 105,
            text: "View details",
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => WiseReport(
                      subjects: widget.subjects,
                      subjectId: widget.subId,
                      fromDate: widget.fromDate,
                      toDate: widget.toDate,
                    ),
                  ));
            },
            margin: getMargin(
              // left: MediaQuery.of(context).size.width * .142,
              top: 18,
              right: 16,
              bottom: 13,
            ),
            fontStyle: ButtonFontStyle.RobotoRomanMedium12,
          ),
        ],
      ),
    );
  }
}
