import 'package:flutter/material.dart';

class Change_Pin_Success extends StatelessWidget {
  const Change_Pin_Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 241),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 500,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        'แก้ไขรหัส PIN สำเร็จ',
                        style: TextStyle(fontSize: 30),
                      )),
                      Icon(
                        Icons.lock_reset_rounded,
                        size: 70,
                      )
                    ],
                  )),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                        height: 50,
                        width: 200,
                        child: Center(child: Text('ปิด'))),
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
