import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:senior_project/Auth/Login_Page.dart';
import 'package:senior_project/Auth/Login_with_PIN.dart';
import 'package:senior_project/model/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<CameraDescription>? cameras;
HexColor gradiant_1 = HexColor('ffc0cb');
HexColor gradiant_2 = HexColor('#800080');
HexColor grey = HexColor('F8F8F8');

Future<bool> isTokenAvailable() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token != null;
}

Future<bool> isTokenExpired() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  if (token != null) {
    Map<String, dynamic> tokenMap = json.decode(token);
    String accessToken = tokenMap['access_token'];
    String apiUrl = '${dotenv.env['API_LINK']}/users/me';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode != 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  } else {
    // กรณีที่ token เป็น null
    return true;
  }
}

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  initializeDateFormatting();

  bool isTokenAvailableResult = await isTokenAvailable();
  bool isTokenExpiredResult = await isTokenExpired();

  Widget initialScreen;

  if (isTokenAvailableResult && !isTokenExpiredResult) {
    initialScreen = const PinAuth();
  } else {
    initialScreen = const LoginScreen();
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({required this.initialScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ModNerd',
      theme: ThemeData(fontFamily: 'Kanit'),
      home: initialScreen,
    );
  }
}
