// ignore_for_file: camel_case_types, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../admin/leagues/admin_leagues-infor.dart';

import '../infor-leagues_srceen.dart';
import 'match-details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Schedule_Screen extends StatefulWidget {
  const Schedule_Screen({super.key});

  @override
  State<Schedule_Screen> createState() => _Schedule_ScreenState();
}

class _Schedule_ScreenState extends State<Schedule_Screen> {
  int id = 0;
  int soVongDau = 0;
  int _selectedIndex = 0;
  int _printSelected = 0;
  int SLTranTrong1Vong = 0;
  int so_luong_doi_bong = 0;
  int selectedVongDau = 0;
  bool checkLuuVongDau = true;
  bool baoChuaCoLichDau = false;
  bool isLoading = true;
  String access_token = '';
  String tiSo = '';
  String idTranDau = '';
  String loaiTaiKhoan = '';
  final String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  final String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
  List<dynamic> resultsLichTD = [];
  List<dynamic> resultsDoiBong = [];
  List<dynamic> resultsTranDau = [];
  List<String> DSMaTranDau = [];
  List<String?> listTenDoiBong1 = [];
  List<String?> listTenDoiBong2 = [];
  List<String?> listLogoDoiBong1 = [];
  List<String?> listLogoDoiBong2 = [];
  List<String?> listTime = [];
  List<String?> listDate = [];
  List<String?> listTiSo = [];
  List<int?> listIDTranDau = [];
  var idVaTen_Map = <int, String>{};

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
    await fetchLichTDData(selectedVongDau);
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    id = prefs.getInt('id') ?? 0;
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong') ?? 0;
    loaiTaiKhoan = prefs.getString('loaitaikhoan') ?? '';

    setState(() {
      SLTranTrong1Vong = so_luong_doi_bong ~/ 2;
      if (so_luong_doi_bong % 2 == 0) {
        soVongDau = so_luong_doi_bong - 1;
      } else {
        soVongDau = so_luong_doi_bong;
      }
      for (int i = 0; i < SLTranTrong1Vong; i++) {
        listTenDoiBong1.add('');
        listTenDoiBong2.add('');
        listLogoDoiBong1.add('images/logo3.png');
        listLogoDoiBong2.add('images/logo3.png');
        listTime.add('');
        listDate.add('');
        listTiSo.add('');
      }
    });
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

  List<String> addListTime(
      List<dynamic> data, int idGiaiDau, String checkVong) {
    List<String> listDoiBongID = data
        .where((item) =>
            idGiaiDau == (item['giai_dau_id'] as int) &&
            item['ma_tran_dau'].toString().startsWith(checkVong))
        .map((item) => item['thoi_gian'].toString())
        .toList();
    return listDoiBongID;
  }

