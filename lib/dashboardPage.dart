// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/model/ScheduleListView.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/profilePage.dart';

class Dashboard extends StatefulWidget {
  Map<String, dynamic> profilesData;
  Dashboard({Key? key, required this.profilesData}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  late final Map<String, dynamic> profilesData;

  @override
  void initState() {
    super.initState();
    profilesData = widget.profilesData;
    fetchAttendence();
  }

  Future<List<Map<String, dynamic>>> fetchAttendence() async {
    http.Response response = await http.post(
      Uri.parse('${dotenv.env['API_LINK']}/schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"StudentID": "63070507207"}),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromRGBO(255, 74, 20, 1.0),
            Color.fromRGBO(255, 159, 36, 1.0)
          ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
        ),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 0, 0),
          child: ClipOval(
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
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
            '${profilesData['FirstName']} ${profilesData['LastName']}',
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
            child: (profilesData['auth_users']['Roll'] == 'Student')
                ? const Text('ตารางเรียน',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                : const Text('ตารางสอน',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 380, 0, 0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAttendence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Schedule(
                    title: 'My Schedule',
                    todos: snapshot.data!,
                  );
                }
              }),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          height: 65,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          labelBehavior: null,
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: '',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: '',
            ),
          ],
        ),
        body: <Widget>[
          dashboardBody(),
          ProfilePage(profilesData: profilesData)
        ][currentPageIndex]);
  }
}
