import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/dashboard_page.dart';
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PinAuth extends StatefulWidget {
  const PinAuth({super.key});

  @override
  State<PinAuth> createState() => _PinAuthState();
}

class _PinAuthState extends State<PinAuth> {
  @override
  void initState() {
    super.initState();
    fetchUserData(); // เรียกใช้งานฟังก์ชันเมื่อหน้าถูกโหลด
  }

  bool loginFailed = false;
  Future<void> _login() async {
    String apiUrl = '${dotenv.env['API_LINK']}/login/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode({"pin": enteredPin}),
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Dashboard(
          profiledata: profilesData,
        );
      }));
      setState(() {
        enteredPin = '';
      });
      if (!context.mounted) return;
    } else {
      setState(() {
        enteredPin = '';
      });
    }
  }

  String enteredPin = '';
  Map<String, dynamic> profilesData = {};
  String roll = '';

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // ตรวจสอบว่ามี token หรือไม่
    if (token != null) {
      Map<String, dynamic> tokenMap = json.decode(token);
      String accessToken = tokenMap['access_token'];
      String apiUrl = '${dotenv.env['API_LINK']}/users/me';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        // ดำเนินการกับข้อมูลที่ได้รับ
        setState(() {
          profilesData = jsonDecode(response.body);
          roll = profilesData['auth_users']['Roll'];
        });
      } else {
        // กรณีไม่สามารถเข้าถึงข้อมูลได้
      }
    } else {
      // กรณีไม่พบ token
    }
  }

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
              if (enteredPin.length == 6) {
                _login(); // เมื่อรหัส PIN ครบ 6 ตัวให้ทำการเรียกใช้งาน _login
              }
            }
          });
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
            backgroundColor: Colors.white, // <-- Button color
            foregroundColor: const Color(0x00898989), // <-- Splash color
            side: BorderSide(width: 2, color: HexColor('D9D9D9'))),
        child: Text(
          number.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 32),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const Center(
              child: Text(
                'Enter Your Pin',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Stack(
              children: [
                Center(
                  child: ClipOval(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: (roll == "Student")
                  ? Center(child: Text("${profilesData['StudentID']}"))
                  : Center(
                      child: Text(
                          "${profilesData['FirstName']} ${profilesData['LastName']}")),
            ),

            /// pin code area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: index < enteredPin.length
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.activeBlue.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8.0),

            /// digits
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),

            /// 0 digit with back remove
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(onPressed: null, child: SizedBox()),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          if (enteredPin.isNotEmpty) {
                            enteredPin =
                                enteredPin.substring(0, enteredPin.length - 1);
                          }
                        },
                      );
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            /// reset button
            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
