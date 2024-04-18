import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_project/model/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  Future _RecordVideoFromCamera() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileData = prefs.getString('profile_data');
    Map<String, dynamic> responseData = jsonDecode(profileData!);
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (video != null) {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${dotenv.env['API_LINK']}/upload/Video/?student_id=${responseData['StudentID']}'));

      // เพิ่มไฟล์วิดีโอเข้าไปใน multipart request
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          video.path,
        ),
      );
      var response = await request.send();
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color.fromRGBO(255, 74, 20, 1.0),
                  Color.fromRGBO(255, 159, 36, 1.0)
                ]),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(255, 74, 20, 1.0),
              Color.fromRGBO(255, 159, 36, 1.0)
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
                    const ListTile(
                      leading: Icon(Icons.security),
                      title: Text('เปลี่ยนรหัส PIN',
                          style: TextStyle(fontSize: 20)),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen()));
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
