import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentToCourse extends StatefulWidget {
  final String fullname;
  final String studentid;
  final String coursecode;

  const AddStudentToCourse({
    Key? key,
    required this.fullname,
    required this.studentid,
    required this.coursecode,
  }) : super(key: key);

  @override
  State<AddStudentToCourse> createState() => _AddStudentToCourseState();
}

class _AddStudentToCourseState extends State<AddStudentToCourse> {
  Future<void> addStudentToCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      _showDialog('Error', 'Token is missing');
      return;
    }

    Map<String, dynamic> tokenMap = json.decode(token);
    String accessToken = tokenMap['access_token'];
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_LINK']}/Enrollment/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          "StudentID": widget.studentid,
          "Course_code": widget.coursecode,
          "EnrollmentDate": formattedDate,
        }),
      );

      if (response.statusCode == 201) {
        _showDialog('Success', 'นักเรียนได้ลงทะเบียนเรียนวิชานี้สำเร็จ');
      } else if (response.statusCode == 406) {
        _showDialog('Error', 'นักเรียนอยู่ในวิชาเรียนนี้อยู่แล้ว');
      } else {
        _showDialog('Error', 'Unexpected error');
      }
    } catch (e) {
      _showDialog('Error', 'Failed to add student: $e');
    }
  }

  void _showDialog(String title, String content) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
            color: Colors.blue,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('แจ้งเตือน'),
                  content:
                      Text('คุณต้องการเพิ่ม ${widget.fullname} ใช่หรือไม่'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context, 'OK');
                        await addStudentToCourse();
                      },
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
