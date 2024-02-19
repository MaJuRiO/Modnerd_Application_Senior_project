import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("login with kmutt email"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(255, 74, 20, 1.0),
              Color.fromRGBO(255, 159, 36, 1.0)
            ], // สีเริ่มต้นและสีสุดท้ายของ Gradient
          ),
        ),
        child: Stack(
          children: [
            const Align(alignment: Alignment.topCenter, child: Text("MODLINK")),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 360, 0, 0),
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
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(255, 159, 36, 1.0),
                              Color.fromRGBO(255, 74, 20, 1.0)
                            ]),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: const Text(
                            'เข้าสู่ระบบด้วยใบหน้า',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 44,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(255, 159, 36, 1.0),
                            Color.fromRGBO(255, 74, 20, 1.0)
                          ]),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: const Text(
                          'เข้าสู่ระบบด้วยบัญชี มจธ.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
