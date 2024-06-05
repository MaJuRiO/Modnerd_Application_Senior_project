import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/Student/checkin_class_cam.dart';
import 'package:senior_project/model/utils/colors_util.dart';

class ClassDetail extends StatefulWidget {
  ClassDetail(
      {super.key, required this.attendenceDetail, required this.profilesData});

  final Map<String, dynamic> attendenceDetail;
  final Map<String, dynamic> profilesData;

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  final TextEditingController textController = TextEditingController();

  // Function to format time by removing seconds
  String formatTimeWithoutSeconds(String time) {
    DateTime timeHMS = DateFormat.Hms().parse(time);
    return DateFormat.Hm().format(timeHMS);
  }

  Future<void> checkinClass(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/checkclassname'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({
        "studentId": "${widget.profilesData['StudentID']}",
        "coursecode": "${widget.attendenceDetail['Course_code']}",
        "code": code
      }),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('สำเร็จ'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckinClassCam(
                                cameras!,
                                coursecode:
                                    widget.attendenceDetail['Course_code'],
                                date: widget.attendenceDetail['Date'],
                              )),
                    );
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fail'),
              content: const Text('ผิดพลาด'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Function to show dialog for entering class code
  void _showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Code"),
          content: TextField(
            controller: textController,
            decoration:
                const InputDecoration(hintText: "Enter Class Code here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                String enteredText = textController.text;
                checkinClass(enteredText);
                Navigator.of(context).pop();
                textController.clear();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              colors: <Color>[gradiant_2, gradiant_1],
            ),
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
            colors: [gradiant_2, gradiant_1],
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
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(widget.attendenceDetail['course_detail']
                            ['recurrence_pattern']),
                      ),
                    ),
                    if (widget.attendenceDetail['Status'] == "Present")
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor('7AE17C'),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text("Present"),
                        ),
                      ),
                    if (widget.attendenceDetail['Status'] == "Late")
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text("Late"),
                        ),
                      ),
                    if (widget.attendenceDetail['Status'] == "NotYet")
                      Container(
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text("Present"),
                        ),
                      ),
                  ],
                ), // Display recurrence pattern
                Text(
                  '${formatTimeWithoutSeconds(widget.attendenceDetail['course_detail']['start_time'])}-${formatTimeWithoutSeconds(widget.attendenceDetail['course_detail']['end_time'])}',
                  style: const TextStyle(fontSize: 14),
                ), // Display start and end time
                Text(
                  '${widget.attendenceDetail['Course_code']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ), // Display course code
                Text(
                  '${widget.attendenceDetail['course_detail']['CourseName']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ), // Display course name
                Text(
                    '${widget.attendenceDetail['course_detail']['room']}'), // Display room

                SizedBox(
                  width: 370,
                  child: widget.attendenceDetail['Status'] == "NotYet"
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: HexColor('7AE17C'),
                          ),
                          onPressed: () {
                            _showTextFieldDialog(context);
                          },
                          child: const Text('เช็คชื่อ'),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: HexColor('7AE17C'),
                          ),
                          onPressed: null,
                          child: const Text('เช็คชื่อ'),
                        ),
                ), // Check-in button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
