import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:senior_project/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> profilesData;
  const ProfilePage({Key? key, required this.profilesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        centerTitle: true,
        title: const Text(
          'ประวัติของฉัน',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingsScreen(); // แสดงหน้าต่างการตั้งค่า
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
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profilesData['StudentID']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(290, height * 0.165, 0, 0),
                child: GestureDetector(
                  child: ClipOval(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          )),
    );
  }
}
