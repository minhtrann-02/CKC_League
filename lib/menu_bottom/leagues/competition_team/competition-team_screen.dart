// ignore_for_file: depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CompetitionTeam_Screen extends StatefulWidget {
  const CompetitionTeam_Screen({super.key});

  @override
  State<CompetitionTeam_Screen> createState() => _CompetitionTeam_ScreenState();
}

class _CompetitionTeam_ScreenState extends State<CompetitionTeam_Screen> {
  int? idGiaiDau = 0;
  int so_luong_doi_bong = 0;
  bool isLoading = true;
  String access_token = '';
  List<String> listTenDoiBong = [];
  List<String> listLogoDoiBong = [];
  List<String> listSoThanhVien = [];
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
    await fetchDSDoiBongData();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idGiaiDau = prefs.getInt('id') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong') ?? 0;
    setState(() {
      for (int i = 0; i < so_luong_doi_bong; i++) {
        listLogoDoiBong.add('images/logo3.png');
      }
    });
  }

  Future<void> fetchDSDoiBongData() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final String apiDSDoiBong =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau?giai_dau_id=$idGiaiDau';
    final response = await http.get(Uri.parse(apiDSDoiBong), headers: headers);

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      List<dynamic> results = decodedJson['data'];

      List<int> listIDDoiBong = results
          .where((item) => idGiaiDau == item['giai_dau_id'])
          .map((item) => item['doi_bong_id'] as int)
          .toList();
      listTenDoiBong = await getTenDoiBongList(listIDDoiBong);
      listLogoDoiBong = await getLogoDoiBongList(listIDDoiBong);
      listSoThanhVien = await getSLThanhVienList(listIDDoiBong);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> getTenDoiBongList(List<int> doiBongIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = doiBongIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['ten_doi_bong'].toString();
      }
      return '';
    }).toList();
    return IDDoiBongList;
  }

  Future<List<String>> getLogoDoiBongList(List<int> doiBongIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = doiBongIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['logo'].toString();
      }
      return '';
    }).toList();
    return IDDoiBongList;
  }

  Future<List<String>> getSLThanhVienList(List<int> doiBongIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = doiBongIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['sl_thanh_vien'].toString();
      }
      return '';
    }).toList();
    return IDDoiBongList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          'Đội thi đấu',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Thanh tiêu đề
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#   Đội',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trận',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'T-H-B',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Thành viên',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //Danh sách đội bóng
          Expanded(
            flex: 9,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.green,
                  )) // Widget loading
                : ListView.builder(
                    itemCount: listTenDoiBong.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 60,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}', // Hiển thị số thứ tự tăng dần
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Image.asset(
                                      listLogoDoiBong[index],
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Text(
                                    listTenDoiBong[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  const Text(
                                    '0',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 34),
                                  const Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '0',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16)),
                                        TextSpan(
                                            text: '-0-',
                                            style: TextStyle(fontSize: 16)),
                                        TextSpan(
                                            text: '0',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 48),
                                  Text(
                                    listSoThanhVien[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
