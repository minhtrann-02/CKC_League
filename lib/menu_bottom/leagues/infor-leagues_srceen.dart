// ignore_for_file: non_constant_identifier_names, unused_import
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/rank_table.dart';
import 'package:ckc_league/menu_bottom/home_page.dart';
import 'package:ckc_league/menu_bottom/leagues/leagues_screen.dart';
import 'package:ckc_league/menu_bottom/leagues/pick_player.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/my_team.dart';
import 'package:flutter/material.dart';
import 'competition_team/competition-team_screen.dart';
import 'ranking/ranking_screen.dart';
import 'schedule/schedule_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'statistic/statistic_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class InforTouament extends StatefulWidget {
  const InforTouament({Key? key}) : super(key: key);

  @override
  State<InforTouament> createState() => _InforTouamentState();
}

class _InforTouamentState extends State<InforTouament> {
  String? ten_giai_dau = '';
  bool hasMatchingValue = false;
  String? hinh_thuc_dau_id = '';
  String? ban_to_chuc = '';
  int idNguoiQL = 0;
  String? san_dau = '';
  String? so_vong_dau = '';
  int idTeam = 0;
  String? so_tran_da_dau = '';
  int? so_luong_doi_bong = 0;
  bool isActive = false;
  bool showBottomBar = true;
  String access_token = '';
  String? ngay_bat_dau = '';
  String? ngay_ket_thuc = '';
  String idGiaiDau = '';
  int slDoiBong = 0;
  int soTranDaDau = 0;
  void getSoTranDaDau() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getString('IDGiaiDau') ?? '';
    String url = 'http://10.0.2.2:8000/api/auth/GiaiDau?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      int parsedIdGiaiDau = int.parse(idGiaiDau);
      // Lặp qua từng đối tượng trong danh sách data
      for (var item in data) {
        if (item['id'] == parsedIdGiaiDau) {
          // Cập nhật giá trị slDoiBong
          slDoiBong = item['so_luong_doi_bong'];

          soTranDaDau = item['so_tran_da_dau'];
          // In giá trị slDoiBong
          print('slDoiBong: $slDoiBong');
          break; // Dừng vòng lặp khi tìm thấy giá trị trùng khớp
        }
        prefs.setInt('sl', slDoiBong);
      }
      if (soTranDaDau > 0) {
        showBottomBar = false;
      }
      setState(() {
        getSLDoiThamGia();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void setActiveBtn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getString('IDGiaiDau') ?? '';
    String url = 'http://10.0.2.2:8000/api/auth/GiaiDau?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      int parsedIdGiaiDau = int.parse(idGiaiDau);
      // Lặp qua từng đối tượng trong danh sách data
      for (var item in data) {
        if (item['id'] == parsedIdGiaiDau) {
          soTranDaDau = item['so_tran_da_dau'];
          // In giá trị slDoiBong

          break; // Dừng vòng lặp khi tìm thấy giá trị trùng khớp
        }
      }
      if (soTranDaDau > 0) {
        showBottomBar = false;
      }
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getSLDoiThamGia() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getString('IDGiaiDau') ?? '';
    int sl = prefs.getInt('sl') ?? 0;
    String url =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau1?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Chuyển đổi idGiaiDau sang kiểu số nguyên
      int parsedIdGiaiDau = int.parse(idGiaiDau);

      // Đếm số lượng đội tham gia
      int slDoiThamGia = 0;

      // Lặp qua từng đối tượng trong danh sách data
      for (var item in data) {
        if (item['giai_dau_id'] == parsedIdGiaiDau) {
          slDoiThamGia++;
        }
      }
      if (slDoiThamGia == slDoiBong) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.info, // Icon logout
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                  Text(
                    'Thông báo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Đã đủ đội tham dự',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          // Xử lý khi người dùng chọn không đăng xuất ở đây
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.white,
            );
          },
        );
      } else {
        getIDQL();
      }
      // In số lượng đội tham gia
      print('Số lượng đội tham gia: $slDoiThamGia');

      setState(() {
        // Cập nhật UI khi có dữ liệu
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getIDQL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idNguoiQL = prefs.getInt('ID') ?? 0;

    print('ID Người QL trong hàm getIDQL: $idNguoiQL');
    String url = 'http://10.0.2.2:8000/api/auth/football';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Kiểm tra nếu có giá trị trùng khớp
      bool hasMatchingValue = false;

      for (var item in data) {
        if (item['nguoi_quan_ly_id'] == idNguoiQL) {
          hasMatchingValue = true;
          // var IDTV = item['doi_bong_id'];
          // print('item id là: $IDTV');
          // prefs.setInt('IDTV1', IDTV);
          break; // Dừng vòng lặp khi tìm thấy giá trị trùng khớp
        }
      }

      if (hasMatchingValue) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Pick_Players()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.info, // Icon logout
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                  Text(
                    'Thông báo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Chỉ đội trưởng mới được phép đăng ký',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          // Xử lý khi người dùng chọn không đăng xuất ở đây
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.white,
            );
          },
        );
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy dữ liệu từ SharedPreferences
    ten_giai_dau = prefs.getString('ten_giai_dau');
    idNguoiQL = prefs.getInt('ID') ?? 0;
    hinh_thuc_dau_id = prefs.getString('hinh_thuc_dau_id');
    ban_to_chuc = prefs.getString('ban_to_chuc');
    san_dau = prefs.getString('san_dau');
    so_vong_dau = prefs.getString('so_vong_dau');
    so_tran_da_dau = prefs.getString('so_tran_da_dau');
    so_tran_da_dau = prefs.getString('so_tran_da_dau');
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong');
    idTeam = prefs.getInt('idTeam') ?? 0;
    ngay_bat_dau = prefs.getString('ngay_bat_dau');
    ngay_ket_thuc = prefs.getString('ngay_ket_thuc');
    setState(() {});
  }

  Future<bool> getIsActiveFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isActive') ?? false;
  }

  @override
  void initState() {
    super.initState();
    setActiveBtn();
    // getSoTranDaDau();
    // getSLDoiThamGia();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Leagues_Screen()));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home_Page()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset('images/ckcbanner2.jpg'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Tên giải đấu
                    const Text(
                      'GIẢI ĐẤU',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      ten_giai_dau!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    //Thông tin giải đấu
                    Table(
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                'Hình thức',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  hinh_thuc_dau_id!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Gạch ngang giữa các dòng
                        const TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                'Ban tổ chức',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ban_to_chuc!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                'Địa điểm',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  san_dau!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                'Ngày bắt đầu',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ngay_bat_dau!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                'Ngày kết thúc (dự kiến)',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ngay_ket_thuc!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //Quản lý giải đấu
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'QUẢN LÝ GIẢI ĐẤU',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50, // Chiều cao của menu
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: onSchedule,
                              child: const Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    'Lịch thi đấu',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: onRanking,
                              child: const Row(
                                children: [
                                  Icon(Icons.group),
                                  SizedBox(width: 10),
                                  Text(
                                    'Bảng xếp hạng',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: onCompetitonTeam,
                              child: const Row(
                                children: [
                                  Icon(Icons.group),
                                  SizedBox(width: 10),
                                  Text(
                                    'Đội thi đấu',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey.shade300),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: onStatistic,
                            child: const Row(
                              children: [
                                Icon(Icons.align_vertical_bottom_rounded),
                                SizedBox(width: 10),
                                Text(
                                  'Thống kê',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Thống kê tổng quát
                    const SizedBox(height: 25),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'THỐNG KÊ TỔNG QUÁT',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/group.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text(
                                  so_luong_doi_bong.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Đội bóng',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/flag_grey.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text(
                                  so_vong_dau!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Trận đấu',
                                  style: TextStyle(fontSize: 16),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomBar
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: FractionallySizedBox(
                widthFactor: 0.99,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      getSoTranDaDau();
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
                      'ĐĂNG KÝ',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : null, // Đặt giá trị null nếu không muốn hiển thị bottom navigation bar
    );
  }

  void onSchedule() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Schedule_Screen()),
        );
      },
    );
  }

  void onCompetitonTeam() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CompetitionTeam_Screen()),
        );
      },
    );
  }

  void onRanking() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Rank_Screen()),
        );
      },
    );
  }

  void onStatistic() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Statistic_Screen()),
        );
      },
    );
  }
}
