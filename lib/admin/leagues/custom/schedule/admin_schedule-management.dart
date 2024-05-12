// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement> {
  List<bool> error = [];
  int id = 0;
  int soVongDau = 0;
  int SLTranTrong1Vong = 0;
  int _selectedIndex = 0;
  int _printSelected = 0;
  int selectedVongDau = 0;
  int? so_luong_doi_bong = 0;
  bool isLoading = true;
  bool checkData = false;
  bool checkData_CapDau = true;
  bool baoChuaSapCapDau = false;
  DateTime datenow = DateTime.now();
  String ngay_bat_dau = '';
  String access_token = '';
  final String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  final String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
  List<String?> listTenDoiBong1 = [];
  List<String?> listTenDoiBong2 = [];
  List<String?> listLogoDoiBong1 = [];
  List<String?> listLogoDoiBong2 = [];
  List<String> listDiaDiem = [];
  List<String> listDate = [];
  List<String> listTime = [];
  List<dynamic> lichThiDau = [];
  List<TextEditingController> diaDiem_controller = [];
  List<TextEditingController> date_controller = [];
  List<TextEditingController> time_controller = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var idVaTen_Map = <int, String>{};

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken(selectedVongDau);
    await fetchLichTDData(selectedVongDau);
  }

  Future<void> getToken(int selectedVongDau) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    id = prefs.getInt('id') ?? 0;
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong');
    ngay_bat_dau = prefs.getString('ngay_bat_dau') ?? '';

    SLTranTrong1Vong = so_luong_doi_bong! ~/ 2;
    List<String> maTran = [];
    for (int i = 0; i < SLTranTrong1Vong; i++) {
      maTran.add('${selectedVongDau + 1}-${i + 1}');
    }
    print('maTran: $maTran');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonDataLichTD = json.decode(responseLichTD.body);
      List<dynamic> resultsLichTD = jsonDataLichTD['data'];

      listDiaDiem = resultsLichTD
          .where((item) =>
              id == item['giai_dau_id'] &&
              maTran.contains(item['ma_tran_dau']) &&
              item['dia_diem'] != 'null')
          .map((item) => item['dia_diem'].toString())
          .toList();
      listTime = resultsLichTD
          .where((item) =>
              id == item['giai_dau_id'] &&
              maTran.contains(item['ma_tran_dau']) &&
              item['thoi_gian'] != 'null')
          .map((item) => item['thoi_gian'].toString())
          .toList();
      listDate = resultsLichTD
          .where((item) =>
              id == item['giai_dau_id'] &&
              maTran.contains(item['ma_tran_dau']) &&
              item['ngay_dien_ra'] != 'null')
          .map((item) => item['ngay_dien_ra'].toString())
          .toList();
    } else {
      print('Lỗi: ${responseLichTD.statusCode}');
    }

    print('listDate: $listDate');
    print('listDiaDiem: $listDiaDiem');
    print('listTime: $listTime');

    setState(() {
      SLTranTrong1Vong = so_luong_doi_bong! ~/ 2;
      if (so_luong_doi_bong! % 2 == 0) {
        soVongDau = so_luong_doi_bong! - 1;
      } else {
        soVongDau = so_luong_doi_bong!;
      }
      // Lấy từ dữ liệu
      if (listDate.isEmpty) {
        date_controller.clear();
        for (var i = 0; i < soVongDau; i++) {
          setState(() {
            date_controller.add(TextEditingController());
          });
        }
      } else {
        date_controller.clear();
        List<TextEditingController> textControllers = listDate.map((value) {
          TextEditingController controller = TextEditingController();
          controller.text = value;
          return controller;
        }).toList();
        date_controller.addAll(textControllers);
      }

      if (listDiaDiem.isEmpty) {
        diaDiem_controller.clear();
        for (var i = 0; i < soVongDau; i++) {
          setState(() {
            diaDiem_controller.add(TextEditingController());
          });
        }
      } else {
        diaDiem_controller.clear();
        List<TextEditingController> textControllers = listDiaDiem.map((value) {
          TextEditingController controller = TextEditingController();
          controller.text = value;
          return controller;
        }).toList();
        diaDiem_controller.addAll(textControllers);
      }

      if (listTime.isEmpty) {
        time_controller.clear();
        for (var i = 0; i < soVongDau; i++) {
          setState(() {
            time_controller.add(TextEditingController());
          });
        }
      } else {
        time_controller.clear();
        List<TextEditingController> textControllers = listTime.map((value) {
          TextEditingController controller = TextEditingController();
          controller.text = value;
          return controller;
        }).toList();
        time_controller.addAll(textControllers);
      }

      for (int i = 0; i < SLTranTrong1Vong; i++) {
        listTenDoiBong1.add('');
        listTenDoiBong2.add('');
        listLogoDoiBong1.add('images/logo3.png');
        listLogoDoiBong2.add('images/logo3.png');
        error.add(false);
      }
      isLoading = false;
    });
  }

  Future<void> selectDate(BuildContext context, index) async {
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
      date_controller[index].text = formattedDate;
    }
  }

  Future<void> selectTime(BuildContext context, index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.green,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: Builder(
            builder: (BuildContext context) {
              return Localizations.override(
                context: context,
                locale: const Locale('vi', 'VN'),
                child: child!,
              );
            },
          ),
        );
      },
    );

    if (pickedTime != null) {
      final formattedTime = DateFormat.Hm('vi_VN').format(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            pickedTime.hour, pickedTime.minute),
      );
      time_controller[index].text = formattedTime;
    }
  }

  List<String?> addListlogoDoiBong(List<dynamic> data, List<String> listID) {
    for (var item in data) {
      var id = int.tryParse(item['id'].toString());
      var logo = item['logo'].toString();
      if (id != null) {
        idVaTen_Map[id] = logo;
      }
    }
    List<String?> listLogoDoiBong =
        listID.map((id) => idVaTen_Map[int.parse(id)]).toList();
    return listLogoDoiBong;
  }

  List<String> addListIDDoiBong(
      List<dynamic> data, int idGiaiDau, int doi, String checkVong) {
    List<String> listDoiBongID = data
        .where((item) =>
            idGiaiDau == (item['giai_dau_id']) &&
            item['ma_tran_dau'].toString().startsWith(checkVong))
        .map((item) => item['doi_bong_${doi}_id'].toString())
        .toList();
    return listDoiBongID;
  }

  Future<void> fetchLichTDData(int selectedVongDau) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    final responseDoiBong =
        await http.get(Uri.parse(apiDoiBong), headers: headers);

    if (responseLichTD.statusCode == 200 && responseDoiBong.statusCode == 200) {
      final jsonDataLichTD = json.decode(responseLichTD.body);
      final jsonDataDoiBong = json.decode(responseDoiBong.body);
      List<dynamic> resultsLichTD = jsonDataLichTD['data'];
      List<dynamic> resultsDoiBong = jsonDataDoiBong['data'];

      List<String> DSMaTranDau = resultsLichTD
          .where((item) => id == (item['giai_dau_id'] as int))
          .map((item) => item['ma_tran_dau'].toString())
          .toList();

      String checkDataVong1 = '1-1';
      String checkDataVong2TroDi = '${selectedVongDau + 1}-1';
      String checkDataVong2 = '${selectedVongDau + 1}';

      if (selectedVongDau == 0) {
        if (DSMaTranDau.contains(checkDataVong1)) {
          checkData_CapDau = false;
          List<String> listIDDoi1 = addListIDDoiBong(resultsLichTD, id, 1, '1');
          List<String> listIDDoi2 = addListIDDoiBong(resultsLichTD, id, 2, '1');
          List<String?> listTen1 = await getTenDoiBongList(listIDDoi1);
          List<String?> listTen2 = await getTenDoiBongList(listIDDoi2);
          setState(() {
            listTenDoiBong1 = listTen1;
            listTenDoiBong2 = listTen2;
            listLogoDoiBong1 = addListlogoDoiBong(resultsDoiBong, listIDDoi1);
            listLogoDoiBong2 = addListlogoDoiBong(resultsDoiBong, listIDDoi2);
          });
        } else {
          checkData_CapDau = true;
        }
      } else {
        if (DSMaTranDau.contains(checkDataVong2TroDi)) {
          checkData_CapDau = false;
          List<String> listIDDoi1 =
              addListIDDoiBong(resultsLichTD, id, 1, checkDataVong2);
          List<String> listIDDoi2 =
              addListIDDoiBong(resultsLichTD, id, 2, checkDataVong2);
          List<String?> listTen1 = await getTenDoiBongList(listIDDoi1);
          List<String?> listTen2 = await getTenDoiBongList(listIDDoi2);
          setState(() {
            listTenDoiBong1 = listTen1;
            listTenDoiBong2 = listTen2;
            listLogoDoiBong1 = addListlogoDoiBong(resultsDoiBong, listIDDoi1);
            listLogoDoiBong2 = addListlogoDoiBong(resultsDoiBong, listIDDoi2);
          });
        } else {
          checkData_CapDau = true;
        }
      }
    } else {
      print('Lỗi lấy dữ liệu bảng Lịch thi đấu: ${responseLichTD.statusCode}');
      print('Lỗi lấy dữ liệu bảng Football: ${responseDoiBong.statusCode}');
    }
  }

  Future<List<String?>> getTenDoiBongList(List<String> doiBongIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };

    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> doiBongData = jsonData['data'];
      for (var item in doiBongData) {
        var id = int.tryParse(item['id'].toString());
        var tenDoiBong = item['ten_doi_bong'].toString();
        if (id != null) {
          idVaTen_Map[id] = tenDoiBong;
        }
      }

      List<String?> tenDoiBongList =
          doiBongIDs.map((id) => idVaTen_Map[int.parse(id)]).toList();

      return tenDoiBongList;
    } else {
      print('lỗi: ${response.statusCode}');
      throw Exception('Failed to fetch team names');
    }
  }

  Future<List<String>> getIDDoiBongList(List<String?> listDoiBong) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    const String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> doiBongData = jsonData['data'];
      List<String> IDDoiBongList = listDoiBong.map((doiBong) {
        int index =
            doiBongData.indexWhere((item) => item['ten_doi_bong'] == doiBong);
        if (index >= 0) {
          return doiBongData[index]['id'].toString();
        }
        return '';
      }).toList();
      return IDDoiBongList;
    } else {
      print('lỗi: ${response.statusCode}');
      throw Exception('Failed to fetch team names');
    }
  }

  void saveData(String maTranDau, int id1, int id2, String time, String date,
      String diaDiem) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonData = json.decode(responseLichTD.body);
      lichThiDau = jsonData['data'];
      List<String> existingMaTranDau = lichThiDau
          .where((item) => id == item['giai_dau_id'])
          .map((item) => item['ma_tran_dau'].toString())
          .toList();
      if (existingMaTranDau.contains(maTranDau)) {
        checkData = true;
      }
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
      throw Exception('Failed to fetch team names');
    }
    final body = {
      'ma_tran_dau': maTranDau,
      'doi_bong_1_id': id1,
      'doi_bong_2_id': id2,
      'giai_dau_id': id,
      'thoi_gian': time,
      'ngay_dien_ra': date,
      'trang_thai_tran_dau': 0,
      'dia_diem': diaDiem,
    };
    //Kiểm tra xem
    if (checkData == true) {
      String listID = lichThiDau
          .where((item) =>
              maTranDau.contains(item['ma_tran_dau']) &&
              id == item['giai_dau_id'])
          .map((item) => item['id'].toString())
          .toList()
          .join(',');
      String apiUpdate = 'http://10.0.2.2:8000/api/auth/LichTD/$listID';
      final response = await http.put(Uri.parse(apiUpdate),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        print('Cập nhật lịch thi đấu thành công');
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    }
  }

  void showThongBao(String text, Color color) {
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Quản lý lịch đấu'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ) // Widget loading
            : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xF8001F4E),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: soVongDau,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              selectedVongDau = index;
                                            });
                                            await getToken(selectedVongDau);
                                            await fetchLichTDData(
                                                selectedVongDau);

                                            setState(() {
                                              _selectedIndex = index;
                                              _printSelected = index;
                                              if (checkData_CapDau == true) {
                                                baoChuaSapCapDau = true;
                                              } else {
                                                baoChuaSapCapDau = false;
                                              }
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                              if (_selectedIndex == index) {
                                                return Colors.green;
                                              }
                                              return Colors.transparent;
                                            }),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: (_selectedIndex ==
                                                            index)
                                                        ? Colors.green
                                                        : Colors.grey.shade400),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Vòng ${_printSelected + 1}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: baoChuaSapCapDau
                          ? const Center(
                              child: Text('Vòng này chưa sắp cặp đấu',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: SLTranTrong1Vong,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 220,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 30,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text('Trận ${index + 1}'),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            listTenDoiBong1[index]!,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Image.asset(
                                            listLogoDoiBong1[index]!,
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            '-',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Image.asset(
                                            listLogoDoiBong2[index]!,
                                            height: 50,
                                            width: 50,
                                          ),
                                          Text(
                                            listTenDoiBong2[index]!,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  diaDiem_controller[index],
                                              decoration: InputDecoration(
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 20),
                                                fillColor: Colors.white,
                                                hintText: 'Địa điểm',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    controller:
                                                        date_controller[index],
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 8,
                                                              horizontal: 20),
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          'Ngày tháng năm',
                                                      errorText: error[index]
                                                          ? 'Ngày bắt đầu không phù hợp'
                                                          : null,
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      selectDate(
                                                          context, index);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        time_controller[index],
                                                    readOnly: true,
                                                    decoration:
                                                        const InputDecoration(
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 20),
                                                      fillColor: Colors.white,
                                                      hintText: 'Thời gian',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      selectTime(
                                                          context, index);
                                                    },
                                                  ),
                                                ),
                                              ],
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
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: FractionallySizedBox(
            widthFactor: 0.99,
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (error.contains(true)) {
                    print('error: $error');
                    showThongBao('Ngày nhập vào không hợp lệ!', Colors.red);
                  } else {
                    List<String> listID1 =
                        await getIDDoiBongList(listTenDoiBong1);
                    List<String> listID2 =
                        await getIDDoiBongList(listTenDoiBong2);

                    for (int sl = 0; sl < SLTranTrong1Vong; sl++) {
                      for (int id1 = 0; id1 < listID1.length; id1++) {
                        for (int id2 = 0; id2 < listID1.length; id2++) {
                          for (int time = 0;
                              time < time_controller.length;
                              time++) {
                            for (int date = 0;
                                date < date_controller.length;
                                date++) {
                              for (int san = 0;
                                  san < diaDiem_controller.length;
                                  san++) {
                                if (sl == id1 &&
                                    id1 == id2 &&
                                    id2 == time &&
                                    time == date &&
                                    date == san) {
                                  String maTranDau =
                                      '${selectedVongDau + 1}-${sl + 1}';
                                  saveData(
                                      maTranDau,
                                      int.parse(listID1[id1]),
                                      int.parse(listID2[id2]),
                                      time_controller[time].text,
                                      date_controller[date].text,
                                      diaDiem_controller[san].text);
                                }
                              }
                            }
                          }
                        }
                      }
                      showThongBao('Cập nhật thành công!', Colors.green);
                    }
                  }
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // bool kiemTraNgay(String ngay, String ngayBD) {
  //   if (ngay.isNotEmpty && ngayBD.isNotEmpty) {
  //     DateFormat dateFormat = DateFormat('d/M/yyyy');
  //     DateTime ngayIn = dateFormat.parse(ngay);
  //     DateTime ngayBDGD = dateFormat.parse(ngayBD);
  //     print('ngayIn: $ngayIn');
  //     print('ngayBD: $ngayBDGD');
  //     // So sánh ngày
  //     if (ngayIn.isBefore(datenow)) {
  //       return false;
  //     } else if (ngayIn.isAfter(datenow)) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }
}
