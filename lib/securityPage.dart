import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_project/Auth/Change_Pin.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/model/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPage extends StatefulWidget {
  final Map<String, dynamic> profiledata;

  const SecurityPage({super.key, required this.profiledata});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  // Future _RecordVideoFromCamera() async {
  //   final video = await ImagePicker().pickVideo(source: ImageSource.camera);
  //   if (video != null) {
  //     var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(
  //             '${dotenv.env['API_LINK']}/upload/Video/?student_id=${widget.profiledata['StudentID']}'));

  //     // เพิ่มไฟล์วิดีโอเข้าไปใน multipart request
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'video',
  //         video.path,
  //       ),
  //     );
  //     var response = await request.send();
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 42,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'จัดการความปลอดภัย',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[gradiant_2, gradiant_1]),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              gradiant_2,
              gradiant_1
            ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.87,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: const Text('เปลี่ยนรหัส PIN',
                          style: TextStyle(fontSize: 20)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePin(
                                      profiledata: widget.profiledata,
                                    )));
                      },
                    ),
                    const Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      leading: const Icon(Icons.face_3),
                      title: const Text(
                        'เข้าสู่ระบบผ่านใบหน้า',
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        //_RecordVideoFromCamera();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                      profiledata: widget.profiledata,
                                    )));
                      },
                    ),
                    const Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
