// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:ckc_league/Object_API/object_api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Statistic_Screen extends StatefulWidget {
  const Statistic_Screen({super.key});

  @override
  State<Statistic_Screen> createState() => _Statistic_ScreenState();
}

class _Statistic_ScreenState extends State<Statistic_Screen> {
  String access_token = '';

  int idGiaiDau = 0;
  int tongTranDau = 0;
  String tenCT = '';
  int sothevang = 0;
  int sothedo = 0;
  late List data;
  List<Data> dataList = []; // Khởi tạo một mảng mới
  List<int> doiBongIds = [];
  List<int> soTranThang = [];
  List<int> tongSoTran = [];
  List<int> soTranHoa = [];
  List<int> tongBanThang = [];
  List<int> tongBanThua = [];
  List<int> soTranThamGia = [];
  List<int> soTranThua = [];
  List<int> tongTheVang = [];
  List<String> tongTheVangVDV = [];
  List<String> tongTheDoVDV = [];
  List<int> tongTheDo = [];
  List<int> hieuSo = [];
  List<int> diem = [];
  List<int> tranDauVDV = [];
  List<String> doiBongNames = [];
  List<String> doiBongUrls = [];
  List<String> tenCauThuList = [];
  List<int> soTheDoList = [];
  List<int> soTheVangList = [];
  List<int> soBanThangList = [];
  int soBanThang = 0;
  List<Team> teams = [];
  List<Team> teamsVDV = [];
  List<String> tencauthu = [];
  List<int> listIDCT = [];
  List<Data> playerList = [];
  List<String> IDDoiBongList = [];

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('ID giải đấu: $idGiaiDau');
    final String url =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau1?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['data'] != null) {
        // Lọc danh sách dữ liệu theo cột 'giai_dau_id'
        dataList = (responseData['data'] as List)
            .where((item) => item['giai_dau_id'] == idGiaiDau)
            .map((item) => Data.fromJson(item))
            .toList();

        for (var item in dataList) {
          if (!doiBongIds.contains(item.doi_bong_id)) {
            doiBongIds.add(item.doi_bong_id!);
            tongTheVang.add(item.so_the_vang!);
            soTranThang.add(item.soTranThang!);
            tongTheDo.add(item.so_the_do!);
            soTranHoa.add(item.soTranHoa!);
            soTranThua.add(item.soTranThua!);
            tongBanThang.add(item.tong_ban_thang!);
            tongBanThua.add(item.tong_ban_thua!);
            print(doiBongIds);

            tongTranDau +=
                item.soTranThang! + item.soTranHoa! + item.soTranThua!;
            List<dynamic> doiBongInfo = await getDoiBong1(item.doi_bong_id!);
            String doiBongName =
                doiBongInfo[0] as String; // Khai báo biến doiBongName
            String doiBongLogo =
                doiBongInfo[1] as String; // Khai báo biến doiBongLogo
            doiBongNames.add(doiBongName);
            doiBongUrls.add(doiBongLogo);
            print(doiBongName);
            print(doiBongLogo);
            print('Tong tran dau: $tongTranDau');
          }
        }

        for (int i = 0; i < doiBongIds.length; i++) {
          int tong = soTranThang[i] + soTranThua[i] + soTranHoa[i];
          tongSoTran.add(tong);

          int HS = tongBanThang[i] - tongBanThua[i];
          hieuSo.add(HS);

          int Diem = soTranThang[i] * 3 + soTranHoa[i];
          diem.add(Diem);
        }

        // Cập nhật danh sách teams và sắp xếp theo điểm số giảm dần
        teams = [];
        for (int i = 0; i < doiBongIds.length; i++) {
          Team team = Team(
            doiBongId: doiBongIds[i],
            doiBongName: doiBongNames[i],
            doiBongUrl: doiBongUrls[i],
            tongSoTran: tongSoTran[i],
            tongTheDo: tongTheDo[i],
            tongTheVang: tongTheVang[i],
            soTranThang: soTranThang[i],
            soTranHoa: soTranHoa[i],
            soTranThua: soTranThua[i],
            hieuSo: hieuSo[i],
            diem: diem[i],
          );
          teams.add(team);
        }

        teams.sort((a, b) {
          if (b.diem != a.diem) {
            return b.diem.compareTo(a.diem); // Sắp xếp theo điểm giảm dần
          } else if (b.doiBongName != a.doiBongName) {
            return a.doiBongName
                .compareTo(b.doiBongName); // Sắp xếp theo tên đội bóng tăng dần
          } else if (b.tongSoTran != a.tongSoTran) {
            return b.tongSoTran
                .compareTo(a.tongSoTran); // Sắp xếp theo số trận đấu giảm dần
          } else {
            return b.hieuSo
                .compareTo(a.hieuSo); // Sắp xếp theo hiệu số giảm dần
          }
        });

        print('Tổng số trận theo từng chỉ mục:');
        for (int i = 0; i < tongSoTran.length; i++) {
          print('Đội ${doiBongIds[i]}: ${tongSoTran[i]} trận');
        }

        setState(() {
          // Cập nhật trạng thái của biến teams
          this.teams = teams;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchVDV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('ID giải đấu VDV: $idGiaiDau');
    final String url =
        'http://10.0.2.2:8000/api/auth/ChiTietTomTat?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['data'] != null) {
        // Lọc danh sách dữ liệu theo cột 'giai_dau_id'
        dataList = (responseData['data'] as List)
            .where((item) => item['giai_dau_id'] == idGiaiDau)
            .map((item) => Data.fromJson(item))
            .toList();

        for (var item in dataList) {
          if (!doiBongIds.contains(item.doi_bong_id)) {
            doiBongIds.add(item.doi_bong_id!);
            tongTheVangVDV.add(item.loai_thong_tin!);
            tranDauVDV.add(item.tran_dau_id!);
            print(doiBongIds);

            tongTranDau +=
                item.soTranThang! + item.soTranHoa! + item.soTranThua!;
            List<dynamic> doiBongInfo = await getDoiBong1(item.doi_bong_id!);
            String doiBongName =
                doiBongInfo[0] as String; // Khai báo biến doiBongName
            String doiBongLogo =
                doiBongInfo[1] as String; // Khai báo biến doiBongLogo
            doiBongNames.add(doiBongName);
            doiBongUrls.add(doiBongLogo);
            print(doiBongName);
            print(doiBongLogo);
            print('Tong tran dau: $tongTranDau');
          }
        }

        for (int i = 0; i < doiBongIds.length; i++) {
          int tong = soTranThang[i] + soTranThua[i] + soTranHoa[i];
          tongSoTran.add(tong);

          int HS = tongBanThang[i] - tongBanThua[i];
          hieuSo.add(HS);

          int Diem = soTranThang[i] * 3 + soTranHoa[i];
          diem.add(Diem);
        }

        // Cập nhật danh sách teams và sắp xếp theo điểm số giảm dần
        teamsVDV = [];
        for (int i = 0; i < doiBongIds.length; i++) {
          TeamVDV teamVDV = TeamVDV(
            doiBongId: doiBongIds[i],
            doiBongName: doiBongNames[i],
            doiBongUrl: doiBongUrls[i],
            tongSoTran: tongSoTran[i],
            tongTheDo: tongTheDo[i],
            tongTheVang: tongTheVang[i],
            soTranThang: soTranThang[i],
            soTranHoa: soTranHoa[i],
            soTranThua: soTranThua[i],
            hieuSo: hieuSo[i],
            diem: diem[i],
          );
          teamsVDV.add(teamVDV as Team);
        }

        teamsVDV.sort((a, b) {
          if (b.diem != a.diem) {
            return b.diem.compareTo(a.diem); // Sắp xếp theo điểm giảm dần
          } else if (b.doiBongName != a.doiBongName) {
            return a.doiBongName
                .compareTo(b.doiBongName); // Sắp xếp theo tên đội bóng tăng dần
          } else if (b.tongSoTran != a.tongSoTran) {
            return b.tongSoTran
                .compareTo(a.tongSoTran); // Sắp xếp theo số trận đấu giảm dần
          } else {
            return b.hieuSo
                .compareTo(a.hieuSo); // Sắp xếp theo hiệu số giảm dần
          }
        });

        print('Tổng số trận theo từng chỉ mục:');
        for (int i = 0; i < tongSoTran.length; i++) {
          print('Đội ${doiBongIds[i]}: ${tongSoTran[i]} trận');
        }

        setState(() {
          // Cập nhật trạng thái của biến teams
          this.teamsVDV = teamsVDV;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getDoiBong1(int doiBongId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/football/$doiBongId?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final doiBongName = responseData['data']['ten_doi_bong'];
      final logoUrl = responseData['data']['logo'];
      return [doiBongName, logoUrl];
    } else {
      throw Exception('Failed to load team data');
    }
  }

  void getidCauThuTG() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    String url = 'http://10.0.2.2:8000/api/auth/CauThuTrongGiaiDau';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        dataList = data
            .where((item) => idGiaiDau == item['id_giai_dau'])
            .map((x) => Data.fromJson(x))
            .toList();
      });
      for (var item in dataList) {
        listIDCT.add(item.id_cau_thu!);
        soBanThangList.add(item.soBanThang!);
        soTheDoList.add(item.so_the_do!);
        soTheVangList.add(item.so_the_vang!);
        soTranThamGia.add(item.so_tran_tham_gia!);
      }

      // Sắp xếp danh sách theo thứ tự giảm dần của cột soBanThang
      int length = soBanThangList.length;
      for (int i = 0; i < length - 1; i++) {
        for (int j = i + 1; j < length; j++) {
          if (soBanThangList[j] > soBanThangList[i]) {
            // Đổi vị trí các giá trị tương ứng trong tất cả các danh sách
            _swapValues(i, j, listIDCT);
            _swapValues(i, j, soBanThangList);
            _swapValues(i, j, soTheDoList);
            _swapValues(i, j, soTheVangList);
            _swapValues(i, j, soTranThamGia);
          }
        }
      }

      print('Danh sách id Cầu thủ là: $listIDCT');
      getTenCauThuList(listIDCT);
    } else {
      print('Lỗi ${response.statusCode}');
    }
  }

  void _swapValues<T>(int i, int j, List<T> list) {
    T temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  void getTenCauThuList(List<int> cauThuIDs) async {
    String apiPlayer = 'http://10.0.2.2:8000/api/auth/players';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiPlayer), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    IDDoiBongList = cauThuIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        String tenCauThu = doiBongData[index]['ten_cau_thu'].toString();

        // Lưu các giá trị vào danh sách tương ứng
        // Các danh sách này cần được khai báo trước để lưu trữ giá trị
        tenCauThuList.add(tenCauThu);

        soBanThangList.add(soBanThang);
        print('Ten cau thu la: $tenCauThuList');
        print('so the vang la: $soTheVangList');
        print('so the do la: $soTheDoList');
        print('so ban thang la: $soBanThangList');
      }
      return '';
    }).toList();

    print('Tên cầu thủ là: $IDDoiBongList');
  }

  @override
  void initState() {
    super.initState();
    data = [];
    fetchData();
    getidCauThuTG();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFA011129),
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Thống kê',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 134, 133, 133),
            tabs: [
              Tab(
                child: Text(
                  'Đội bóng',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'Vận động viên',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(children: [
            Column(
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '#   Đội',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SizedBox(width:5),

                            Row(
                              children: [
                                Text(
                                  'T.Vàng',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Image.asset(
                                  'images/yellow_card.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'T.Đỏ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Image.asset(
                                  'images/red_card.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Row(
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                    width:
                                        5), // Khoảng cách giữa Text và hình ảnh
                                Image.asset(
                                  'images/theball.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    Team team = teams[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.asset(
                                    team.doiBongUrl,
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                Text(
                                  team.doiBongName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  tongTheVang[index].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 80),
                                Text(
                                  tongTheDo[index].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 60),
                                Text(
                                  tongBanThang[index].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),

//Vận động viên
            Column(
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '#   Tên cầu thủ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SizedBox(width:25),

                            Row(
                              children: [
                                Text(
                                  'Số trận',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Image.asset(
                                  'images/yellow_card.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                                Text("/",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Image.asset(
                                  'images/red_card.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                              ],
                            ),

                            SizedBox(width: 5),
                            Row(
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                    width:
                                        5), // Khoảng cách giữa Text và hình ảnh
                                Image.asset(
                                  'images/theball.png', // Đường dẫn đến hình ảnh trong thư mục assets
                                  width: 30, // Chiều rộng của hình ảnh
                                  height: 30, // Chiều cao của hình ảnh
                                  // Các thuộc tính khác của hình ảnh (nếu cần)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: IDDoiBongList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 5),
                                //   child: Image.asset(
                                //     team.doiBongUrl,
                                //     height: 35,
                                //     width: 35,
                                //   ),
                                // ),
                                Text(
                                  tenCauThuList[index], //ten cau thu o day
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  soTranThamGia[index]
                                      .toString(), //so the vang ơ day
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 60),
                                Text(
                                  '${soTheVangList[index]}/${soTheDoList[index].toString()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 60),
                                Text(
                                  soBanThangList[index]
                                      .toString(), //so the do ơ day
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class Team {
  final int doiBongId;
  final String doiBongName;
  final String doiBongUrl;
  final int tongSoTran;
  final int soTranThang;
  final int soTranHoa;
  final int soTranThua;
  final int hieuSo;
  final int diem;

  Team({
    required this.doiBongId,
    required this.doiBongName,
    required this.doiBongUrl,
    required this.tongSoTran,
    required this.soTranThang,
    required this.soTranHoa,
    required this.soTranThua,
    required this.hieuSo,
    required this.diem,
    required int tongTheVang,
    required int tongTheDo,
  });
}

class TeamVDV {
  final int doiBongId;
  final String doiBongName;
  final String doiBongUrl;
  final int tongSoTran;
  final int soTranThang;
  final int soTranHoa;
  final int soTranThua;
  final int hieuSo;
  final int diem;

  TeamVDV({
    required this.doiBongId,
    required this.doiBongName,
    required this.doiBongUrl,
    required this.tongSoTran,
    required this.soTranThang,
    required this.soTranHoa,
    required this.soTranThua,
    required this.hieuSo,
    required this.diem,
    required int tongTheVang,
    required int tongTheDo,
  });
}