  List<String> addListDate(
      List<dynamic> data, int idGiaiDau, String checkVong) {
    List<String> listDoiBongID = data
        .where((item) =>
            idGiaiDau == (item['giai_dau_id'] as int) &&
            item['ma_tran_dau'].toString().startsWith(checkVong))
        .map((item) => item['ngay_dien_ra'].toString())
        .toList();
    return listDoiBongID;
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
            idGiaiDau == (item['giai_dau_id'] as int) &&
            item['ma_tran_dau'].toString().startsWith(checkVong))
        .map((item) => item['doi_bong_${doi}_id'].toString())
        .toList();
    return listDoiBongID;
  }

  List<int> addListIDTheoVong(
      List<dynamic> data, int idGiaiDau, String checkVong) {
    List<int> listDoiBongID = data
        .where((item) =>
            idGiaiDau == (item['giai_dau_id'] as int) &&
            item['ma_tran_dau'].toString().startsWith(checkVong))
        .map((item) => item['id'] as int)
        .toList();
    return listDoiBongID;
  }

  List<String> addLisTiSo(List<dynamic> data, List<int> listIDLichTD) {
    List<String> listTiSo = data
        .where((item) => listIDLichTD.contains(item['lich_thi_dau_id']))
        .map((item) => item['ti_so'].toString())
        .toList();
    return listTiSo;
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
    final responseTranDau =
        await http.get(Uri.parse(apiTranDau), headers: headers);

    if (responseLichTD.statusCode == 200 &&
        responseDoiBong.statusCode == 200 &&
        responseTranDau.statusCode == 200) {
      final jsonDataLichTD = json.decode(responseLichTD.body);
      final jsonDataDoiBong = json.decode(responseDoiBong.body);
      final jsonDataTranDau = json.decode(responseTranDau.body);
      resultsLichTD = jsonDataLichTD['data'];
      resultsDoiBong = jsonDataDoiBong['data'];
      resultsTranDau = jsonDataTranDau['data'];

      DSMaTranDau = resultsLichTD
          .where((item) => id == (item['giai_dau_id'] as int))
          .map((item) => item['ma_tran_dau'].toString())
          .toList();

      String checkDataVong1 = '1-1';
      String checkDataVong2TroDi = '${selectedVongDau + 1}-1';
      String checkDataVong2 = '${selectedVongDau + 1}';

      if (DSMaTranDau.isEmpty) {
        setState(() {
          isLoading = false;
        });
      }
      if (DSMaTranDau.isNotEmpty) {
        if (selectedVongDau == 0) {
          if (DSMaTranDau.contains(checkDataVong1)) {
            checkLuuVongDau = false;
            List<int> listIDTranDau = addListIDTheoVong(resultsLichTD, id, '1');
            List<String> listIDDoi1 =
                addListIDDoiBong(resultsLichTD, id, 1, '1');
            List<String> listIDDoi2 =
                addListIDDoiBong(resultsLichTD, id, 2, '1');
            List<String?> listTen1 = await getTenDoiBongList(listIDDoi1);
            List<String?> listTen2 = await getTenDoiBongList(listIDDoi2);
            setState(() {
              listTenDoiBong1 = listTen1;
              listTenDoiBong2 = listTen2;
              listLogoDoiBong1 = addListlogoDoiBong(resultsDoiBong, listIDDoi1);
              listLogoDoiBong2 = addListlogoDoiBong(resultsDoiBong, listIDDoi2);
              listTime = addListTime(resultsLichTD, id, '1');
              listDate = addListDate(resultsLichTD, id, '1');
              listTiSo = addLisTiSo(resultsTranDau, listIDTranDau);
              isLoading = false;
            });
          } else {
            checkLuuVongDau = true;
          }
        } else {
          if (DSMaTranDau.contains(checkDataVong2TroDi)) {
            checkLuuVongDau = false;
            List<int> listIDTranDau =
                addListIDTheoVong(resultsLichTD, id, checkDataVong2);
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
              listTime = addListTime(resultsLichTD, id, checkDataVong2);
              listDate = addListDate(resultsLichTD, id, checkDataVong2);
              listTiSo = addLisTiSo(resultsTranDau, listIDTranDau);
              isLoading = false;
            });
          } else {
            checkLuuVongDau = true;
          }
        }
      }
    } else {
      print('Lỗi lấy dữ liệu bảng Lịch thi đấu: ${responseLichTD.statusCode}');
      print('Lỗi lấy dữ liệu bảng Football: ${responseDoiBong.statusCode}');
    }
  }

  Widget line() {
    return Container(
      height: 2,
      color: Colors.grey[200],
    );
  }

  Widget lineText() {
    return const Text(
      '-',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  String addString(List<dynamic> data, String maTranDau, String value) {
    String text = data
        .where((item) =>
            maTranDau == (item['ma_tran_dau']) && id == item['giai_dau_id'])
        .map((item) => item[value])
        .toList()
        .join();
    return text;
  }

  void onDetails(List<dynamic> data, String maTranDau, String doi1, String doi2,
      String logo1, String logo2) async {
    String idLichTD = addString(data, maTranDau, 'id');
    String idDoi1 = addString(data, maTranDau, 'doi_bong_1_id');
    String idDoi2 = addString(data, maTranDau, 'doi_bong_2_id');
    String thoi_gian = addString(data, maTranDau, 'thoi_gian');
    String ngay_dien_ra = addString(data, maTranDau, 'ngay_dien_ra');
    String trangThai = addString(data, maTranDau, 'trang_thai_tran_dau');
    String dia_diem = addString(data, maTranDau, 'dia_diem');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ma_tran_dau', maTranDau);
    prefs.setInt('doi_bong_1_id', int.parse(idDoi1));
    prefs.setInt('doi_bong_2_id', int.parse(idDoi2));
    prefs.setString('idLichTD', idLichTD);
    prefs.setString('ten_doi1', doi1);
    prefs.setString('ten_doi2', doi2);
    prefs.setString('logo_doi1', logo1);
    prefs.setString('logo_doi2', logo2);
    prefs.setString('thoi_gian', thoi_gian);
    prefs.setString('ngay_dien_ra', ngay_dien_ra);
    prefs.setInt('trang_thai_tran_dau', int.parse(trangThai));
    prefs.setString('dia_diem', dia_diem);

    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MatchDetails_Screen(),
        ),
      );
    });
  }

  Widget textTiSo(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  String tiSoDoi(String tiso, int doi) {
    List<String> phanCon = tiso.split('-');
    String ketQua = phanCon[doi];
    return ketQua;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          'Lịch thi đấu',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            if (loaiTaiKhoan == 'user' || loaiTaiKhoan == 'User') {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InforTouament()),
                );
              });
            } else {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LeaguesInforAdmin_Screen()),
                );
              });
            }
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ) // Widget loading
          : (DSMaTranDau.isEmpty)
              ? const Center(
                  child: Text(
                    'Chưa có lịch thi đấu!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          color: Colors.teal[900],
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
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                selectedVongDau = index;
                                              });
                                              await fetchLichTDData(
                                                  selectedVongDau);
                                              setState(() {
                                                _selectedIndex = index;
                                                _printSelected = index;
                                                if (checkLuuVongDau == true) {
                                                  baoChuaCoLichDau = true;
                                                } else {
                                                  baoChuaCoLichDau = false;
                                                }
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>((Set<
                                                              MaterialState>
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
                                                          : Colors
                                                              .grey.shade400),
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
                        child: baoChuaCoLichDau
                            ? const Center(
                                child: Text('Vòng này chưa có lịch đấu!',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey)),
                              )
                            : ListView.builder(
                                itemCount: SLTranTrong1Vong,
                                itemBuilder: (context, indexTran) {
                                  return FractionallySizedBox(
                                    widthFactor: 1,
                                    child: SizedBox(
                                      height: 120,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          String maTranDau =
                                              '${selectedVongDau + 1}-${indexTran + 1}';
                                          String logoDoi1 =
                                              listLogoDoiBong1[indexTran]
                                                  .toString();
                                          String logoDoi2 =
                                              listLogoDoiBong2[indexTran]
                                                  .toString();
                                          String tenDoi1 =
                                              listTenDoiBong1[indexTran]
                                                  .toString();
                                          String tenDoi2 =
                                              listTenDoiBong2[indexTran]
                                                  .toString();

                                          onDetails(
                                              resultsLichTD,
                                              maTranDau,
                                              tenDoi1,
                                              tenDoi2,
                                              logoDoi1,
                                              logoDoi2);
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade50),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          textStyle: MaterialStateProperty.all<
                                              TextStyle>(
                                            const TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                        ),
                                        child: Column(
                                          children: [
                                            line(),
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
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                    'Trận ${indexTran + 1}'),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(listTenDoiBong1[
                                                    indexTran]!),
                                                Image.asset(
                                                  listLogoDoiBong1[indexTran]!,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                const SizedBox(width: 3),
                                                (listTiSo[indexTran] == 'null')
                                                    ? (listTime[indexTran]! ==
                                                                'null' ||
                                                            listDate[
                                                                    indexTran]! ==
                                                                'null')
                                                        ? lineText()
                                                        : Column(
                                                            children: [
                                                              Text(listTime[
                                                                  indexTran]!),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        3),
                                                                child:
                                                                    Container(
                                                                  height: 2,
                                                                  width: 70,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                              Text(listDate[
                                                                  indexTran]!),
                                                            ],
                                                          )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 20),
                                                        child: Row(
                                                          children: [
                                                            textTiSo(tiSoDoi(
                                                                listTiSo[
                                                                    indexTran]!,
                                                                0)),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child:
                                                                  textTiSo('-'),
                                                            ),
                                                            textTiSo(tiSoDoi(
                                                                listTiSo[
                                                                    indexTran]!,
                                                                1)),
                                                          ],
                                                        ),
                                                      ),
                                                const SizedBox(width: 3),
                                                Image.asset(
                                                  listLogoDoiBong2[indexTran]!,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                Text(listTenDoiBong2[
                                                    indexTran]!),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
