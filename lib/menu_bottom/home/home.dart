// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ckc_league/menu_bottom/home/search.dart';
import 'package:ckc_league/menu_bottom/home/notification.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  String access_token = '';
  final String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';
  final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  List<String> ngayGanNhat = [];
  List<String> listThoiGian = [];
  List<String> listNgay = [];
  List<String> listTenGiaiDau = [];
  List<String> listTenDoiBong1 = [];
  List<String> listTenDoiBong2 = [];
  List<String> listLogoDoiBong1 = [];
  List<String> listLogoDoiBong2 = [];
  List<String> listDiaDiem = [];
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
    await getTranDauSapDienRa();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
  }

  @override
  void dispose() {
    // Hủy bỏ hẹn giờ, ngừng lắng nghe callback, và dừng các hoạt động khác
    // ...

    super.dispose();
  }

  List<int> getThongTinInt(
      List<dynamic> data, List<Object> listID, String loai) {
    List<Object> objectList = listID.map((id) {
      int index = data.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        return data[index][loai] as int;
      }
      return '';
    }).toList();
    List<int> intList = objectList.map((object) => object as int).toList();
    return intList;
  }

  List<String> getThongTinString(
      List<dynamic> data, List<Object> listID, String loai) {
    List<Object> objectList = listID.map((id) {
      int index = data.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        return data[index][loai].toString();
      }
      return '';
    }).toList();
    List<String> intList =
        objectList.map((object) => object.toString()).toList();
    return intList;
  }

  Future<void> getTranDauSapDienRa() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(apiLichTD), headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> results = jsonData['data'];

      // Lấy ra 3 ngày gần nhất
      listNgay = results
          .where((item) =>
              item['trang_thai_tran_dau'] == 0 &&
              item['ngay_dien_ra'] != 'null')
          .map((item) => item['ngay_dien_ra'].toString())
          .toList();

      List<DateTime> parsedDates = listNgay
          .map((dateString) => DateFormat('d/M/yyyy').parse(dateString))
          .toList();
      parsedDates.sort(
          (a, b) => a.difference(now).abs().compareTo(b.difference(now).abs()));
      parsedDates.sort((a, b) => a.compareTo(b));

      if (listNgay.length < 3) {
        ngayGanNhat = parsedDates
            .sublist(0, listNgay.length)
            .map((date) => DateFormat('d/M/yyyy').format(date))
            .toList();
      } else {
        ngayGanNhat = parsedDates
            .sublist(0, 3)
            .map((date) => DateFormat('d/M/yyyy').format(date))
            .toList();
      }

      // Lấy ID trận đấu
      List<Object> listIDTranDau = ngayGanNhat.map((ngayDienRa) {
        int index =
            results.indexWhere((item) => item['ngay_dien_ra'] == ngayDienRa);
        if (index >= 0) {
          return results[index]['id'] as int;
        }
        return '';
      }).toList();

      // Lấy ID các thông tin
      List<int> listIDGiaiDau =
          getThongTinInt(results, listIDTranDau, 'giai_dau_id');
      List<int> listIDDoiBong1 =
          getThongTinInt(results, listIDTranDau, 'doi_bong_1_id');
      List<int> listIDDoiBong2 =
          getThongTinInt(results, listIDTranDau, 'doi_bong_2_id');

      // Lấy tên của các thông tin
      listTenGiaiDau
          .addAll(await getListTen(listIDGiaiDau, apiGiaiDau, 'ten_giai_dau'));
      listTenDoiBong1
          .addAll(await getListTen(listIDDoiBong1, apiDoiBong, 'ten_doi_bong'));
      listTenDoiBong2
          .addAll(await getListTen(listIDDoiBong2, apiDoiBong, 'ten_doi_bong'));
      listLogoDoiBong1
          .addAll(await getListTen(listIDDoiBong1, apiDoiBong, 'logo'));
      listLogoDoiBong2
          .addAll(await getListTen(listIDDoiBong2, apiDoiBong, 'logo'));
      listThoiGian = getThongTinString(results, listIDTranDau, 'thoi_gian');
      listDiaDiem = getThongTinString(results, listIDTranDau, 'dia_diem');
      // Load dữ liệu lên màn hình
      setState(() {
        listTenGiaiDau = listTenGiaiDau;
        listTenDoiBong1 = listTenDoiBong1;
        listTenDoiBong2 = listTenDoiBong2;
        listLogoDoiBong1 = listLogoDoiBong1;
        listLogoDoiBong2 = listLogoDoiBong2;
        listThoiGian = listThoiGian;
        listDiaDiem = listDiaDiem;
        ngayGanNhat = ngayGanNhat;
        isLoading = false;
      });
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<List<String>> getListTenGiaiDau(List<int> idGiaiDau) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiGiaiDau), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> GiaiDauData = jsonData['data'];
    List<String> listTenGD = idGiaiDau.map((id) {
      int index = GiaiDauData.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        return GiaiDauData[index]['ten_giai_dau'].toString();
      }
      return '';
    }).toList();
    return listTenGD;
  }

  Future<List<String>> getListTen(
      List<int> listID, String api, String loai) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(api), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> Data = jsonData['data'];
    List<String> listTen = listID.map((id) {
      int index = Data.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        return Data[index][loai].toString();
      }
      return '';
    }).toList();
    return listTen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFA011129),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
        title: const Text(
          'Trang chủ',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: onNotification,
            icon: const Icon(Icons.notifications_rounded),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFA011129),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CarouselSlider.builder(
                  itemCount: newsTitles.length,
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return GestureDetector(
                      onTap: () {
                        _launchURL(newsUrls[index]);
                      },
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Image.asset(
                              newsImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.black54,
                              child: Text(
                                newsTitles[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Trận đấu sắp diễn ra',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ) // Widget loading
                          : (ngayGanNhat.isEmpty)
                              ? const Center(
                                  child: Text(
                                    'Chưa có lịch thi đấu',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: ngayGanNhat.length,
                                  itemBuilder: (context, index) {
                                    return (listNgay[index] == 'null' ||
                                            listThoiGian[index] == 'null')
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: FractionallySizedBox(
                                              widthFactor: 1,
                                              child: SizedBox(
                                                height: 150,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsetsGeometry>(
                                                            EdgeInsets.zero),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    textStyle:
                                                        MaterialStateProperty
                                                            .all<TextStyle>(
                                                      const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    shadowColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Container(
                                                          height: 30,
                                                          width: 300,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .green[200],
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                              listTenGiaiDau[
                                                                  index]),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 25),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(listTenDoiBong1[
                                                              index]),
                                                          Image.asset(
                                                            listLogoDoiBong1[
                                                                index],
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                          const SizedBox(
                                                              width: 3),
                                                          Column(
                                                            children: [
                                                              Text(listThoiGian[
                                                                  index]),
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
                                                              Text(ngayGanNhat[
                                                                  index]),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              width: 3),
                                                          Image.asset(
                                                            listLogoDoiBong2[
                                                                index],
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                          Text(listTenDoiBong2[
                                                              index]),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                              width: 3),
                                                          Text(
                                                            listDiaDiem[index],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<String> newsUrls = [
    'https://vnexpress.net/the-thao',
    'https://www.24h.com.vn/bong-da-c48.html',
    'https://vietnamnet.vn/the-thao/bong-da-quoc-te',
    'https://thethao247.vn/world-cup/457-dan-em-than-thiet-len-tieng-cho-rang-messi-van-co-the-thi-dau-world-cup-2026-d290011.html',
  ];

  final List<String> newsTitles = [
    'Yaya Toure: "Barca thế hệ 2009 mạnh hơn Man City"',
    'Trực tiếp bóng đá nữ Việt Nam - New Zealand: "Thuốc thử" quan trọng, chờ gây sốc chủ nhà',
    'Mbappe được yêu cầu rời PSG, lộ sự thật phũ phàng',
    '"Đàn em thân thiết" lên tiếng, cho rằng Messi vẫn có thể thi đấu World Cup 2026',
  ];

  final List<String> newsImages = [
    'images/banner.png',
    'images/banner1.jpg',
    'images/banner3.jpg',
    'images/banner4.jpg',
  ];
  //Navigator
  void onSearch() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Search()),
        );
      },
    );
  }

  void onNotification() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Notification_Scren()),
        );
      },
    );
  }
}
