// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks

import 'dart:convert';

import 'package:ckc_league/admin/leagues/admin_leagues-list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupStage_Screen extends StatefulWidget {
  const GroupStage_Screen({super.key});

  @override
  State<GroupStage_Screen> createState() => _GroupStage_ScreenState();
}

class _GroupStage_ScreenState extends State<GroupStage_Screen> {
  String? selectedValue1 = 'Option 1';
  String? selectedValue2 = 'Option 1';
  String? selectedValue3 = 'Option 1';
  int tongSoTranDau = 7;
  int? soSanh = 1;
  bool error = false;
  String? ten_giai_dau = '';
  String? ban_to_chuc = '';
  String? san_dau = '';
  String? ngay_bat_dau = '';
  String? ngay_ket_thuc = '';
  int? hinh_thuc_dau_id = 0;
  int so_bang_dau = 2;
  int so_doi_vao_vong_trong = 2;
  int loai_san = 5;
  var soLuongDoiBong_Controller = TextEditingController();

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy dữ liệu từ SharedPreferences
    ten_giai_dau = prefs.getString('ten_giai_dau');
    hinh_thuc_dau_id = prefs.getInt('hinh_thuc_dau_id');
    ban_to_chuc = prefs.getString('ban_to_chuc');
    san_dau = prefs.getString('san_dau');
    ngay_bat_dau = prefs.getString('ngay_bat_dau');
    ngay_ket_thuc = prefs.getString('ngay_ket_thuc');
    setState(() {});
  }

  void saveData() async {
    const String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access_token = prefs.getString('accessToken') ?? '';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final body = {
      'ten_giai_dau': ten_giai_dau,
      'hinh_thuc_dau_id': hinh_thuc_dau_id,
      'ban_to_chuc': ban_to_chuc,
      'san_dau': san_dau.toString(),
      'ngay_bat_dau': ngay_bat_dau,
      'ngay_ket_thuc': ngay_ket_thuc,
      'so_luong_doi_bong': int.parse(soLuongDoiBong_Controller.text),
      'so_bang_dau': so_bang_dau,
      'so_doi_vao_vong_trong': so_doi_vao_vong_trong,
      'loai_san': loai_san,
      'so_vong_dau': tongSoTranDau,
      'so_tran_da_dau': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await http.post(Uri.parse(apiGiaiDau),
        body: jsonEncode(body), headers: headers);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Thêm tài khoản thành công');
      if (soLuongDoiBong_Controller.text.isEmpty ||
          int.parse(soLuongDoiBong_Controller.text) < 6 ||
          int.parse(soLuongDoiBong_Controller.text) > 16) {
        setState(() {
          error = true;
        });
      } else if (!error) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeaguesList()),
          );
        });
      }
    } else {
      print('Lỗi: ${response.statusCode}');
      // Xử lý thông báo lỗi cho người dùng
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    soLuongDoiBong_Controller.text = '6';
  }

  int? updatetongSoTranDau() {
    int soDoiThamGia = int.tryParse(soLuongDoiBong_Controller.text) ?? 0;
    // Tính chập tổ hợp của 2
    int factorial(int num) {
      if (num <= 1) {
        return 1;
      }
      return num * factorial(num - 1);
    }

    int tinhChapToHopCua2(int soDoi) {
      return factorial(soDoi) ~/ (factorial(2) * factorial(soDoi - 2));
    }

    // Tính số lượng trận đấu
    int soLuongDoiBongTrong1Bang = soDoiThamGia ~/ so_bang_dau;
    int tiLeDoiBong = soDoiThamGia % so_bang_dau;
    int SoBangDauUp1 = 0;
    for (int i = 1; i <= so_bang_dau; i++) {
      if (tiLeDoiBong > 0 && tiLeDoiBong < so_bang_dau) {
        SoBangDauUp1++;
        tiLeDoiBong--;
      }
    }
    int SLDoiBong1 = so_bang_dau - SoBangDauUp1;
    int SLDoiBong2 = so_bang_dau - SLDoiBong1;
    if (soDoiThamGia % so_bang_dau == 0) {
      tongSoTranDau =
          tinhChapToHopCua2(soLuongDoiBongTrong1Bang) * so_bang_dau +
              (so_doi_vao_vong_trong - 1);
    } else {
      tongSoTranDau =
          (tinhChapToHopCua2(soLuongDoiBongTrong1Bang) * SLDoiBong1) +
              (tinhChapToHopCua2(soLuongDoiBongTrong1Bang + 1) * SLDoiBong2) +
              (so_doi_vao_vong_trong - 1);
    }
    return tongSoTranDau;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey[800],
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Cấu hình'),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tổng số trận đấu',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      '$tongSoTranDau',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: saveData,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Hoàn thành',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ĐỘI THAM GIA',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: soLuongDoiBong_Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Số đội tham gia [6 -> 16]',
                  errorText: error ? 'Vui lòng nhập số đội 6 -> 16' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  int? parsedValue = int.tryParse(value);
                  if (parsedValue != null &&
                      (parsedValue < 6 || parsedValue > 16)) {
                    setState(() {
                      error = true;
                    });
                  } else {
                    setState(() {
                      error = false;
                      updatetongSoTranDau();
                    });
                  }
                },
                onTap: () {
                  if (soLuongDoiBong_Controller.text.isEmpty) {
                    setState(() {
                      error = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Số lượng người trên sân đấu',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue1,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue1 = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Option 1',
                            child: const Text('5 người'),
                            onTap: () {
                              setState(() {
                                loai_san = 5;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 2',
                            child: const Text('7 người'),
                            onTap: () {
                              setState(() {
                                loai_san = 7;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 3',
                            child: const Text('9 người'),
                            onTap: () {
                              setState(() {
                                loai_san = 9;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 4',
                            child: const Text('11 người'),
                            onTap: () {
                              setState(() {
                                loai_san = 11;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Số bảng đấu',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue2,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue2 = newValue!;

                            updatetongSoTranDau();
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Option 1',
                            child: const Text('2 bảng'),
                            onTap: () {
                              setState(() {
                                so_bang_dau = 2;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 2',
                            child: const Text('3 bảng'),
                            onTap: () {
                              setState(() {
                                so_bang_dau = 3;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 3',
                            child: const Text('4 bảng'),
                            onTap: () {
                              setState(() {
                                so_bang_dau = 4;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 4',
                            child: const Text('5 bảng'),
                            onTap: () {
                              setState(() {
                                so_bang_dau = 5;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Số đội vào vòng trong',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue3,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue3 = newValue!;
                            updatetongSoTranDau();
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Option 1',
                            child: const Text('2 đội'),
                            onTap: () {
                              setState(() {
                                so_doi_vao_vong_trong = 2;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 2',
                            child: const Text('4 đội'),
                            onTap: () {
                              setState(() {
                                so_doi_vao_vong_trong = 4;
                              });
                            },
                          ),
                          DropdownMenuItem<String>(
                            value: 'Option 3',
                            child: const Text('8 đội'),
                            onTap: () {
                              setState(() {
                                so_doi_vao_vong_trong = 8;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'CÁCH TÍNH ĐIỂM TRẬN',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Thắng',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                '3',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Hòa',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                '1',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Thua',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                '0',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
