import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GrayButton extends StatelessWidget {
  final String text;
  final DateTime date;

  const GrayButton({Key? key, required this.text, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = date.day == DateTime.now().day;
    Color buttonColor = isToday ? Colors.orange : Colors.grey;
    Color textColor = isToday ? Colors.white : Colors.black;

    return SizedBox(
      width: 45,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          // ทำอะไรสักอย่างเมื่อปุ่มถูกกด
          print('Button for $text pressed');
        },
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 10),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(color: textColor, fontSize: 5),
            ),
          ],
        ),
      ),
    );
  }
}
