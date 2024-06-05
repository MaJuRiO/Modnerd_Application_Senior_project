import 'package:flutter/material.dart';
import 'package:senior_project/Auth/login_with_mail.dart';
import 'package:senior_project/main.dart';
import 'package:senior_project/Auth/login_with_face.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.topCenter,
              colors: [
                gradiant_1,
                gradiant_2,
              ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
            ),
          ),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "MODNERD",
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 420, 0, 0),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 110, 0, 10),
                        child: Text(
                          "มาเริ่มกันเลย",
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Container(
                          width: 300,
                          height: 44,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                gradiant_1,
                                gradiant_2,
                              ]),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecogCameraScreen(cameras!)));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: const Text(
                              'เข้าสู่ระบบด้วยใบหน้า',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 44,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              gradiant_1,
                              gradiant_2,
                            ]),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MailAuth();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: const Text(
                            'เข้าสู่ระบบด้วย Email',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 220, 0, 0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/ant_v5.png'), // เปลี่ยนเป็นที่อยู่ของรูปภาพที่คุณต้องการแสดง
                    width: 480 / 2, // กำหนดความกว้างของรูปภาพ
                    height: 560 / 2, // กำหนดความสูงของรูปภาพ
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
