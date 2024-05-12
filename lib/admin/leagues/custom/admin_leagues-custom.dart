// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../admin_leagues-infor.dart';
import 'admin_leagues-edit.dart';
import 'admin_leagues-status.dart';
import 'match-arrangement/match-round-robin.dart';
import 'schedule/admin_schedule-management.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaguesCustom extends StatefulWidget {
  const LeaguesCustom({super.key});

  @override
  State<LeaguesCustom> createState() => _LeaguesCustomState();
}

class _LeaguesCustomState extends State<LeaguesCustom> {
  String tenHinhThuc = '';

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tenHinhThuc = prefs.getString('tenHinhThuc') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget line() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Tùy chỉnh'),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LeaguesInforAdmin_Screen()),
              );
            });
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: ListView(
          children: [
            Container(
              color: Colors.grey[200],
              alignment: Alignment.centerLeft,
              child: const ListTile(
                leading: Text(
                  'CHUNG',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaguesEdit()),
                  );
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero),
              ),
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Cấu hình giải đấu'),
                trailing: Icon(Icons.navigate_next_rounded),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                 setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaguesStatus()),
                  );
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero),
              ),
              child: const ListTile(
                leading: Icon(Icons.error),
                title: Text('Trạng thái'),
                trailing: Icon(Icons.navigate_next_rounded),
              ),
            ),
            Container(
              color: Colors.grey[200],
              alignment: Alignment.centerLeft,
              child: const ListTile(
                leading: Text(
                  'VẬN HÀNH',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchRoundRobin()),
                  );
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero),
              ),
              child: const ListTile(
                leading: Icon(Icons.sports),
                title: Text('Sắp xếp cặp đấu'),
                trailing: Icon(Icons.navigate_next_rounded),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleManagement()),
                  );
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero),
              ),
              child: const ListTile(
                leading: Icon(Icons.calendar_month_outlined),
                title: Text('Quản lý lịch đấu'),
                trailing: Icon(Icons.navigate_next_rounded),
              ),
            ),
            line(),
          ],
        ),
      ),
    );
  }
}
