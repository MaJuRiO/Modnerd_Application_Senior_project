import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:senior_project/model/utils/indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClassSummary extends StatefulWidget {
  const ClassSummary(
      {super.key, required this.classdetail, required this.date});
  final Map<String, dynamic> classdetail;
  final String date;
  @override
  State<ClassSummary> createState() => _ClassSummaryState();
}

class _ClassSummaryState extends State<ClassSummary> {
  int touchedIndex = -1;
  String _data = '';
  List<dynamic> studentsList = [];
  Map<String, dynamic>? status;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Course/detail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "course_code": "${widget.classdetail['Course_code']}",
        "date": widget.date
      }),
    );

    if (response.statusCode == 200) {
      String rawdata = response.body.toString();
      Map<String, dynamic> rawdata2 = json.decode(rawdata);
      setState(() {
        studentsList = rawdata2['Students'];
        status = rawdata2['status'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchCourseCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Get_course_code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, String>{
        "Course_code": "${widget.classdetail['Course_code']}",
        "Date": widget.date
      }),
    );

    if (response.statusCode == 200) {
      // ดึงข้อมูล JSON จาก response
      String data = json.decode(response.body);
      setState(() {
        _data = data;
      });
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลได้');
    }
  }

  Future<void> updateCorseCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_LINK']}/update_course_code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, String>{
        "Course_code": "${widget.classdetail['Course_code']}",
        "Date": widget.date
      }),
    );
    if (response.statusCode == 201) {
      // ดึงข้อมูล JSON จาก response
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _data = data['Course_code'];
      });
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลได้');
    }
  }

  String formatTimeWithoutSeconds(String time) {
    DateTime timeHMS = DateFormat.Hms().parse(time);
    return DateFormat.Hm().format(timeHMS);
  }

  double calculatePercentage(int current) {
    if (studentsList.isEmpty) {
      return 0.0; // ป้องกันการหารด้วยศูนย์
    }
    return (current / studentsList.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    print(studentsList.length);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 42),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[gradiant_2, gradiant_1]),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              gradiant_2,
              gradiant_1
            ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.87,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 184, 183, 183),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(widget.classdetail['recurrence_pattern']),
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        await fetchCourseCode().then((value) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Course Code',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                content: SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      _data,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('ปิด'),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      updateCorseCode();
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400]),
                      child: const Text(
                        'GEN CODE',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                Text(
                  '${formatTimeWithoutSeconds(widget.classdetail['start_time'])}-${formatTimeWithoutSeconds(widget.classdetail['end_time'])}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(widget.classdetail['CourseName']),
                Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 235, 232, 232),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(widget.classdetail['room']),
                    )),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Indicator(
                            color: HexColor('1D4E89'),
                            text: 'Present',
                            isSquare: true,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: HexColor('00B2CA'),
                            text: 'notyet',
                            isSquare: true,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: HexColor('7DCFB6'),
                            text: 'Absent',
                            isSquare: true,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: HexColor('FBD1A2'),
                            text: 'Leave',
                            isSquare: true,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: HexColor('F79256'),
                            text: 'Late',
                            isSquare: true,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('StudentID')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: studentsList
                            .map((e) => DataRow(cells: [
                                  DataCell(Text(e["student"]['FirstName'] +
                                      " " +
                                      e["student"]['LastName'])),
                                  DataCell(Text(e['StudentID'])),
                                  DataCell(Text(e['Status']))
                                ]))
                            .toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    if (status == null) {
      return List.generate(4, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.blue,
              value: 40,
              title: '40%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.yellow,
              value: 30,
              title: '30%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: Colors.purple,
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: Colors.green,
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      });
    } else {
      return List.generate(5, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: HexColor('1D4E89'),
              value: status!["Present"].toDouble(),
              title: '${calculatePercentage(status!["Present"])}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: HexColor('00B2CA'),
              value: status!["notyet"].toDouble(),
              title: '${calculatePercentage(status!["notyet"])}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: HexColor('7DCFB6'),
              value: status!["Absent"].toDouble(),
              title: '${calculatePercentage(status!["Absent"])}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: HexColor('FBD1A2'),
              value: status!["Leave"].toDouble(),
              title: '${calculatePercentage(status!["Leave"])}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 4:
            return PieChartSectionData(
              color: HexColor('F79256'),
              value: status!["Late"].toDouble(),
              title: '${status!["Late"]}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      });
    }
  }
}
