import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:senior_project/model/utils/colors_util.dart';

class Class_Detail extends StatelessWidget {
  Class_Detail({super.key, required this.attendenceDetail});

  final Map<String, dynamic> attendenceDetail;

  String formatTimeWithoutSeconds(String time) {
    DateTime timeHMS = DateFormat.Hms().parse(time);
    return DateFormat.Hm().format(timeHMS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 42),
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.87,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 184, 183, 183),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(attendenceDetail['course_detail']
                        ['recurrence_pattern']),
                  ),
                ), //วัน
                Text(
                  '${formatTimeWithoutSeconds(attendenceDetail['course_detail']['start_time'])}-${formatTimeWithoutSeconds(attendenceDetail['course_detail']['end_time'])}',
                  style: const TextStyle(fontSize: 14),
                ), // เวลาเรียน
                Text(
                  '${attendenceDetail['Course_code']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '${attendenceDetail['course_detail']['CourseName']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('${attendenceDetail['course_detail']['room']}'),
                SizedBox(
                  width: 370,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: HexColor('7AE17C'), // foreground
                    ),
                    onPressed: () {
                      _showTextFieldDialog(context);
                    },
                    child: const Text('เช็คชื่อ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController _textController = TextEditingController();

  void _showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Code"),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Enter your Code here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                // Do something with the text entered
                String enteredText = _textController.text;
                print("Entered text: $enteredText");
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
