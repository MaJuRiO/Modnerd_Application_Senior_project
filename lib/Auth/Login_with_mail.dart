import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/Auth/Login_with_PIN.dart';
import 'package:senior_project/dashboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MailAuth extends StatefulWidget {
  const MailAuth({super.key});

  @override
  State<MailAuth> createState() => _MailAuthState();
}

class _MailAuthState extends State<MailAuth> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loginFailed = false;

  Future<void> _login() async {
    // อ่านค่า username และ password จาก text controller
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    // URL ของ API สำหรับการ login
    String apiUrl = '${dotenv.env['API_LINK']}/token';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"username": username, "password": password},
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.body);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const PinAuth();
      }));
      if (!context.mounted) return;
    } else {
      setState(() {
        loginFailed = true;
      });
    }
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
            if (loginFailed) // Show text only when login fails
              const Text(
                'Incorrect Email or password',
                style: TextStyle(color: Colors.red),
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
