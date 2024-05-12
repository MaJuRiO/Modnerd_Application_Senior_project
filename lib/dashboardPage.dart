// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/model/ScheduleListView.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:senior_project/profilePage.dart';

class Dashboard extends StatefulWidget {
  final Map<String, dynamic> profiledata;
  const Dashboard({Key? key, required this.profiledata}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  late final Map<String, dynamic> profilesdata;

  @override
  void initState() {
    super.initState();
    profilesdata = widget.profiledata;
  }

  Future<List<Map<String, dynamic>>> fetchAttendence() async {
    http.Response response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"StudentID": "${profilesdata['StudentID']}"}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> attendence = jsonDecode(response.body);
      return attendence.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchprofessorClass() async {
    http.Response response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/Subjects_taught'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"Professor_name": "${profilesdata['FirstName']}"}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> attendence = jsonDecode(response.body);
      return attendence.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  Widget dashboardBody() {
    return Container(
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
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 0, 0),
          child: ClipOval(
              child: (profilesdata['auth_users']['Roll'] == "Student")
                  ? Image.network(
                      '${dotenv.env['Image_API']}/${profilesdata['StudentID']}/${profilesdata['StudentID']}_imageprofile',
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      );
                    })
                  : Image.network(
                      '${dotenv.env['Image_API']}/${profilesdata['id']}/${profilesdata['id']}_imageprofile',
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      );
                    })),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(300, 80, 0, 0),
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.blue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.circle_notifications_outlined),
              iconSize: 48,
              onPressed: () {
                // ทำอะไรสักอย่างเมื่อปุ่มถูกกด
                print('Button pressed');
              },
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(90, 100, 0, 0),
          child: Text(
            '${profilesdata['FirstName']} ${profilesdata['LastName']}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 230, 0, 0),
          child: Container(
            width: double.infinity,
            color: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 185, 0, 0),
            child: Container(
              width: 360,
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
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 350, 0, 0),
            child: (profilesdata['auth_users']['Roll'] == 'Student')
                ? const Text('ตารางเรียน',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                : const Text('ตารางสอน',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 380, 0, 0),
          child: (profilesdata['auth_users']['Roll'] == 'Student')
              ? FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAttendence(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Schedule(
                        title: '${profilesdata['auth_users']['Roll']}',
                        todos: snapshot.data!,
                        profilesData: profilesdata,
                      );
                    }
                  })
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchprofessorClass(),
                  builder: (context, snapshot) {
                    print(profilesdata['auth_users']['Roll']);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Schedule(
                        title: '${profilesdata['auth_users']['Roll']}',
                        todos: snapshot.data!,
                        profilesData: profilesdata,
                      );
                    }
                  }),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // แสดง popup
        bool exit = await showDialog(
          context: context,
          builder: (context) => const ExitConfirmationDialog(),
        );
        // คืนค่า true หากต้องการออก และ false หากต้องการยกเลิก
        return exit;
      },
      child: Scaffold(
          bottomNavigationBar: NavigationBar(
            height: 65,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: HexColor('874CCC'),
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.person_2,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.person_2,
                ),
                label: '',
              ),
            ],
          ),
          body: <Widget>[
            dashboardBody(),
            ProfilePage(profilesData: profilesdata)
          ][currentPageIndex]),
    );
  }
}

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('คุณแน่ใจหรือไม่?'),
      content: const Text('คุณต้องการออกจากแอปพลิเคชันหรือไม่?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ไม่'),
        ),
        ElevatedButton(
          onPressed: () {
            exit(0);
          },
          child: const Text('ใช่'),
        ),
      ],
    );
  }
}
