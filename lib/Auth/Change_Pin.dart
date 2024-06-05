import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/model/change_pin_success.dart';
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePin extends StatefulWidget {
  final Map<String, dynamic> profiledata;

  const ChangePin({super.key, required this.profiledata});

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  String enteredPin = '';
  String newPin1 = 'newpin1';
  String newPin2 = 'newpin2';
  bool verified = false;
  bool step1 = false;
  @override
  void initState() {
    super.initState();
    verified =
        false; // กำหนดค่าเริ่มต้นให้เป็น false ทุกครั้งที่มีการเข้ามายังหน้านี้ใหม่
  }

  Future<void> verifypin(String enteredPin, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // ตรวจสอบว่ามี token หรือไม่
    if (token != null) {
      Map<String, dynamic> tokenMap = json.decode(token);
      String accessToken = tokenMap['access_token'];
      String apiUrl = '${dotenv.env['API_LINK']}/verifyPIN';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{"pin": enteredPin, "Email": email}),
      );
      if (response.statusCode == 200) {
        setState(() {
          verified = true;
        });
      } else {
        setState(() {
          verified = false;
        });
      }
    } else {}
  }

  Future<void> changepin(String enteredPin, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // ตรวจสอบว่ามี token หรือไม่
    if (token != null) {
      Map<String, dynamic> tokenMap = json.decode(token);
      String accessToken = tokenMap['access_token'];
      String apiUrl = '${dotenv.env['API_LINK']}/users/changepin';
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{"pin": enteredPin, "Email": email}),
      );
      if (response.statusCode == 202) {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ChangePinSuccess();
          }));
        }
      } else {}
    } else {}
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
              if (enteredPin.length == 6 && !verified) {
                verifypin(enteredPin, widget.profiledata['Email']);
                enteredPin = '';
              }
              if (enteredPin.length == 6 && verified && newPin1.length != 6) {
                newPin1 = enteredPin;
                enteredPin = '';
                newPin2 = '';
                step1 = true;
              }
              if (enteredPin.length == 6 && verified && step1) {
                newPin2 = enteredPin;
                enteredPin = '';
              }
              if (newPin1 == newPin2 && verified) {
                changepin(newPin2, widget.profiledata['Email']);
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
            Container(
              height: 80,
            ),
            if (verified && !step1)
              const Center(
                child: Column(
                  children: [
                    Text(
                      'กำหนดรหัส PIN ใหม่',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'กรอกรหัสผ่านใหม่ที่ต้องการ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 179, 179, 179),
                      ),
                    )
                  ],
                ),
              )
            else if (!verified)
              const Center(
                child: Column(
                  children: [
                    Text(
                      'ระบุรหัส PIN ปัจจุบัน',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'กรอกรหัสผ่านปัจจุบัน',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 179, 179, 179),
                      ),
                    )
                  ],
                ),
              )
            else if (verified && step1)
              const Center(
                child: Text(
                  'ยืนยันรหัส PIN ใหม่',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "ยกเลิก",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
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
