import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/Teacher/Summary_attendance.dart';
import 'package:senior_project/main.dart';

class CourseList extends StatefulWidget {
  final Map<String, dynamic> profiledata;

  const CourseList({
    super.key,
    required this.profiledata,
  });

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  void initState() {
    super.initState();
    fetchCourse();
  }

  List<Map<String, dynamic>> course = [];
  Future<void> fetchCourse() async {
    http.Response response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Subjects_taught'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode({"Professor_name": "${widget.profiledata['FirstName']}"}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        course = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          itemCount: course.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> item = course[index];
            return Container(
              color: grey,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.menu_book_rounded),
                    title: Text(item['Course_code'] ?? ''),
                    subtitle: Text(item['CourseName'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SumarryAttendance(
                              coursecode: item['Course_code'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 0,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
