// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_leagues-custom.dart';

class LeaguesEdit extends StatefulWidget {
  const LeaguesEdit({super.key});

  @override
  State<LeaguesEdit> createState() => _LeaguesEditState();
}

class _LeaguesEditState extends State<LeaguesEdit> {
  bool error1 = false;
  bool error2 = false;
  bool error3 = false;
  bool error4 = false;
  bool error5 = false;
  String? selectedHinhThuc = '';
  String? selectedBangDau = '';
  String? selectedVongTrong = '';
  String? selectedLoaiSan = '';
  int soDoiVaoVongTrong = 0;
  int soBangDau = 0;
  int tongSoTranDau = 0;
  bool error = false;
  bool _isChecked = false;
  String? ten_giai_dau = '';
  String? tenHinhThuc = '';
  String? ban_to_chuc = '';
  String? san_dau = '';
  int? so_vong_dau = 0;
  int? so_tran_da_dau = 0;
  int? so_luong_doi_bong = 0;
  String? ngay_bat_dau = '';
  String? ngay_ket_thuc = '';
  int? so_bang_dau = 0;
  int? so_doi_vao_vong_trong = 0;
  int? loai_san = 0;
  int? hinh_thuc_dau_id = 0;
  int? id = 0;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy dữ liệu từ SharedPreferences
    ten_giai_dau = prefs.getString('ten_giai_dau');
    tenHinhThuc = prefs.getString('tenHinhThuc');
    ban_to_chuc = prefs.getString('ban_to_chuc');
    san_dau = prefs.getString('san_dau');
    so_vong_dau = prefs.getInt('so_vong_dau');
    so_tran_da_dau = prefs.getInt('so_tran_da_dau');
    so_tran_da_dau = prefs.getInt('so_tran_da_dau');
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong');
    ngay_bat_dau = prefs.getString('ngay_bat_dau');
    ngay_ket_thuc = prefs.getString('ngay_ket_thuc');
    so_bang_dau = prefs.getInt('so_bang_dau');
    so_doi_vao_vong_trong = prefs.getInt('so_doi_vao_vong_trong');
    loai_san = prefs.getInt('loai_san');
    hinh_thuc_dau_id = prefs.getInt('hinh_thuc_dau_id');
    id = prefs.getInt('id');

    print('id: $id');

