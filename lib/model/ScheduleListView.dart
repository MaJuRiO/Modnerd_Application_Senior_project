import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:senior_project/class_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/colors_util.dart';
import 'utils/date_utils.dart' as date_util;

class Schedule extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> todos;
  const Schedule({Key? key, required this.title, required this.todos})
      : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();

  TextEditingController controller = TextEditingController();

  Future<Map<String, dynamic>> fetchAPI(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    try {
      // ทำการ GET request ด้วย http.get() และรอการตอบกลับ
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // ตรวจสอบสถานะของ response
      if (response.statusCode == 200) {
        // ถ้าสำเร็จ ให้แปลงข้อมูล JSON ให้เป็น Map และ return
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // ถ้าไม่สำเร็จ ให้ throw ข้อผิดพลาด
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (error) {
      // กรณีเกิดข้อผิดพลาดในการเชื่อมต่อ
      throw Exception('Failed to load data: $error');
    }
  }

  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Text(
        date_util.DateUtils.months[currentDateTime.month - 1] +
            ' ' +
            currentDateTime.year.toString(),
        style: TextStyle(
            color: HexColor('A9A8A9'),
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  Widget hrizontalCapsuleListView() {
    return SizedBox(
      width: width,
      height: 80,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.6)
                          ]
                        : [
                            HexColor("ED6184"),
                            HexColor("EF315B"),
                            HexColor("E2042D")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView() {
    return Container(
      height: height,
      width: width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
          ]),
    );
  }

  Widget studentClass() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, height * 0.38, 10, 10),
      width: width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: widget.todos.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            if (widget.todos[index]['Date'] ==
                DateFormat('yyyy-MM-dd').format(currentDateTime)) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.todos[index]['course_detail']['start_time']}'
                              .substring(0, 5),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: HexColor('A9A8A9')),
                        ),
                        Text(
                          '${widget.todos[index]['course_detail']['end_time']}'
                              .substring(0, 5),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: HexColor('A9A8A9')),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // สีของเงา
                          spreadRadius: 5, // รัศมีการกระจายของเงา
                          blurRadius: 7, // ความเบลอของเงา
                          offset: const Offset(0, 3), // ตำแหน่งเงา (x, y)
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Container(
                            width: 4,
                            height: 55,
                            decoration: BoxDecoration(
                              color: HexColor('F04E23'),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Text(
                                '${widget.todos[index]['Course_code']}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  '${widget.todos[index]['course_detail']['CourseName']}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: HexColor('F8F8F7'),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${widget.todos[index]['course_detail']['room']}'),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (widget.title == 'Student') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Class_Detail(
                                                attendenceDetail:
                                                    widget.todos[index]),
                                          ));
                                    }
                                  },
                                  child: Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              '${widget.todos[index]['Status']}'),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }

  Widget professorClass() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, height * 0.38, 10, 10),
      width: width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: widget.todos.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            if (widget.todos[index]['recurrence_pattern'] ==
                DateFormat.EEEE().format(currentDateTime)) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.todos[index]['start_time']}'
                              .substring(0, 5),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: HexColor('A9A8A9')),
                        ),
                        Text(
                          '${widget.todos[index]['end_time']}'.substring(0, 5),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: HexColor('A9A8A9')),
                        )
                      ],
                    ),
                  ),
                  if (widget.title != 'Student')
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Container(
                                child: Text('Test'),
                              ),
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // สีของเงา
                              spreadRadius: 5, // รัศมีการกระจายของเงา
                              blurRadius: 7, // ความเบลอของเงา
                              offset: const Offset(0, 3), // ตำแหน่งเงา (x, y)
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Container(
                                width: 4,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: HexColor('F04E23'),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Text(
                                    '${widget.todos[index]['Course_code']}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      '${widget.todos[index]['CourseName']}',
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: HexColor('F8F8F7'),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              '${widget.todos[index]['room']}'),
                                        ),
                                      ),
                                    ),
                                    if (widget.title == 'Student')
                                      GestureDetector(
                                        onTap: () async {
                                          if (widget.title == 'Student') {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Class_Detail(
                                                          attendenceDetail:
                                                              widget.todos[
                                                                  index]),
                                                ));
                                          }
                                        },
                                        child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    '${widget.todos[index]['Status']}'),
                                              ),
                                            )),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }

  Widget noclass() {
    return (const Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Image(
          image: AssetImage(
              'assets/images/Ant_Emoji.png'), // เปลี่ยนเป็นที่อยู่ของรูปภาพที่คุณต้องการแสดง
          width: 250, // กำหนดความกว้างของรูปภาพ
          height: 200, // กำหนดความสูงของรูปภาพ
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = 130;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        topView(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child:
              (widget.title == 'Student') ? studentClass() : professorClass(),
        )
      ],
    ));
  }
}
