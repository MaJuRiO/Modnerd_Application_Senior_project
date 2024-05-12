import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:screenshot/screenshot.dart';
import 'package:senior_project/Auth/Login_with_PIN.dart';

class RecogCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const RecogCameraScreen(this.cameras, {super.key});

  @override
  _RecogCameraScreenState createState() => _RecogCameraScreenState();
}

class _RecogCameraScreenState extends State<RecogCameraScreen> {
  late CameraController controller;
  final screenshotController = ScreenshotController();
  late Timer timer;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
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

  Future<void> sendImage(Uint8List? imageBytes) async {
    // แปลงรูปภาพเป็น base64
    //String base64Image = base64Encode(image!);
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
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        isProcessing = true;
        timer.cancel();
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PinAuth()));
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image. Error: ${response.statusCode}');
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
