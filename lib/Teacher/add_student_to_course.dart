import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:senior_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentToCourse extends StatefulWidget {
  final String fullname;
  final String studentid;
  final String coursecode;
  const AddStudentToCourse(
      {super.key,
      required this.fullname,
      required this.studentid,
      required this.coursecode});

  @override
  State<AddStudentToCourse> createState() => _AddStudentToCourseState();
}

class _AddStudentToCourseState extends State<AddStudentToCourse> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> addStudenttoCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Enrollment/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, String>{
        "StudentID": widget.studentid,
        "Course_code": widget.coursecode,
        "EnrollmentDate": formattedDate
      }),
    );

    if (response.statusCode == 201) {
      setState(() {});
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('นักเรียนได้ลงทะเบียนเรียนวิชานี้สำเร็จ'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 406) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: const Text('นักเรียนอยู่ในวิชาเรียนนี้อยู่แล้ว'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.fullname,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            'StudentID: ${widget.studentid}',
            style: const TextStyle(color: Colors.black87),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add_box),
            color: gradiant_2,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          {addStudenttoCourse(), Navigator.pop(context, 'OK')},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(
          height: 0,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
