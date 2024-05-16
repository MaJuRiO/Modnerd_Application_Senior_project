import 'dart:convert';
import 'package:senior_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/model/checkin_class_cam.dart';
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassDetail extends StatelessWidget {
  ClassDetail(
      {super.key, required this.attendenceDetail, required this.profilesData});

  final Map<String, dynamic> attendenceDetail;
  final Map<String, dynamic> profilesData;

  String formatTimeWithoutSeconds(String time) {
    DateTime timeHMS = DateFormat.Hms().parse(time);
    return DateFormat.Hm().format(timeHMS);
  }

  Future<void> checkinClass(String code, BuildContext context) async {
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
      body: jsonEncode(<String, String>{
        "studentId": "${profilesData['StudentID']}",
        "coursecode": "${attendenceDetail['Course_code']}",
        "code": code
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succes'),
            content: const Text('สำเร็จ'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CheckinClassCam()));
                  //Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
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
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 184, 183, 183),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(attendenceDetail['course_detail']
                        ['recurrence_pattern']),
                  ),
                ), //วัน
                Text(
                  '${formatTimeWithoutSeconds(attendenceDetail['course_detail']['start_time'])}-${formatTimeWithoutSeconds(attendenceDetail['course_detail']['end_time'])}',
                  style: const TextStyle(fontSize: 14),
                ), // เวลาเรียน
                Text(
                  '${attendenceDetail['Course_code']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '${attendenceDetail['course_detail']['CourseName']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('${attendenceDetail['course_detail']['room']}'),
                SizedBox(
                  width: 370,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: HexColor('7AE17C'), // foreground
                    ),
                    onPressed: () {
                      _showTextFieldDialog(context);
                    },
                    child: const Text('เช็คชื่อ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _textController = TextEditingController();

  void _showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Code"),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Enter your Code here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                // Do something with the text entered
                String enteredText = _textController.text;
                checkinClass(enteredText, context);
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
}
