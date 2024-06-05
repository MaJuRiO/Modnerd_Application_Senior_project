import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:senior_project/Auth/Login_with_PIN.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecogCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const RecogCameraScreen(this.cameras, {super.key});

  @override
  State<RecogCameraScreen> createState() => _RecogCameraScreenState();
}

class _RecogCameraScreenState extends State<RecogCameraScreen> {
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
    controller =
        CameraController(firstCamera, ResolutionPreset.max, enableAudio: false);
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
                    .then((Uint8List? image) => {faceSignIn(image)});
              } catch (e) {
                print('Error sending image: $e');
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

  Future<void> faceSignIn(Uint8List? imageBytes) async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    // แปลงรูปภาพเป็น base64
    final request = http.MultipartRequest(
        'POST', Uri.parse('${dotenv.env['API_LINK']}/face_rocognition_login'));
    // ส่งรูปภาพผ่าน API
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes!,
        filename: 'image.jpg',
      ),
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        isProcessing = true;
        timer.cancel();
      });
      await prefrences.remove("token");
      prefrences.setString('token', response.body);
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const PinAuth()));
      }
    } else {
      timer.cancel();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('เกิดข้อผิดพลาด'),
            content: const Text('ไม่สามารถพบข้อมูลใบหน้า'),
            actions: [
              TextButton(
                onPressed: () =>
                    {Navigator.pop(context), Navigator.pop(context)},
                child: const Text('ปิด'),
              ),
            ],
          ),
        );
      }
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
          title: const Text('เข้าสู่ระบบด้วยใบหน้า'),
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
