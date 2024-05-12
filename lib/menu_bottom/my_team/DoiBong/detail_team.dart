// ignore_for_file: unused_import

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/menu_bottom/home_page.dart';
import 'package:ckc_league/menu_bottom/leagues/statistic/statistic_screen.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/thongke.dart';
import 'package:ckc_league/menu_bottom/my_team/QuyDoi/fund_team.dart';
import 'package:ckc_league/menu_bottom/my_team/players_screen.dart';
import 'package:ckc_league/menu_bottom/profile/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Detail_Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Detail_Team_State();
}

class Detail_Team_State extends State<Detail_Team> {
  String access_token = '';
   int nguoiquanlyid = 0;
     late List<Data> dataList = [];
   String logo = 'images/logo2.png';
  late List data;
  String teamName = '';
  String lop = '';
  String hoten = '';
  String sdt = '';
  int slthanhvien =0;
  int idDoiBong = 0;
    int itemCount = 0;
      List dataSL = [];
    List<Data> dataListSL = [];
   List<Data> teamData = []; // Khởi tạo một mảng mới
   int IDDoiTruong = 0;
   void getIDQL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      access_token = prefs.getString('accessToken') ?? '';
          idDoiBong = prefs.getInt('idDoiBong')??0;
      nguoiquanlyid = prefs.getInt('nguoiquanlyid') ?? 0;
  String apiUrl = 'http://10.0.2.2:8000/api/auth/football';
  final headers = {'User-Agent': 'MyApp/1.0','Authorization': 'Bearer $access_token'};
  // Gửi yêu cầu HTTP để nhận dữ liệu từ API
  final response = await http.get(Uri.parse(apiUrl), headers: headers);

  if (response.statusCode == 200) {
    // Giải mã dữ liệu JSON
 final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách theo cột 'nguoi_quan_ly_id'
      final filteredDataList = data
          .where((item) => item['id'] == idDoiBong)
          .toList();

      setState(() {
        dataList = filteredDataList.map((x) => Data.fromJson(x)).toList();
      });

         for(var item in dataList){
          print('ID NGUOI QUAN LY LA: ${item.nguoiQuanLyId}');
          IDDoiTruong = item.nguoiQuanLyId!;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('IDDoiTruong',IDDoiTruong);
         }

  } else {
    // Xử lý lỗi khi gọi API không thành công
    print('Error: ${response.statusCode}');
  }
}
 void getTenQL() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  IDDoiTruong = prefs.getInt('IDDoiTruong')??0;
  final String url = 'http://10.0.2.2:8000/api/auth/Login/$IDDoiTruong?token=$access_token';
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(url), headers: headers);
  print(response.statusCode);
  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    final dynamic data = responseData['data'];

    if (data != null) {
      Data newData = Data.fromJson(data);
      setState(() {
        dataList = [newData];
      });
      print('hàm getTenQL: $dataList');
      for (var data in dataList) {
  print('Tên: ${data.hoten}');
   hoten = data.hoten!;
   sdt = data.sdt!;
   prefs.setString('sdtQL',sdt);
  prefs.setString('TenNguoiQL',hoten);
  print('Tuổi: ${data.loaiTaiKhoan}');
  // print('Địa chỉ: ${data.diaChi}');
  // và tiếp tục với các thuộc tính khác
}

    } else {
      throw Exception('Invalid data format');
    }
  } else {
    throw Exception('Failed to load data');
  }
}


void getSLPlayer() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idDoiBong = prefs.getInt('idDoiBong')??0;
      nguoiquanlyid = prefs.getInt('ID') ?? 0;
    print('nguoiquanlyid trong hàm getSL :$nguoiquanlyid');
    String url = 'http://10.0.2.2:8000/api/auth/players';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataSL = responseData['data'];

      // Lọc danh sách theo cột 'nguoi_quan_ly_id'
      final filteredDataList =
          dataSL.where((item) => item['doi_bong_id'] == idDoiBong).toList();

      setState(() {
        dataListSL = filteredDataList.map((x) => Data.fromJson(x)).toList();
       
      });
       itemCount = dataListSL.length; 
      for (var dataSL in dataListSL) {
        print(dataSL
            .ten_cau_thu); // In ra giá trị thuộc tính 'id' của mỗi phần tử trong mảng
        print(dataSL
            .so_ao); // In ra giá trị thuộc tính 'ten_doi_bong' của mỗi phần tử trong mảng
      }
    } else {
     print('Load failed');
    }
  }
  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('nguoi quan ly: $nguoiquanlyid');
    String url = 'http://10.0.2.2:8000/api/auth/football';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách theo cột 'nguoi_quan_ly_id'
      final filteredDataList = data
          .where((item) => item['id'] == idDoiBong)
          .toList();

      setState(() {
        dataList = filteredDataList.map((x) => Data.fromJson(x)).toList();
      });
 teamName = dataList[0].tenDoiBong!;
          logo = dataList[0].logo!;
         
           lop = dataList[0].lop!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      prefs.setInt('idDoiBong', idDoiBong!);
      prefs.setString('logoTeam', logo!);
      prefs.setString('lop', lop!);
      prefs.setString('teamName', teamName!);
        setState(() {
  
       
         
    });
      print(dataList);
      print(dataList[0].id);
      print(dataList[0].tenDoiBong);
    } else {
      throw Exception('Failed to load data');
    }
  }


 @override
  void initState() {
    super.initState();
    data = [];
    fetchData();
    getSLPlayer();
    getTenQL();
    getIDQL();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  width: 420,
                  height: 380,
                  child: Image.asset(
                    'images/background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 420,
                  height: 380,
                  color: Colors.black
                      .withOpacity(0.3), // Điều chỉnh độ mờ của hình ảnh
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home_Page()),
              );
                              },
                              icon: Icon(Icons.navigate_before,
                                  color: Colors.white, size: 40)),
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.upload,
                                        color: Colors.white, size: 30)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Text('ĐỘI ĐẤU',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                              Container(
                                child: Text(teamName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          Container(
                              child: Image.asset('$logo',
                                  width: 120, height: 120))
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Người liên hệ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text(hoten,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10)),
                            Divider(
                              height: 1,
                              color: Colors.white60,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SĐT',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text(sdt,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 10, top: 10)),
                            Divider(
                              height: 1,
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Lớp',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text(lop,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10)),
                            Divider(
                              height: 1,
                              color: Colors.white60,
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Thành viên',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Text(itemCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              //     Container(
              //       color: Colors.black
              //           .withOpacity(0.3), // Điều chỉnh độ mờ của hình ảnh
              //     ),
              //   ],
              // )
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 50,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Players_Screen()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 211, 211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.supervised_user_circle_outlined, size: 30),
                          Text('Thành viên',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                    InkWell(
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => thongKe()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 211, 211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.apps_outlined, size: 30),
                        Text('Thống kê',
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),),
                  
                    InkWell(
                    onTap: () {
                         Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Fund_Team(),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 211, 211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.attach_money_sharp, size: 30),
                        Text('Quỹ đội ',
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),),
                    InkWell(
                    onTap: () {
                     
                 
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 211, 211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.settings, size: 30),
                        Text('Tuỳ chỉnh',
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])))
                ],
              )),
            ]),
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Text('ĐỒNG PHỤC',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Image.asset('images/homekit.png',
                        height: 150, width: 120),
                  ),
                  Container(
                    child: Image.asset('images/thirdkit.png',
                        height: 150, width: 120),
                  ),
                  Container(
                    child: Image.asset('images/gkkit.png',
                        height: 150, width: 120),
                  )
                ],
              )
            ],
          )),
        ],
      )),
    );
  }
}
