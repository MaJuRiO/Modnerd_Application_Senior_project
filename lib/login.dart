import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // อ่านค่า username และ password จาก text controller
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // URL ของ API สำหรับการ login
    String apiUrl = 'http://10.0.2.2:8000/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"username": username, "password": password},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      if (response.statusCode == 200) {
        // ถ้า login สำเร็จ ให้ทำการเรียกหน้าอื่นๆ ตามที่ต้องการ
        // หรือทำการเก็บ token และข้อมูลผู้ใช้ไว้
        // ตัวอย่างเช่น Navigator.push(), SharedPreferences เป็นต้น
        print('Login successful');
      } else {
        // กรณี login ไม่สำเร็จ
        print('Login failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> _data = [];
  Future<void> fetchData() async {
    var url2 = "http://10.0.2.2:8000/";
    final response = await http
        .get(Uri.parse(url2))
        .then((response) => print(response.body));
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
