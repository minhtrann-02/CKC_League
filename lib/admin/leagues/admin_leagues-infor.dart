// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, camel_case_types, avoid_print, unused_import

import 'package:ckc_league/admin/apply_screen.dart';
import 'package:ckc_league/admin/rank_table.dart';
import 'package:ckc_league/menu_bottom/leagues/competition_team/competition-team_screen.dart';
import 'package:ckc_league/menu_bottom/leagues/ranking/ranking_screen.dart';
import 'package:ckc_league/menu_bottom/leagues/schedule/schedule_screen.dart';
import 'package:ckc_league/menu_bottom/leagues/statistic/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/admin_leagues-custom.dart';
import 'custom/admin_leagues-edit.dart';
import 'package:http/http.dart' as http;
import 'admin_leagues-list.dart';

class LeaguesInforAdmin_Screen extends StatefulWidget {
  const LeaguesInforAdmin_Screen({Key? key}) : super(key: key);

  @override
  State<LeaguesInforAdmin_Screen> createState() =>
      _LeaguesInforAdmin_ScreenState();
}

class _LeaguesInforAdmin_ScreenState extends State<LeaguesInforAdmin_Screen> {
  String? ten_giai_dau = '';
  String? tenHinhThuc = '';
  String? ban_to_chuc = '';
  String? san_dau = '';
  int? so_vong_dau = 0;
  int? so_tran_da_dau = 0;
  int? so_luong_doi_bong = 0;
  String? ngay_bat_dau = '';
  String? ngay_ket_thuc = '';
  int? id = 0;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lấy dữ liệu từ SharedPreferences
    id = prefs.getInt('id');
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaguesList()),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadData();
        },
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                // SizedBox(height: 20,),
                Image.asset(
                  'images/ckcbanner2.jpg',
                  height: 300,
                ),
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
                                    tenHinhThuc!,
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
                      const SizedBox(height: 30),
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
                                onPressed: Apply,
                                child: const Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined),
                                    SizedBox(width: 10),
                                    Text(
                                      'Danh sách đăng ký',
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
                                    Icon(Icons.stacked_bar_chart_outlined),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
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
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: onCustom,
                              child: const Row(
                                children: [
                                  Icon(Icons.settings),
                                  SizedBox(width: 10),
                                  Text(
                                    'Tùy chỉnh',
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
                                    so_vong_dau.toString(),
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
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  void Apply() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Apply_Screen()),
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

  void onCustom() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeaguesCustom()),
        );
      },
    );
  }
}
