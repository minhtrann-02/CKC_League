// ignore_for_file: file_names, camel_case_types, depend_on_referenced_packages, non_constant_identifier_names, unrelated_type_equality_checks, avoid_print

import 'dart:convert';
import 'package:ckc_league/admin/leagues/custom/schedule/match/admin_match-result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'schedule_screen.dart';

class MatchDetails_Screen extends StatefulWidget {
  const MatchDetails_Screen({super.key});

  @override
  State<MatchDetails_Screen> createState() => _MatchDetails_ScreenState();
}

class _MatchDetails_ScreenState extends State<MatchDetails_Screen> {
  int soVongDau = 0;
  int selectedVongDau = 0;
  int tiSoDoi1 = 0;
  int tiSoDoi2 = 0;
  int idGiaiDau = 0;
  int idDoiBong1 = 0;
  int idDoiBong2 = 0;
  bool kiemTraLuu = false;
  bool check = true;
  bool isLoading = true;
  String idTranDau = '';
  String idLichTD = '';
  String access_token = '';
  String ten_doi1 = '';
  String ten_doi2 = '';
  String logo_doi1 = 'images/logo3.png';
  String logo_doi2 = 'images/logo3.png';
  String thoi_gian = '';
  String ngay_dien_ra = '';
  String dia_diem = '';
  String loaiTaiKhoan = '';
  String tiSo = '';
  final String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
  final String apiTomTat = 'http://10.0.2.2:8000/api/auth/ChiTietTomTat';
  final String apiPlayer = 'http://10.0.2.2:8000/api/auth/players';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  List<String> listThongTin = [];
  List<String> listTenDoiBong = [];
  List<String> listTenCauThu = [];
  List<String> listThoiGian = [];
  List<String> listSoAo = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
    await fetchTranDauData();
    await getIDDoiBong(ten_doi1, ten_doi2);
    await getTiSo(idDoiBong1, idDoiBong2);
    await kiemTraLuuTT();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idLichTD = prefs.getString('idLichTD') ?? '';
    loaiTaiKhoan = prefs.getString('loaitaikhoan') ?? '';
    idGiaiDau = prefs.getInt('id') ?? 0;
    idTranDau = prefs.getString('idTranDau') ?? '';
    setState(() {
      ten_doi1 = prefs.getString('ten_doi1') ?? '';
      ten_doi2 = prefs.getString('ten_doi2') ?? '';
      logo_doi1 = prefs.getString('logo_doi1') ?? '';
      logo_doi2 = prefs.getString('logo_doi2') ?? '';
      thoi_gian = prefs.getString('thoi_gian') ?? '';
      ngay_dien_ra = prefs.getString('ngay_dien_ra') ?? '';
      dia_diem = prefs.getString('dia_diem') ?? '';
      if (thoi_gian == 'null' || ngay_dien_ra == 'null' || dia_diem == 'null') {
        thoi_gian = '';
        ngay_dien_ra = '';
        dia_diem = '';
      } else {
        thoi_gian = thoi_gian;
        ngay_dien_ra = ngay_dien_ra;
        dia_diem = dia_diem;
      }
    });
  }

  Future<int?> getIDDoiBong(String tenDoiBong1, String tenDoiBong2) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseFootball =
        await http.get(Uri.parse(apiDoiBong), headers: headers);
    if (responseFootball.statusCode == 200) {
      final jsonDataFootball = json.decode(responseFootball.body);
      List<dynamic> resultsFootball = jsonDataFootball['data'];

      int idDB1 = resultsFootball.firstWhere(
          (item) => tenDoiBong1 == item['ten_doi_bong'],
          orElse: () => null)?['id'];
      int idDB2 = resultsFootball.firstWhere(
          (item) => tenDoiBong2 == item['ten_doi_bong'],
          orElse: () => null)?['id'];

      setState(() {
        idDoiBong1 = idDB1;
        idDoiBong2 = idDB2;
      });
    } else {
      print('Lỗi football: ${responseFootball.statusCode}');
      return null;
    }
    return null;
  }

  String getData(List<dynamic> data, String text) {
    String KQ = data
        .where((item) => int.parse(idLichTD) == item['lich_thi_dau_id'] as int)
        .map((item) => item[text])
        .toList()
        .join(',');
    return KQ;
  }

  Future<void> fetchTranDauData() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final responseTranDau =
        await http.get(Uri.parse(apiTranDau), headers: headers);

    if (responseTranDau.statusCode == 200) {
      final jsonDataTranDau = json.decode(responseTranDau.body);
      List<dynamic> resultTranDau = jsonDataTranDau['data'];

      setState(() {
        tiSo = getData(resultTranDau, 'ti_so');
        idTranDau = getData(resultTranDau, 'id');
        if (tiSo == 'null') {
          tiSoDoi1 = 0;
          tiSoDoi2 = 0;
        } else {
          tiSoDoi1 = int.parse(tiSoDoi(tiSo, 0));
          tiSoDoi2 = int.parse(tiSoDoi(tiSo, 1));
        }
        isLoading = false;
      });
    } else {
      print('Lỗi: ${responseTranDau.statusCode}');
    }
  }

  List<String> getThongTin(List<dynamic> data, String tenTT) {
    List<String> tiSoDoi = data
        .where((item) =>
            idGiaiDau == item['giai_dau_id'] &&
            int.parse(idTranDau) == item['tran_dau_id'])
        .map((item) => item[tenTT].toString())
        .toList();
    return tiSoDoi;
  }

  Future<void> getTiSo(int idDoiBong1, int idDoiBong2) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseTiSo = await http.get(Uri.parse(apiTomTat), headers: headers);
    if (responseTiSo.statusCode == 200) {
      final jsonDataTiSo = json.decode(responseTiSo.body);
      List<dynamic> resultsTiSo = jsonDataTiSo['data'];

      // Lấy thông tin tóm tắt
      List<int> listIDDoiBong = resultsTiSo
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'])
          .map((item) => item['doi_bong_id'] as int)
          .toList();
      await getTenDoiBongList(listIDDoiBong);

      List<int> listIDCauThu = resultsTiSo
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'])
          .map((item) => item['cau_thu_id'] as int)
          .toList();
      print('listIDCauThu: $listIDCauThu');
      await getTenCauThuList(listIDCauThu);
      await getSoAoCauThuList(listIDCauThu);

      setState(() {
        listThongTin = getThongTin(resultsTiSo, 'loai_thong_tin');
        listThoiGian = getThongTin(resultsTiSo, 'thoi_gian');
        listTenDoiBong = listTenDoiBong;
        listTenCauThu = listTenCauThu;
        listSoAo = listSoAo;
      });
    } else {
      print('Lỗi football: ${responseTiSo.statusCode}');
      return;
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
    return listTenDoiBong = IDDoiBongList;
  }

  Future<List<String>> getTenCauThuList(List<int> cauThuIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiPlayer), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = cauThuIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['ten_cau_thu'].toString();
      }
      return '';
    }).toList();
    return listTenCauThu = IDDoiBongList;
  }

  Future<List<String>> getSoAoCauThuList(List<int> cauThuIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiPlayer), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = cauThuIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['so_ao'].toString();
      }
      return '';
    }).toList();
    return listSoAo = IDDoiBongList;
  }

  Widget textTiSo(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  String tiSoDoi(String tiso, int doi) {
    List<String> phanCon = tiso.split('-');
    String ketQua = phanCon[doi];
    return ketQua;
  }

  String? image(String tenLoai) {
    if (tenLoai == 'Bàn thắng') {
      return 'images/theball.png';
    }
    if (tenLoai == 'Thẻ đỏ') {
      return 'images/red_card.png';
    }
    if (tenLoai == 'Thẻ vàng') {
      return 'images/yellow_card.png';
    }
    return null;
  }

  Future<void> kiemTraLuuTT() async {
    String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD/$idLichTD';
    print('idLichTD: $idLichTD');
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(apiLichTD), headers: headers);
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      int trangThai = jsonData['data']['trang_thai_tran_dau'];
      if (trangThai == 1) {
        kiemTraLuu = true;
      } else {
        kiemTraLuu = false;
      }
      print('kiemTraLuu: $kiemTraLuu');
    } else {
      print('Lỗi lấy lịch thi đấu: ${response.statusCode}');
    }
  }

  void showCanhBaoLuu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Thông tin trận đấu đã được lưu! Không được phép sửa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
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
                  'Đồng ý',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFA011129),
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Thông tin trận đấu',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Schedule_Screen()),
            );
          },
        ),
        actions: [
          (loaiTaiKhoan == 'user' || loaiTaiKhoan == 'User')
              ? Container()
              : IconButton(
                  onPressed: () async {
                    if (kiemTraLuu == true) {
                      showCanhBaoLuu();
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('idTranDau', idTranDau);

                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MatchResult()),
                        );
                      });
                    }
                  },
                  icon: const Icon(Icons.system_update_alt_rounded),
                ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ) // Widget loading
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFA011129),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    logo_doi1,
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    ten_doi1,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                              (tiSo == 'null')
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            thoi_gian,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              height: 3,
                                              width: 85,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Text(
                                            ngay_dien_ra,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Row(
                                        children: [
                                          textTiSo('$tiSoDoi1'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: textTiSo('-'),
                                          ),
                                          textTiSo('$tiSoDoi2'),
                                        ],
                                      ),
                                    ),
                              Column(
                                children: [
                                  Image.asset(
                                    logo_doi2,
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    ten_doi2,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              dia_diem,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ListView.builder(
                    itemCount: listThongTin.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              image(listThongTin[index])!,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listTenDoiBong[index],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${listSoAo[index]}. ${listTenCauThu[index]}  (${listThoiGian[index]}')",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
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
