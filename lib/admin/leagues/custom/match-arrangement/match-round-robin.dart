// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MatchRoundRobin extends StatefulWidget {
  const MatchRoundRobin({super.key});

  @override
  State<MatchRoundRobin> createState() => _MatchRoundRobinState();
}

class _MatchRoundRobinState extends State<MatchRoundRobin> {
  int selectedKTLuu = 0;
  int idGiaiDau = 0;
  int soVongDau = 0;
  int SLTranTrong1Vong = 0;
  int _selectedIndex = 0;
  int _printSelected = 0;
  int selectedVongDau = 0;
  int selectedKiemTraLuu = 0;
  int soDoiDaThamGia = 0;
  int? so_luong_doi_bong = 0;
  bool isLoading = true;
  bool checkSaveVongDau = false;
  bool checkGetData = false;
  bool kiemTraGap = false;
  bool kiemTraGap_random = false;
  bool checkGiongNhau = false;
  bool isFunctionCalled = false;
  bool checkDaDienRa = false;
  String access_token = '';
  final String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  final String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
  List<String> selectedValues1 = [];
  List<String> selectedValues2 = [];
  List<String> dropdownTen = [];
  List<String> listID = [];
  List<String> idDoiNha = [];
  List<String> idDoiKhach = [];
  List<String> existingMaTranDau = [];
  List<String> selectedValuesDB1 = [];
  List<String> selectedValuesDB2 = [];
  List<String> listCap1 = [];
  List<String> listCap2 = [];
  List<String?> listDoiNha = [];
  List<String?> listDoiKhach = [];
  List<dynamic> resultsDBTGD = [];
  List<dynamic> resultsTranDau = [];
  List<DropdownMenuItem<String>> dropdownItems = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var idVaTen_Map = <int, String>{};

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadDatabase();
    await kiemTraCapNhap();
    await fetchDSDoiBongData();
    await getData();
  }

  Future<void> loadDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong');
    idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
  }

  Future<void> kiemTraVongDau(int vongDau) async {
    List<String> listMaTran = [];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonData = json.decode(responseLichTD.body);
      List<dynamic> resultsLichTD = jsonData['data'];

      for (int i = 0; i < resultsDBTGD.length ~/ 2; i++) {
        listMaTran.add('${vongDau + 1}-${i + 1}');
      }

      List<int> listIDTranDau = resultsLichTD
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              listMaTran.contains(item['ma_tran_dau']))
          .map((item) => item['trang_thai_tran_dau'] as int)
          .toList();

      for (int trangThai in listIDTranDau) {
        if (trangThai == 1) {
          checkDaDienRa = true;
          break;
        } else {
          checkDaDienRa = false;
        }
      }
    } else {
      print('Lỗi load Trận Đấu: ${responseLichTD.statusCode}');
    }
  }

  Future<void> getData() async {
    setState(() {
      SLTranTrong1Vong = so_luong_doi_bong! ~/ 2;
      if (so_luong_doi_bong! % 2 == 0) {
        soVongDau = so_luong_doi_bong! - 1;
      } else {
        soVongDau = so_luong_doi_bong!;
      }
      isLoading = false;
    });
  }

  Future<void> selectedDoiBong(List<String> dropdownTen) async {
    setState(() {
      selectedValues1.addAll(dropdownTen);
      selectedValues2.addAll(dropdownTen);
    });
  }

  Future<List<String>?> fetchDSDoiBongData() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final String apiDSDoiBong =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau?giai_dau_id=$idGiaiDau';
    final response = await http.get(Uri.parse(apiDSDoiBong), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      resultsDBTGD = jsonData['data'];
      int SLdoiThamGia = resultsDBTGD.length;
      if (SLdoiThamGia == so_luong_doi_bong) {
        soDoiDaThamGia = resultsDBTGD.length ~/ 2;
      } else {
        soDoiDaThamGia = 0;
      }

      List<int> doiBongIDs =
          resultsDBTGD.map((item) => item['doi_bong_id'] as int).toList();
      dropdownTen = await getTenDoiBongList(doiBongIDs);
      if (dropdownTen.isEmpty) {
        await selectedDoiBong(dropdownTen);
        setState(() {
          dropdownTen.add('');
        });
      } else {
        await selectedDoiBong(dropdownTen);
        setState(() {
          dropdownItems = dropdownTen.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList();
        });
      }
      return dropdownTen;
    } else {
      print('Lỗi ${response.statusCode}');
      return null;
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

  Future<List<String>> getIDDoiBongList(List<String?> listDoiBong) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
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

  void checkSave() {
    for (String? element in listDoiNha) {
      if (listDoiKhach.contains(element)) {
        checkGiongNhau = true;
        showThongBao('Đội $element bị trùng lặp!', Colors.red);
        break;
      } else {
        checkGiongNhau = false;
      }
    }
    if (checkGiongNhau == false) {
      for (int i = 0; i < listDoiNha.length; i++) {
        for (int j = i + 1; j < listDoiNha.length; j++) {
          if (listDoiNha[i] == listDoiNha[j]) {
            checkGiongNhau = true;
            showThongBao('Đội  ${listDoiNha[i]} bị trùng lặp!', Colors.red);
            break;
          }
        }
      }
    }
    if (checkGiongNhau == false) {
      for (int i = 0; i < listDoiKhach.length; i++) {
        for (int j = i + 1; j < listDoiKhach.length; j++) {
          if (listDoiKhach[i] == listDoiKhach[j]) {
            showThongBao('Đội mã ${listDoiNha[i]} bị trùng lặp!', Colors.red);
            checkGiongNhau = true;
            break;
          }
        }
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

  void saveData(String maTranDau, int idDoi1, int idDoi2) async {
    List<dynamic> lichThiDau = [];
    bool check = false;
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
      existingMaTranDau = lichThiDau
          .where((item) => idGiaiDau == item['giai_dau_id'])
          .map((item) => item['ma_tran_dau'].toString())
          .toList();
      if (existingMaTranDau.contains(maTranDau)) {
        check = true;
      }
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
    }

    final body = {
      'ma_tran_dau': maTranDau,
      'doi_bong_1_id': idDoi1,
      'doi_bong_2_id': idDoi2,
      'giai_dau_id': idGiaiDau,
      'thoi_gian': 'null',
      'ngay_dien_ra': 'null',
      'trang_thai_tran_dau': 0,
      'dia_diem': 'null',
    };
    if (check == true) {
      String listID = lichThiDau
          .where((item) =>
              maTranDau.contains(item['ma_tran_dau']) &&
              idGiaiDau == item['giai_dau_id'])
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
    } else {
      final response = await http.post(Uri.parse(apiLichTD),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        if (!isFunctionCalled) {
          saveDataTranDau(maTranDau);
          isFunctionCalled = true;
        }
        print('Lưu lịch thi đấu thành công');
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    }
  }

  void showErrorSave(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Đồng ý',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> kiemTraCapNhap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access_token = prefs.getString('accessToken') ?? '';
    int id = prefs.getInt('id') ?? 0;
    String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';

    List<dynamic> lichThiDau = [];
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
      List<String> DSMaTranDau = lichThiDau
          .where((item) => id == (item['giai_dau_id'] as int))
          .map((item) => item['ma_tran_dau'].toString())
          .toList();
      String checkLuu = '${selectedVongDau + 1}-1';
      String checkVong2 = '${selectedKiemTraLuu + 1}-1';
      String check3 = '${selectedKiemTraLuu + 1}';

      if (selectedKiemTraLuu == 0) {
        if (DSMaTranDau.contains('1-1') || DSMaTranDau.contains(checkLuu)) {
          checkSaveVongDau = true;
          checkGetData = true;
          isFunctionCalled = true;
          List<int> listID1 = lichThiDau
              .where((item) =>
                  item['ma_tran_dau'].toString().startsWith('1') &&
                  id == (item['giai_dau_id'] as int))
              .map((item) => item['doi_bong_1_id'] as int)
              .toList();
          selectedValuesDB1 = await getTenDoiBongList(listID1);
          listDoiNha = selectedValuesDB1;
          List<int> listID2 = lichThiDau
              .where((item) =>
                  item['ma_tran_dau'].toString().startsWith('1') &&
                  id == (item['giai_dau_id'] as int))
              .map((item) => item['doi_bong_2_id'] as int)
              .toList();
          selectedValuesDB2 = await getTenDoiBongList(listID2);
          listDoiKhach = selectedValuesDB2;
        } else {
          List<String> listDoi1 = [];
          List<String> listDoi2 = [];
          for (int i = 0; i < dropdownTen.length ~/ 2; i++) {
            listDoi1.add(selectedValues1[i]);
            listDoi2.add(selectedValues1[i]);
          }
          listDoiNha = listDoi1;
          listDoiKhach = listDoi2;
          isFunctionCalled = false;
          checkSaveVongDau = false;
          checkGetData = false;
        }
      } else {
        if (DSMaTranDau.contains(checkLuu) ||
            DSMaTranDau.contains(checkVong2)) {
          isFunctionCalled = true;
          checkSaveVongDau = true;
          if (DSMaTranDau.contains(checkVong2)) {
            isFunctionCalled = true;
            checkGetData = true;
            List<int> listID1 = lichThiDau
                .where((item) =>
                    item['ma_tran_dau'].toString().startsWith(check3) &&
                    id == (item['giai_dau_id'] as int))
                .map((item) => item['doi_bong_1_id'] as int)
                .toList();
            selectedValuesDB1 = await getTenDoiBongList(listID1);
            listDoiNha = selectedValuesDB1;
            List<int> listID2 = lichThiDau
                .where((item) =>
                    item['ma_tran_dau'].toString().startsWith(check3) &&
                    id == (item['giai_dau_id'] as int))
                .map((item) => item['doi_bong_2_id'] as int)
                .toList();
            selectedValuesDB2 = await getTenDoiBongList(listID2);
            listDoiKhach = selectedValuesDB2;
          } else {
            List<String> listDoi1 = [];
            List<String> listDoi2 = [];
            for (int i = 0; i < dropdownTen.length ~/ 2; i++) {
              listDoi1.add(selectedValues1[i]);
              listDoi2.add(selectedValues1[i]);
            }
            listDoiNha = listDoi1;
            listDoiKhach = listDoi2;
            checkGetData = false;
            isFunctionCalled = false;
          }
        } else {
          List<String> listDoi1 = [];
          List<String> listDoi2 = [];
          for (int i = 0; i < dropdownTen.length ~/ 2; i++) {
            listDoi1.add(selectedValues1[i]);
            listDoi2.add(selectedValues1[i]);
          }
          listDoiNha = listDoi1;
          listDoiKhach = listDoi2;
          isFunctionCalled = false;
          checkGetData = false;
          checkSaveVongDau = false;
        }
      }
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
      throw Exception('Failed to fetch team names');
    }
  }

  Future<void> kiemTraGap2Lan(
      List<String> idDoiNha, List<String> idDoiKhach, int vongDau) async {
    List<dynamic> lichThiDau = [];
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

      List<String> soTran1Vong = [];
      for (int i = 0; i < resultsDBTGD.length ~/ 2; i++) {
        soTran1Vong.add('$vongDau-${i + 1}');
      }
      List<String> listID1 = lichThiDau
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              !soTran1Vong.contains(item['ma_tran_dau']))
          .map((item) => item['doi_bong_1_id'].toString())
          .toList();
      List<String> listID2 = lichThiDau
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              !soTran1Vong.contains(item['ma_tran_dau']))
          .map((item) => item['doi_bong_2_id'].toString())
          .toList();

      List<String> idDoi1 = [];
      List<String> idDoi2 = [];

      if (int.tryParse(idDoiNha[0]) == null) {
        idDoi1 = await getIDDoiBongList(idDoiNha);
        idDoi2 = await getIDDoiBongList(idDoiKhach);
      } else {
        idDoi1 = idDoiNha;
        idDoi2 = idDoiKhach;
      }

      List<String> list1 = idDoi1;
      List<String> list2 = idDoi2;

      List<String> capDauIn = [];
      List<String> capDauOut = [];
      for (int i = 0; i < list1.length; i++) {
        capDauIn.add('${list1[i]}-${list2[i]}');
      }
      for (int i = 0; i < listID1.length; i++) {
        capDauOut.add('${listID1[i]}-${listID2[i]}');
      }

      for (String item in capDauIn) {
        String nguocLai = item.split('-').reversed.join('-');
        if (capDauOut.contains(item) || capDauOut.contains(nguocLai)) {
          kiemTraGap = true;
          break;
        } else {
          kiemTraGap = false;
        }
      }
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
      throw Exception('Failed to fetch team names');
    }
  }

  void saveDataTranDau(String maTranDau) async {
    const String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access_token = prefs.getString('accessToken') ?? '';
    int id = prefs.getInt('id') ?? 0;
    List<String> idLichTD = [];
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    //Get Data Lịch thi đấu
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonData = json.decode(responseLichTD.body);
      List<dynamic> lichThiDau = jsonData['data'];
      idLichTD = lichThiDau
          .where((item) =>
              id == item['giai_dau_id'] as int &&
              item['ma_tran_dau'].toString().startsWith(maTranDau[0]))
          .map((item) => item['id'].toString())
          .toList();
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
    }

    for (int i = 0; i < idLichTD.length; i++) {
      final body = {
        'trong_tai_1_id': 0,
        'trong_tai_2_id': 0,
        'lich_thi_dau_id': int.parse(idLichTD[i]),
        'ti_so': 'null',
        'tong_so_the': 0,
        'so_the_vang': 0,
        'so_the_do': 0,
        'bu_gio': 0,
      };

      final response = await http.post(Uri.parse(apiTranDau),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        print('Cập nhật trận đấu thành công');
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    }
  }

  Future<void> layDSCapDauNew(int vongDau) async {
    List<dynamic> lichThiDau = [];
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

      List<String> soTran1Vong = [];
      for (int i = 0; i < resultsDBTGD.length ~/ 2; i++) {
        soTran1Vong.add('$vongDau-${i + 1}');
      }
      listCap1 = lichThiDau
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              !soTran1Vong.contains(item['ma_tran_dau']))
          .map((item) => item['doi_bong_1_id'].toString())
          .toList();
      listCap2 = lichThiDau
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              !soTran1Vong.contains(item['ma_tran_dau']))
          .map((item) => item['doi_bong_2_id'].toString())
          .toList();
    } else {
      print('lỗi: ${responseLichTD.statusCode}');
      throw Exception('Failed to fetch team names');
    }
  }

  Future<void> kiemTraNgauNhien(
      List<String> idDoiNha, List<String> idDoiKhach, int vongDau) async {
    List<String> idDoi1 = [];
    List<String> idDoi2 = [];

    if (int.tryParse(idDoiNha[0]) == null) {
      idDoi1 = await getIDDoiBongList(idDoiNha);
      idDoi2 = await getIDDoiBongList(idDoiKhach);
    } else {
      idDoi1 = idDoiNha;
      idDoi2 = idDoiKhach;
    }

    List<String> list1 = idDoi1;
    List<String> list2 = idDoi2;

    List<String> capDauIn = [];
    List<String> capDauOut = [];
    for (int i = 0; i < list1.length; i++) {
      capDauIn.add('${list1[i]}-${list2[i]}');
    }
    for (int i = 0; i < listCap1.length; i++) {
      capDauOut.add('${listCap1[i]}-${listCap2[i]}');
    }

    for (String item in capDauIn) {
      String nguocLai = item.split('-').reversed.join('-');
      if (capDauOut.contains(item) || capDauOut.contains(nguocLai)) {
        kiemTraGap_random = true;
        break;
      } else {
        kiemTraGap_random = false;
      }
    }
  }

  void xepNgauNhien(int vongDau) async {
    List<String> selected1 = [];
    List<String> selected2 = [];
    Random random = Random();

    await layDSCapDauNew(vongDau);
    int soLuong = dropdownTen.length ~/ 2;
    do {
      // Lấy 3 đội ngẫu nhiên cho selected1
      while (selected1.length < soLuong) {
        String element = dropdownTen[random.nextInt(dropdownTen.length)];
        if (!selected1.contains(element)) {
          selected1.add(element);
        }
      }

      // Lấy 3 đội ngẫu nhiên cho selected2
      while (selected2.length < soLuong) {
        String element2 = dropdownTen[random.nextInt(dropdownTen.length)];
        if (!selected1.contains(element2) && !selected2.contains(element2)) {
          selected2.add(element2);
        }
      }

      await kiemTraNgauNhien(selected1, selected2, vongDau);
      if (kiemTraGap_random == true) {
        selected1.clear();
        selected2.clear();
      }
    } while (kiemTraGap_random == true);

    print('selected1: $selected1');
    print('selected2: $selected2');

    setState(() {
      selectedValues1 = selected1;
      selectedValues2 = selected2;
      selectedValuesDB1 = selected1;
      selectedValuesDB2 = selected2;
      listDoiNha = selected1;
      listDoiKhach = selected2;
    });
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
          title: const Text('Sắp xếp cặp đấu'),
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
                                            selectedKiemTraLuu = index;
                                            await kiemTraCapNhap();

                                            if (checkSaveVongDau == false) {
                                              showErrorSave(
                                                  'Vui lòng lưu các thay đổi trước khi chuyển sang vòng đấu khác');
                                            } else {
                                              setState(() {
                                                selectedVongDau = index;
                                                _selectedIndex = index;
                                                _printSelected = index;
                                              });
                                            }
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
                      child: (soDoiDaThamGia == 0)
                          ? const Center(
                              child: Text(
                                'Cần có đủ số lượng đội tham gia để sắp cặp đấu!',
                                style:
                                    TextStyle(fontSize: 17, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: soDoiDaThamGia,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 130,
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
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: FormField<String>(
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: checkGetData
                                                            ? selectedValuesDB1[
                                                                index]
                                                            : selectedValues1[
                                                                index],
                                                        isDense: true,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            if (checkGetData ==
                                                                true) {
                                                              selectedValuesDB1[
                                                                      index] =
                                                                  newValue!;
                                                            } else {
                                                              selectedValues1[
                                                                      index] =
                                                                  newValue!;
                                                            }

                                                            listDoiNha[index] =
                                                                newValue;
                                                          });
                                                        },
                                                        items: dropdownItems,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: FormField<String>(
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: checkGetData
                                                            ? selectedValuesDB2[
                                                                index]
                                                            : selectedValues2[
                                                                index],
                                                        isDense: true,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            if (checkGetData ==
                                                                true) {
                                                              selectedValuesDB2[
                                                                      index] =
                                                                  newValue!;
                                                            } else {
                                                              selectedValues2[
                                                                      index] =
                                                                  newValue!;
                                                            }
                                                            listDoiKhach[
                                                                    index] =
                                                                newValue;
                                                          });
                                                        },
                                                        items: dropdownItems,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
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
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                child: FractionallySizedBox(
                  widthFactor: 0.99,
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        await kiemTraVongDau(selectedVongDau);
                        if (checkDaDienRa == false) {
                          setState(() {
                            xepNgauNhien(selectedVongDau + 1);
                          });
                        } else {
                          showErrorSave(
                              'Vòng đấu này đã có trận diễn ra!\n Không thể sắp lại cặp đấu');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade50),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.green, width: 2)),
                        ),
                      ),
                      child: const Text(
                        'XẾP NGẪU NHIÊN',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FractionallySizedBox(
                  widthFactor: 0.99,
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        await kiemTraVongDau(selectedVongDau);
                        checkSave();
                        if (checkDaDienRa == false) {
                          if (checkGiongNhau == false) {
                            idDoiNha = await getIDDoiBongList(listDoiNha);
                            idDoiKhach = await getIDDoiBongList(listDoiKhach);
                            await kiemTraGap2Lan(
                                idDoiNha, idDoiKhach, (selectedVongDau + 1));
                            if (kiemTraGap == false) {
                              for (int i = 0; i < SLTranTrong1Vong; i++) {
                                for (int id1 = 0;
                                    id1 < idDoiNha.length;
                                    id1++) {
                                  for (int id2 = 0;
                                      id2 < idDoiKhach.length;
                                      id2++) {
                                    if (i == id1 && id1 == id2) {
                                      saveData(
                                          '${selectedVongDau + 1}-${i + 1}',
                                          int.parse(idDoiNha[id1]),
                                          int.parse(idDoiKhach[id2]));
                                    } else {
                                      continue;
                                    }
                                  }
                                }
                              }
                              setState(() {
                                checkSaveVongDau = true;
                              });
                              showThongBao(
                                  'Cập nhật thành công !', Colors.green);
                            } else {
                              showErrorSave(
                                  'Đã có sự trùng lặp giữa 2 đội gặp nhau!');
                            }
                          }
                        } else {
                          showErrorSave(
                              'Vòng đấu này đã có trận diễn ra!\n Không thể sắp lại cặp đấu');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ],
        ),
      ),
    );
  }
}
