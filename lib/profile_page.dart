import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/Teacher/list_course.dart';
import 'package:senior_project/editprofile.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/setting.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> profilesData;
  const ProfilePage({Key? key, required this.profilesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[gradiant_2, gradiant_1]),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'ประวัติของฉัน',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingsScreen(
                      profiledata: profilesData,
                    ); // แสดงหน้าต่างการตั้งค่า
                  },
                );
              },
              icon: const Icon(Icons.settings_outlined,
                  color: Colors.white, size: 42))
        ],
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
            Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profilesData['StudentID']}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                        '${profilesData['FirstName']} ${profilesData['LastName']}',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height * 0.6,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: Column(
                  children: [
                    if (profilesData['auth_users']['Roll'] == "Student")
                      SizedBox(
                        height: 120,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                                width: width / 2 - 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.hail_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        title: Text(
                                          'ระดับการศึกษา',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'นักศีกษาชั้นปี ${profilesData['Year']}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          if (profilesData['Degree'] ==
                                              'Bachelor')
                                            const Text('ระดับปริญญาตรี',
                                                style: TextStyle(fontSize: 16)),
                                          if (profilesData['Degree'] ==
                                              'Master')
                                            const Text('ระดับปริญญาโท',
                                                style: TextStyle(fontSize: 16)),
                                          if (profilesData['Degree'] == 'PhD')
                                            const Text('ระดับปริญญาเอก',
                                                style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            const VerticalDivider(
                              width: 10,
                              thickness: 1,
                              indent: 20,
                              endIndent: 0,
                              color: Colors.grey,
                            ),
                            SizedBox(
                                width: width / 2 - 5,
                                height: 150,
                                child: const Center(
                                    child: ListTile(
                                  leading: Icon(Icons.mail_outline),
                                  title: Text('@kmutt.ac.th'),
                                  // subtitle: Text(
                                  //     '${profilesData['Email'].substring(0, profilesData['Email'].indexOf('@'))}'),
                                )))
                          ],
                        ),
                      ),
                    profilesData['auth_users']['Roll'] != "Student"
                        ? SizedBox(
                            height: height * 0.6,
                            child: CourseList(
                              profiledata: profilesData,
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 25, height * 0.6 - 50),
                child: GestureDetector(
                  child: ClipOval(
                      child: (profilesData['auth_users']['Roll'] == "Student")
                          ? Image.network(
                              '${dotenv.env['Image_API']}/${profilesData['StudentID']}/${profilesData['StudentID']}_imageprofile',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            })
                          : Image.network(
                              '${dotenv.env['Image_API']}/${profilesData['id']}/${profilesData['id']}_imageprofile',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/Profile.png', // รูปภาพที่ต้องการแสดงเมื่อเกิด error
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            })),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileDetail(
                                  profiledata: profilesData,
                                )));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
