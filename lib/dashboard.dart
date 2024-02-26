import 'package:flutter/material.dart';
import 'package:senior_project/model/Schedule.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 74, 20, 1.0),
              Color.fromRGBO(255, 159, 36, 1.0)
            ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
          ),
        ),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 230, 0, 0),
            child: Container(
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 185, 0, 0),
              child: Container(
                width: 360,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // สีของเงา
                      spreadRadius: 5, // รัศมีการกระจายของเงา
                      blurRadius: 7, // ความเบลอของเงา
                      offset: const Offset(0, 3), // ตำแหน่งเงา (x, y)
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 350, 0, 0),
            child: Text(
              "ตารางของฉัน",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 380, 0, 0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // จัดการพื้นที่ให้กับกล่อง
              children: List.generate(7, (index) {
                DateTime date = DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday - 1))
                    .add(Duration(days: index));
                String dayName = DateFormat('E').format(date);
                return GrayButton(text: dayName, date: date);
              }),
            ),
          )
        ]),
      ),
    );
  }
}
