import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_project/main.dart';
import 'package:http/http.dart' as http;

class ProfileDetail extends StatelessWidget {
  final Map<String, dynamic> profiledata;

  const ProfileDetail({super.key, required this.profiledata});

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, imageQuality: 100);

    if (pickedFile != null) {
      String id;
      if (profiledata['auth_users']['Roll'] == "Student") {
        id = profiledata['StudentID'];
      } else if (profiledata['auth_users']['Roll'] == "Teacher") {
        id = profiledata['id'];
      } else {
        throw Exception('Roll is not defined');
      }
      // Upload the image through API
      await _uploadImage(pickedFile.path, id);
    }
  }

  Future<void> _uploadImage(String imagePath, String id) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${dotenv.env['API_LINK']}/upload/image/?Id=$id'));

    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      // Do something after image uploaded successfully
    } else {
      print('Failed to upload image');
      // Do something if image upload fails
    }
  }

  void _showSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title: Text(
                    'เปลี่ยนรูปโปรไฟล์',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('เลือกรูปจากคลัง'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('ถ่ายรูป'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[gradiant_2, gradiant_1]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ข้อมูลของฉัน',
                                style: TextStyle(fontSize: 32),
                              ),
                              Text(
                                'รายละเอียดข้อมูล',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: ClipOval(
                                child: (profiledata['auth_users']['Roll'] ==
                                        "Student")
                                    ? Image.network(
                                        '${dotenv.env['Image_API']}/${profiledata['StudentID']}/${profiledata['StudentID']}_imageprofile',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      })
                                    : Image.network(
                                        '${dotenv.env['Image_API']}/${profiledata['id']}/${profiledata['id']}_imageprofile',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      })),
                            onTap: () {
                              _showSelectionDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      color: grey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (profiledata['StudentID'] == "Student")
                              Text(
                                profiledata['StudentID'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${profiledata['FirstName']} ${profiledata['LastName']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (profiledata['StudentID'] == "Student")
                              Text(
                                profiledata['FacultyName'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (profiledata['StudentID'] == "Student")
                              Text(
                                profiledata['Department'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(
                              height: 0,
                              indent: 10,
                              endIndent: 10,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (profiledata['StudentID'] == "Student")
                              Text(
                                'นักศีกษาชั้นปี ${profiledata['Year']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (profiledata['StudentID'] == "Student")
                              if (profiledata['Degree'] == 'Bachelor')
                                const Text('ระดับปริญญาตรี',
                                    style: TextStyle(fontSize: 16)),
                            if (profiledata['StudentID'] == "Student")
                              if (profiledata['Degree'] == 'Master')
                                const Text('ระดับปริญญาโท',
                                    style: TextStyle(fontSize: 16)),
                            if (profiledata['StudentID'] == "Student")
                              if (profiledata['Degree'] == 'PhD')
                                const Text('ระดับปริญญาเอก',
                                    style: TextStyle(fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ข้อมูลติดต่อ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.mail_outline),
                                    SizedBox(width: 5),
                                    Text(
                                      'อีเมล',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  profiledata['Email'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
