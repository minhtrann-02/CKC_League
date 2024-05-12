// ignore_for_file: file_names, depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'admin_competition-form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddLeagues_Screen extends StatefulWidget {
  const AddLeagues_Screen({super.key});

  @override
  State<AddLeagues_Screen> createState() => _AddLeagues_ScreenState();
}

class _AddLeagues_ScreenState extends State<AddLeagues_Screen> {
  bool error1 = false;
  bool error2 = false;
  bool error3 = false;
  bool error4 = false;
  bool error5 = false;
  DateTime datenow = DateTime.now();

  var tenGiaiDau_Controller = TextEditingController();
  var banToChuc_Controller = TextEditingController();
  var sanDau_Controller = TextEditingController();
  var ngayBatDau_Controller = TextEditingController();
  var ngayKetThuc_Controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey[800],
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        elevation: 0,
        leading: TextButton(
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
                        'Bạn có muốn tiếp tục không?',
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
                              Navigator.pop(context);
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
          child: Text(
            'Hủy',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        title: const Text('Thông tin cơ bản'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: FractionallySizedBox(
          widthFactor: 0.99,
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: onClickContinue,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                'images/icon_cup.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 15),
              Text(
                'Vui lòng nhập đầy đủ các thông tin sau:',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: tenGiaiDau_Controller,
                decoration: InputDecoration(
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
              const SizedBox(height: 15),
              TextFormField(
                controller: banToChuc_Controller,
                decoration: InputDecoration(
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              TextFormField(
                controller: ngayBatDau_Controller,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Ngày bắt đầu',
                  errorText: error4 ? 'Ngày bắt đầu không phù hợp' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onTap: () {
                  selectDateStart(context);
                  if (ngayBatDau_Controller.text.isEmpty ||
                      kiemTraNgayStart(ngayBatDau_Controller.text) == false) {
                    setState(() {
                      print(
                          'Ngày bắt đầu: ${kiemTraNgayStart(ngayBatDau_Controller.text)}');
                      error4 = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: ngayKetThuc_Controller,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Ngày kết thúc',
                  errorText: error5 ? 'Ngày kết thúc không phù hợp' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onTap: () {
                  selectDateEnd(context);
                  if (ngayKetThuc_Controller.text.isEmpty ||
                      kiemTraNgayEnd(ngayBatDau_Controller.text,
                              ngayKetThuc_Controller.text) ==
                          false) {
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
    );
  }

  bool kiemTraNgayStart(String ngay) {
    if (ngay.isNotEmpty) {
      DateFormat dateFormat = DateFormat('d/M/yyyy');
      DateTime dateTime = dateFormat.parse(ngay);
      print('dateTime: $dateTime');
      // So sánh ngày
      if (dateTime.isBefore(datenow)) {
        return false;
      } else if (dateTime.isAfter(datenow)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool kiemTraNgayEnd(String start, String end) {
    DateFormat dateFormat = DateFormat('d/M/yyyy');
    DateTime dateStart = dateFormat.parse(start);
    DateTime dateEnd = dateFormat.parse(end);
    // So sánh ngày
    if (dateEnd.isBefore(datenow) ||
        dateStart == dateEnd ||
        dateEnd.isBefore(dateStart)) {
      return false;
    } else if (dateEnd.isAfter(datenow)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onClickContinue() async {
    // Kiểm tra các trường dữ liệu trước khi submit
    if (tenGiaiDau_Controller.text.isEmpty) {
      setState(() {
        error1 = true;
      });
    }
    if (banToChuc_Controller.text.isEmpty) {
      setState(() {
        error2 = true;
      });
    }
    if (sanDau_Controller.text.isEmpty) {
      setState(() {
        error3 = true;
      });
    }
    if (ngayBatDau_Controller.text.isEmpty ||
        kiemTraNgayStart(ngayBatDau_Controller.text) == false) {
      setState(() {
        error4 = true;
      });
    }
    if (ngayKetThuc_Controller.text.isEmpty ||
        kiemTraNgayEnd(ngayBatDau_Controller.text,ngayKetThuc_Controller.text) == false) {
      setState(() {
        error5 = true;
      });
    }
    if (!error1 && !error2 && !error3 && !error4 && !error5) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Lưu giá trị vào SharedPreferences
      prefs.setString('ten_giai_dau', tenGiaiDau_Controller.text);
      prefs.setString('ban_to_chuc', banToChuc_Controller.text);
      prefs.setString('san_dau', sanDau_Controller.text);
      prefs.setString('ngay_bat_dau', ngayBatDau_Controller.text);
      prefs.setString('ngay_ket_thuc', ngayKetThuc_Controller.text);
      print('Tên giải đấu: ${tenGiaiDau_Controller.text}');
      print('Ban tổ chức: ${banToChuc_Controller.text}');
      print('Sân đấu: ${sanDau_Controller.text}');
      print('Ngày bắt đầu: ${ngayBatDau_Controller.text}');
      print('Ngày kết thúc: ${ngayKetThuc_Controller.text}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompetitionForm_Screen()),
      );
    }
  }
}