    // Text trong TextFormField
    setState(() {
      tenGiaiDau_Controller.text = ten_giai_dau.toString();
      sanDau_Controller.text = san_dau.toString();
      banToChuc_Controller.text = ban_to_chuc.toString();
      sanDau_Controller.text = san_dau.toString();
      ngayBatDau_Controller.text = ngay_bat_dau.toString();
      ngayKetThuc_Controller.text = ngay_ket_thuc.toString();
      soLuongDoiBong_Controller.text = so_luong_doi_bong.toString();
      selectedHinhThuc = tenHinhThuc.toString();
      selectedBangDau = so_bang_dau.toString();
      selectedVongTrong = so_doi_vao_vong_trong.toString();
      selectedLoaiSan = loai_san.toString();
      soBangDau = so_bang_dau!;
      tongSoTranDau = so_vong_dau!;
      soDoiVaoVongTrong = so_doi_vao_vong_trong!;
      if (selectedBangDau == '0' || selectedVongTrong == '0') {
        selectedBangDau = '2';
        selectedVongTrong = '2';
      }
    });
  }

  var tenGiaiDau_Controller = TextEditingController();
  var banToChuc_Controller = TextEditingController();
  var sanDau_Controller = TextEditingController();
  var ngayBatDau_Controller = TextEditingController();
  var ngayKetThuc_Controller = TextEditingController();
  var soLuongDoiBong_Controller = TextEditingController();

  Future<void> selectDateStart(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat.yMd('vi_VN').format(pickedDate);
      ngayBatDau_Controller.text = formattedDate;
      setState(() {
        error4 = false;
      });
    }
  }

  Future<void> selectDateEnd(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat.yMd('vi_VN').format(pickedDate);
      ngayKetThuc_Controller.text = formattedDate;
      setState(() {
        error5 = false;
      });
    }
  }

  void updatedData(int id) async {
    final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau/$id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access_token = prefs.getString('accessToken') ?? '';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final body = {
      'ten_giai_dau': tenGiaiDau_Controller.text,
      'hinh_thuc_dau_id': hinh_thuc_dau_id,
      'ban_to_chuc': banToChuc_Controller.text,
      'san_dau': sanDau_Controller.text,
      'ngay_bat_dau': ngayBatDau_Controller.text,
      'ngay_ket_thuc': ngayKetThuc_Controller.text,
      'so_luong_doi_bong': int.parse(soLuongDoiBong_Controller.text),
      'so_bang_dau':
          (selectedHinhThuc == 'Chia bảng đấu') ? selectedBangDau : 0,
      'so_doi_vao_vong_trong':
          (selectedHinhThuc == 'Chia bảng đấu') ? selectedVongTrong : 0,
      'loai_san': selectedLoaiSan,
      'so_vong_dau': tongSoTranDau,
      'so_tran_da_dau': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await http.put(Uri.parse(apiGiaiDau),
        body: jsonEncode(body), headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Sửa giải đấu thành công!');
      if (soLuongDoiBong_Controller.text.isEmpty) {
        if (selectedHinhThuc == 'Chia bảng đấu') {
          if (int.parse(soLuongDoiBong_Controller.text) < 6 ||
              int.parse(soLuongDoiBong_Controller.text) > 16) {
            setState(() {
              error = true;
            });
          }
        } else if (selectedHinhThuc == 'Loại trực tiếp') {
          if (int.parse(soLuongDoiBong_Controller.text) < 2 ||
              int.parse(soLuongDoiBong_Controller.text) > 16) {
            setState(() {
              error = true;
            });
          }
        } else if (selectedHinhThuc == 'Đấu vòng tròn') {
          if (int.parse(soLuongDoiBong_Controller.text) < 3 ||
              int.parse(soLuongDoiBong_Controller.text) > 16) {
            setState(() {
              error = true;
            });
          }
        }
      } else if (!error) {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LeaguesCustom()),
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

    if (selectedHinhThuc == 'Chia bảng đấu') {
      // Tính số lượng trận đấu
      int soLuongDoiBongTrong1Bang = 0;
      int tiLeDoiBong = 0;
      int tiLeDoiBong2 = 0;
      if (soBangDau > 0) {
        soLuongDoiBongTrong1Bang = soDoiThamGia ~/ soBangDau;
        tiLeDoiBong = soDoiThamGia % soBangDau;
        tiLeDoiBong2 = soDoiThamGia % soBangDau;
      }

      int SoBangDauUp1 = 0;
      for (int i = 1; i <= soBangDau; i++) {
        if (tiLeDoiBong > 0 && tiLeDoiBong < soBangDau) {
          SoBangDauUp1++;
          tiLeDoiBong--;
        }
      }
      int SLDoiBong1 = soBangDau - SoBangDauUp1;
      int SLDoiBong2 = soBangDau - SLDoiBong1;
      if (tiLeDoiBong2 == 0) {
        tongSoTranDau =
            tinhChapToHopCua2(soLuongDoiBongTrong1Bang) * soBangDau +
                (soDoiVaoVongTrong - 1);
      } else {
        tongSoTranDau =
            (tinhChapToHopCua2(soLuongDoiBongTrong1Bang) * SLDoiBong1) +
                (tinhChapToHopCua2(soLuongDoiBongTrong1Bang + 1) * SLDoiBong2) +
                (soDoiVaoVongTrong - 1);
      }
    } else if (selectedHinhThuc == 'Loại trực tiếp') {
      if (soDoiThamGia >= 2) {
        tongSoTranDau = soDoiThamGia - 1;
      } else {
        tongSoTranDau = 0;
      }
    } else {
      tongSoTranDau = factorial(soDoiThamGia) ~/
          (factorial(2) * factorial(soDoiThamGia - 2));
    }

    return tongSoTranDau;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Cấu hình giải đấu',
            style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'Thông tin chung',
                ),
              ),
              Tab(
                child: Text(
                  'Hình thức thi đấu',
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: FractionallySizedBox(
            widthFactor: 0.99,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    updatedData(id as int);
                  });
                },
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
                  'LƯU',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          // Thông tin chung
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: tenGiaiDau_Controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Tên giải đấu',
                      errorText: error1 ? 'Vui lòng nhập thông tin' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        error1 = false;
                      });
                    },
                    onTap: () {
                      if (tenGiaiDau_Controller.text.isEmpty) {
                        setState(() {
                          error1 = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: banToChuc_Controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Ban tổ chức',
                      errorText: error2 ? 'Vui lòng nhập thông tin' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        error2 = false;
                      });
                    },
                    onTap: () {
                      if (banToChuc_Controller.text.isEmpty) {
                        setState(() {
                          error2 = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: sanDau_Controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Địa điểm tổ chức',
                      errorText: error3 ? 'Vui lòng nhập thông tin' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        error3 = false;
                      });
                    },
                    onTap: () {
                      if (sanDau_Controller.text.isEmpty) {
                        setState(() {
                          error3 = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: ngayBatDau_Controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: 'Ngày bắt đầu',
                      errorText: error4 ? 'Vui lòng nhập thông tin' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onTap: () {
                      selectDateStart(context);
                      if (sanDau_Controller.text.isEmpty) {
                        setState(() {
                          error4 = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: ngayKetThuc_Controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: 'Ngày kết thúc',
                      errorText: error5 ? 'Vui lòng nhập thông tin' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onTap: () {
                      selectDateEnd(context);
                      if (ngayKetThuc_Controller.text.isEmpty) {
                        setState(() {
                          error5 = true;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Hình thức thi đấu
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'HÌNH THỨC THI ĐẤU',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedHinhThuc,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedHinhThuc = newValue!;
                                updatetongSoTranDau();
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Chia bảng đấu',
                                child: const Text('Chia bảng đấu'),
                                onTap: () {
                                  setState(() {
                                    hinh_thuc_dau_id = 1;
                                    soBangDau = 2;
                                    soDoiVaoVongTrong = 2;
                                    updatetongSoTranDau();
                                  });
                                },
                              ),
                              DropdownMenuItem<String>(
                                value: 'Loại trực tiếp',
                                child: const Text('Loại trực tiếp'),
                                onTap: () {
                                  setState(() {
                                    hinh_thuc_dau_id = 2;
                                    soBangDau = 0;
                                    soDoiVaoVongTrong = 0;
                                    updatetongSoTranDau();
                                  });
                                },
                              ),
                              DropdownMenuItem<String>(
                                value: 'Đấu vòng tròn',
                                child: const Text('Đấu vòng tròn'),
                                onTap: () {
                                  setState(() {
                                    hinh_thuc_dau_id = 3;
                                    soBangDau = 0;
                                    soDoiVaoVongTrong = 0;
                                    updatetongSoTranDau();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ĐỘI THAM GIA VÀ LƯỢT ĐẤU',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  (selectedHinhThuc == 'Chia bảng đấu')
                      ? TextFormField(
                          controller: soLuongDoiBong_Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Số đội tham gia [6 -> 16]',
                            errorText:
                                error ? 'Vui lòng nhập số đội 6 -> 16' : null,
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
                        )
                      : (selectedHinhThuc == 'Loại trực tiếp')
                          ? TextFormField(
                              controller: soLuongDoiBong_Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Số đội tham gia [2 -> 16]',
                                errorText: error
                                    ? 'Vui lòng nhập số đội 2 -> 16'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onChanged: (value) {
                                int? parsedValue = int.tryParse(value);
                                if (parsedValue != null &&
                                    (parsedValue < 2 || parsedValue > 16)) {
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
                            )
                          : TextFormField(
                              controller: soLuongDoiBong_Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Số đội tham gia [3 -> 16]',
                                errorText: error
                                    ? 'Vui lòng nhập số đội 3 -> 16'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onChanged: (value) {
                                int? parsedValue = int.tryParse(value);
                                if (parsedValue != null &&
                                    (parsedValue < 3 || parsedValue > 16)) {
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
                  const SizedBox(height: 20),
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
                            value: selectedLoaiSan,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedLoaiSan = newValue!;
                                updatetongSoTranDau();
                              });
                            },
                            items: const [
                              DropdownMenuItem<String>(
                                value: '5',
                                child: Text('5 người'),
                              ),
                              DropdownMenuItem<String>(
                                value: '7',
                                child: Text('7 người'),
                              ),
                              DropdownMenuItem<String>(
                                value: '9',
                                child: Text('9 người'),
                              ),
                              DropdownMenuItem<String>(
                                value: '11',
                                child: Text('11 người'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  (selectedHinhThuc == 'Chia bảng đấu')
                      ? FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Số bảng đấu',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedBangDau,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedBangDau = newValue!;
                                      updatetongSoTranDau();
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: '2',
                                      child: const Text('2 bảng'),
                                      onTap: () {
                                        setState(() {
                                          soBangDau = 2;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem<String>(
                                      value: '3',
                                      child: const Text('3 bảng'),
                                      onTap: () {
                                        setState(() {
                                          soBangDau = 3;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem<String>(
                                      value: '4',
                                      child: const Text('4 bảng'),
                                      onTap: () {
                                        setState(() {
                                          soBangDau = 4;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem<String>(
                                      value: '5',
                                      child: const Text('5 bảng'),
                                      onTap: () {
                                        setState(() {
                                          soBangDau = 5;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  (selectedHinhThuc == 'Chia bảng đấu')
                      ? const SizedBox(height: 20)
                      : Container(),
                  (selectedHinhThuc == 'Chia bảng đấu')
                      ? FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Số đội vào vòng trong',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedVongTrong,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedVongTrong = newValue!;

                                      updatetongSoTranDau();
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: '2',
                                      child: const Text('2 đội'),
                                      onTap: () {
                                        setState(() {
                                          soDoiVaoVongTrong = 2;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem<String>(
                                      value: '4',
                                      child: const Text('4 đội'),
                                      onTap: () {
                                        setState(() {
                                          soDoiVaoVongTrong = 4;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem<String>(
                                      value: '8',
                                      child: const Text('8 đội'),
                                      onTap: () {
                                        setState(() {
                                          soDoiVaoVongTrong = 8;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  (selectedHinhThuc == 'Chia bảng đấu')
                      ? const SizedBox(height: 20)
                      : Container(),
                  (selectedHinhThuc == 'Loại trực tiếp')
                      ? Container()
                      : const Text(
                          'CÁCH TÍNH ĐIỂM TRẬN',
                          style: TextStyle(fontSize: 17),
                        ),
                  (selectedHinhThuc == 'Loại trực tiếp')
                      ? Container()
                      : const SizedBox(height: 20),
                  (selectedHinhThuc == 'Loại trực tiếp')
                      ? Container()
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Thắng',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Hòa',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Thua',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                  (selectedHinhThuc == 'Loại trực tiếp')
                      ? Container()
                      : const SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng số trận đấu',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.green),
                            ),
                            Text(
                              '${tongSoTranDau.toString()} trận',
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  (selectedHinhThuc == 'Đấu vòng tròn')
                      ? Container()
                      : const Text(
                          'CÀI ĐẶT KHÁC',
                          style: TextStyle(fontSize: 17),
                        ),
                  (selectedHinhThuc == 'Đấu vòng tròn')
                      ? Container()
                      : Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              visualDensity: VisualDensity.comfortable,
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                  if (value == true) {
                                    tongSoTranDau += 1;
                                  } else {
                                    tongSoTranDau -= 1;
                                  }
                                });
                              },
                            ),
                            const Text(
                              'Cho phép tổ chức trận tranh hạng ba',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
