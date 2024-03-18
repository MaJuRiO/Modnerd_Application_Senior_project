// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senior_project/model/ScheduleListView.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/profilePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> profilesData = {};
  int currentPageIndex = 0;

  List<Map<String, dynamic>>? attendences;
  @override
  void initState() {
    super.initState();
    fetchUserData(); // เรียกใช้งานฟังก์ชันเมื่อหน้าถูกโหลด
    fetchAttendence();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // ตรวจสอบว่ามี token หรือไม่
    if (token != null) {
      Map<String, dynamic> tokenMap = json.decode(token);
      String accessToken = tokenMap['access_token'];
      String apiUrl = 'http://10.0.2.2:8000/users/me';
      try {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {'Authorization': 'Bearer $accessToken'},
        );
        if (response.statusCode == 200) {
          // ดำเนินการกับข้อมูลที่ได้รับ
          prefs.setString('profile_data', response.body);
          Map<String, dynamic> responseData = jsonDecode(response.body);
          String emailValue = responseData['Email'];
          var profile = await http.get(
            Uri.parse('http://10.0.2.2:8000/users/$emailValue'),
          );
          if (profile.statusCode == 200) {
            setState(() {
              profilesData = jsonDecode(profile.body);
            });
          }
        } else {
          // กรณีไม่สามารถเข้าถึงข้อมูลได้
          print('Failed to fetch user data');
        }
      } catch (e) {
        // กรณีเกิดข้อผิดพลาดในการเรียก API
        print('Error: $e');
      }
    } else {
      // กรณีไม่พบ token
      print('Token not found');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendence() async {
    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8000/attendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"StudentID": "63070507207"}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> attendence = jsonDecode(response.body);
      return attendence.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load attendances from API');
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
            '${profilesData?['FirstName']} ${profilesData?['LastName']}',
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
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 350, 0, 0),
          child: Text(
            "ตารางของฉัน",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
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
