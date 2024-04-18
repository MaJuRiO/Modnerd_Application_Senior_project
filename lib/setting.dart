import 'package:flutter/material.dart';
import 'package:senior_project/securityPage.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.66,
      // สร้าง UI ของหน้าต่างการตั้งค่า
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: Text(
              'ตั้งค่า',
              style: TextStyle(fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('จัดการความปลอดภัย'),
            onTap: () {
              // ทำสิ่งที่ต้องการเมื่อตัวเลือกถูกเลือก
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SecurityPage();
              })); // ปิดหน้าต่างการตั้งค่า
            },
          ),
          const Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('เปลี่ยนภาษา'),
            onTap: () {
              // ทำสิ่งที่ต้องการเมื่อตัวเลือกถูกเลือก
              Navigator.pop(context); // ปิดหน้าต่างการตั้งค่า
            },
          ),
          const Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(Icons.edit_document),
            title: const Text('ข้อกำหนดและเงื่อนไข'),
            onTap: () {
              // ทำสิ่งที่ต้องการเมื่อตัวเลือกถูกเลือก
              Navigator.pop(context); // ปิดหน้าต่างการตั้งค่า
            },
          ),
          const Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('ออกจากระบบ'),
            onTap: () {
              // ทำสิ่งที่ต้องการเมื่อตัวเลือกถูกเลือก
              Navigator.pop(context); // ปิดหน้าต่างการตั้งค่า
            },
          ),
          const Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
          ),
          // เพิ่มตัวเลือกการตั้งค่าเพิ่มเติมตามต้องการ
        ],
      ),
    );
  }
}
