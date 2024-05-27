import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/main.dart';

class SumarryAttendance extends StatefulWidget {
  final String coursecode;

  const SumarryAttendance({super.key, required this.coursecode});

  @override
  State<SumarryAttendance> createState() => _SumarryAttendanceState();
}

class _SumarryAttendanceState extends State<SumarryAttendance> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Class_report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"course_code": widget.coursecode}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        items = data.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 42,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            'Student Attendance Table',
            style: TextStyle(fontSize: 24, color: Colors.white),
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
        body: items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('StudentID')),
                            DataColumn(label: Text('Not Yet')),
                            DataColumn(label: Text('Present')),
                            DataColumn(label: Text('Leave')),
                            DataColumn(label: Text('Late')),
                          ],
                          rows: items.map((item) {
                            return DataRow(cells: [
                              DataCell(Text(item['StudentID'] ?? '')),
                              DataCell(Text(item['NotYet'].toString())),
                              DataCell(Text(item['Present'].toString())),
                              DataCell(Text(item['Leave'].toString())),
                              DataCell(Text(item['Late'].toString())),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
