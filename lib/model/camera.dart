import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// CameraApp is the Main Application.
class CameraScreen extends StatefulWidget {
  /// Default Constructor
  final Map<String, dynamic> profiledata;
  const CameraScreen({super.key, required this.profiledata});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  XFile? videoFile;
  bool left_arrow = false;
  bool right_arrow = false;

  Future<void> initializationCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    var cameras = await availableCameras();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializationCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException {
      return;
    }
  }

  Future<void> _uploadVideo(String path) async {
    final File file = File(path);
    final String newFileName = '${widget.profiledata['StudentID']}_face.mp4';
    final String newPath = '${file.parent.path}/$newFileName';

    try {
      // Rename the file
      await file.rename(newPath);

      // Upload the renamed file
      Uri uri = Uri.parse(
          '${dotenv.env['API_LINK']}/upload/Video/?student_id=${widget.profiledata['StudentID']}');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('video', newPath));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video');
      }
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException {
      return null;
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        _uploadVideo(file.path);
        videoFile = file;
      }
    });
  }

  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: () async {
            cameraController != null &&
                    cameraController.value.isInitialized &&
                    !cameraController.value.isRecordingVideo
                ? onVideoRecordButtonPressed
                : null;
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return Container();
    if (controller?.value.isInitialized == false) return Container();
    return Scaffold(
      appBar: AppBar(
        title: const Text('สแกนใบหน้า'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: CameraPreview(controller!),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                'assets/images/Face-Overlay.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (left_arrow)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 500, 0, 0),
              child: Center(child: Image.asset('assets/images/left_arrow.png')),
            ),
          if (right_arrow)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 500, 0, 0),
              child:
                  Center(child: Image.asset('assets/images/right_arrow.png')),
            )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          // onPressed: !controller!.value.isRecordingVideo
          //     ? onVideoRecordButtonPressed
          //     : onStopButtonPressed,
          onPressed: () async {
            onVideoRecordButtonPressed();
            await Future.delayed(const Duration(seconds: 5));
            setState(() {
              left_arrow = true;
            });
            await Future.delayed(const Duration(seconds: 5));
            setState(() {
              left_arrow = false;
              right_arrow = true;
            });
            await Future.delayed(const Duration(seconds: 5));
            setState(() {
              right_arrow = false;
            });
            onStopButtonPressed();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('บันทึกเรียบร้อย'),
                  content: const Text(
                      'ทำการบันทึกใบหน้าที่ไม่สวมใส่หน้ากากอนามัยเรียบร้อย'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('ok'),
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(
            controller!.value.isRecordingVideo ? Icons.stop : Icons.videocam,
          ),
        ),
      ),
    );
  }
}
