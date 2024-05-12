// ignore_for_file: avoid_print, non_constant_identifier_names, depend_on_referenced_packages, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../admin_leagues-list.dart';

class LeaguesStatus extends StatefulWidget {
  const LeaguesStatus({super.key});

  @override
  State<LeaguesStatus> createState() => _LeaguesStatusState();
}

class _LeaguesStatusState extends State<LeaguesStatus> {
  String access_token = '';
  int id = 0;
  int so_tran_da_dau = 0;
  int so_vong_dau = 0;
  final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    id = prefs.getInt('id') ?? 0;
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(apiGiaiDau), headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> results = jsonData['data'];
      String soTranDaDau = results
          .where((item) => id == item['id'])
          .map((item) => item['so_tran_da_dau'])
          .toList()
          .join();
      String soVongDau = results
          .where((item) => id == item['id'])
          .map((item) => item['so_vong_dau'])
          .toList()
          .join();

      setState(() {
        so_tran_da_dau = int.parse(soTranDaDau);
        so_vong_dau = int.parse(soVongDau);
      });
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<void> deleteData(int id) async {
    final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau/$id';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.delete(Uri.parse(apiGiaiDau), headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LeaguesList()),
          (Route<dynamic> route) => false,
        );
      });
      print('Xóa giải đấu thành công! ${response.statusCode}');
    } else {
      print('Xóa giải đấu không thành công! ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xF8001F4E),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Trạng thái giải đấu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trạng thái hiện tại:',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              tinhTrangGiaiDau(so_tran_da_dau, so_vong_dau),
            ],
          ),
          const SizedBox(height: 50),
          FractionallySizedBox(
            widthFactor: 0.99,
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Bạn có muốn xóa giải đấu không?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    deleteData(id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Có',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Không',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red.shade50),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
                child: const Text(
                  'XÓA GIẢI ĐẤU',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget tinhTrangGiaiDau(int a, int b) {
    return Container(
      height: 40,
      width: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (a == 0)
            ? Colors.blue[50]
            : (a < b)
                ? Colors.green[50]
                : Colors.red[50],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: (a == 0)
              ? Colors.blue
              : (a < b)
                  ? Colors.green
                  : Colors.red,
          width: 2,
        ),
      ),
      child: Text(
        (a == 0)
            ? 'Đang đăng ký'
            : (a < b)
                ? 'Hoạt động'
                : 'Kết thúc',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: (a == 0)
              ? Colors.blue
              : (a < b)
                  ? Colors.green
                  : Colors.red,
        ),
      ),
    );
  }
}
