import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> profilesData;
  const ProfilePage({Key? key, required this.profilesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
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
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: const Text(
                'ประวัติของฉัน',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profilesData['StudentID']}',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(
                        '${profilesData['FirstName']} ${profilesData['LastName']}',
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'Roboto',
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
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(290, height * 0.26, 0, 0),
              child: ClipOval(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }
}
