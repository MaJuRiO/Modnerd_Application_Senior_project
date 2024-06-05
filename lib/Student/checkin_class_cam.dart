import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckinClassCam extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String coursecode;
  final String date;
  const CheckinClassCam(this.cameras,
      {super.key, required this.coursecode, required this.date});

  @override
  State<CheckinClassCam> createState() => _CheckinClassCamState();
}

class _CheckinClassCamState extends State<CheckinClassCam> {
  late CameraController controller;
  final screenshotController = ScreenshotController();
  late Timer timer;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    final firstCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(firstCamera, ResolutionPreset.max);
    controller.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        if (controller.value.isInitialized && !isProcessing) {
          timer = Timer.periodic(
            const Duration(seconds: 2),
            (Timer t) async {
              try {
                screenshotController
                    .capture()
                    .then((Uint8List? image) => {sendImage(image)});
              } finally {
                isProcessing = false;
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  Future<void> sendImage(Uint8List? imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final request = http.MultipartRequest(
        'POST', Uri.parse('${dotenv.env['API_LINK']}/Face_checkin'));
    // ส่งรูปภาพผ่าน API
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes!,
        filename: 'image.jpg',
      ),
    );
    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });
    var response = await request.send();
    if (response.statusCode == 200) {
      updateAttendence(widget.coursecode, widget.date);
      setState(() {
        isProcessing = true;
        timer.cancel();
      });
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {}
  }

  Future<void> updateAttendence(String courseCode, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> tokenMap = json.decode(token!);
    String accessToken = tokenMap['access_token'];
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_LINK']}/attendance_checkin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({
        "Course_code": courseCode,
        "Date": date,
      }),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ยืนยันตัวตนสำหรับเข้าเรียน'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>
                {Navigator.of(context).pop(), Navigator.of(context).pop()},
          ),
        ),
        body: Center(
          child: SizedBox(
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }
}
