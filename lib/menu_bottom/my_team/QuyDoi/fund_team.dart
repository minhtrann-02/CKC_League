import 'package:ckc_league/menu_bottom/my_team/DoiBong/detail_team.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/my_team.dart';
import 'package:ckc_league/menu_bottom/my_team/QuyDoi/transaction.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';

class Fund_Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Fund_Team_State();
}

class Fund_Team_State extends State<Fund_Team> {
  String access_token = '';
  double totalMoney = 0;

  double totalChuaThu = 0;
  double totalDaChi = 0;
  double totalDaThu = 0;
  double totalQuy = 0;
  late List<Data> fieldList = [];
  late List<Data> dataList = [];
  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    String url = 'http://10.0.2.2:8000/api/auth/QuyDoi?token=$access_token';
    final headers = {
      'User-Agent': 'MyApp/1.0',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      setState(() {
        dataList =
            data.map((x) => Data.fromJson(x)).toList(); // quỹ = thu - chi
      });
      for (var data in dataList) {
        if (data.danh_muc == 'Đóng quỹ' && data.trang_thai == '1' ||
            data.danh_muc == 'Giải thưởng' && data.trang_thai == '1' ||
            data.danh_muc == 'Tài trợ' && data.trang_thai == '1') {
          totalDaThu += data.soTienQuy!;
        }

        if (data.danh_muc == 'Sân bãi' ||
            data.danh_muc == 'Ăn uống' ||
            data.danh_muc == 'Dụng cụ, công cụ' ||
            data.danh_muc == 'Phí tham gia giải đấu' ||
            data.danh_muc == 'Thăm hỏi thành viên') {
          totalDaChi += data.soTienQuy!;
        }
        totalMoney = totalDaThu - totalDaChi;
        if (data.trang_thai == '2') {
          totalChuaThu += data.soTienQuy!;
        }
      }
// for(var data in dataList){
//   if(data.trang_thai == 1){

//   }
// }
      print(response.body);
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<void> fetchDaThu() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      access_token = prefs.getString('accessToken') ?? '';
      String url = 'http://10.0.2.2:8000/api/auth/QuyDoi?token=$access_token';
      final headers = {
        'User-Agent': 'MyApp/1.0',
      };
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          dataList = data.map((x) => Data.fromJson(x)).toList();
        });

        final fundList = dataList
            .where((data) =>
                (data.danh_muc == 'Đóng quỹ' ||
                    data.danh_muc == 'Giải thưởng' ||
                    data.danh_muc == 'Tài trợ') &&
                data.trang_thai == '1')
            .toList();

        // Tính tổng số tiền đã thu
        final totalDaThu =
            fundList.fold(0, (sum, data) => sum + data.soTienQuy!);

        // Lọc danh sách giao dịch đã chi
        final fieldList = dataList
            .where((data) =>
                (data.danh_muc == 'Sân bãi' ||
                    data.danh_muc == 'Ăn uống' ||
                    data.danh_muc == 'Dụng cụ, công cụ' ||
                    data.danh_muc == 'Phí tham gia giải đấu' ||
                    data.danh_muc == 'Thăm hỏi thành viên') &&
                data.trang_thai == '1')
            .toList();

        // Tính tổng số tiền đã chi
        final totalDaChi =
            fieldList.fold(0, (sum, data) => sum + data.soTienQuy!);

        // Lọc danh sách giao dịch chưa thu
        final notPaidList =
            dataList.where((data) => data.trang_thai == '2').toList();

        // Tính tổng số tiền chưa thu
        final totalChuaThu =
            notPaidList.fold(0, (sum, data) => sum + data.soTienQuy!);

        // Lọc, tính toán các giá trị tổng hợp tại đây...

        print(response.body);
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: const Text(
            'Quỹ đội',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Detail_Team()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text('TỔNG QUAN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20)),
                ),
                Container(
                  child: Column(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(right: 10),
                                    ),
                                    const Text('Tổng tiền quỹ: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ],
                                ),
                              ),
                              Container(
                                  child: Text('${totalMoney.toString()} VNĐ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ])),
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.green,
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(right: 10),
                                    ),
                                    const Text('Tổng tiền đã thu: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ],
                                ),
                              ),
                              Container(
                                  child: Text('${totalDaThu.toString()} VNĐ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ])),
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(right: 10),
                                    ),
                                    const Text('Tiền đã chi: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ],
                                ),
                              ),
                              Container(
                                  child: Text('${totalDaChi.toString()} VNĐ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ])),
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.blue,
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(right: 10),
                                    ),
                                    const Text('Tiền chưa thu: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ],
                                ),
                              ),
                       
                              Container(
                                  child: Text('${totalChuaThu.toString()} VNĐ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ]))
                  ]),
                ),
                Container(
                  height: 450, //height of TabBarView
                  // decoration: BoxDecoration(
                  //   border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                  // ),
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];

                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    data.tieu_de!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data.danh_muc!),
                                  Text(data.thoi_gian
                                      .toString()), // Hiển thị thời gian tại đây
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    '${data.soTienQuy} VND',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                 color: const Color.fromARGB(255, 228, 228, 228),
                              ),
                                    child: Text(
                                      data.danh_muc == 'Sân bãi' ||
                                              data.danh_muc == 'Ăn uống' ||
                                              data.danh_muc ==
                                                  'Dụng cụ, công cụ' ||
                                              data.danh_muc ==
                                                  'Phí tham gia giải đấu' ||
                                              data.danh_muc ==
                                                  'Thăm hỏi thành viên'
                                          ? 'Đã chi'
                                          : data.trang_thai == '1'
                                              ? 'Đã thu'
                                              : 'Chưa thu',
                                      style: TextStyle(
                                        color: data.danh_muc == 'Sân bãi' ||
                                                data.danh_muc == 'Ăn uống' ||
                                                data.danh_muc ==
                                                    'Dụng cụ, công cụ' ||
                                                data.danh_muc ==
                                                    'Phí tham gia giải đấu' ||
                                                data.danh_muc ==
                                                    'Thăm hỏi thành viên'
                                            ? Colors.red
                                            : data.trang_thai == '1'
                                                ? Colors.green
                                                : Colors.blue,
                                        fontSize: 15,
                                      ),
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
                SizedBox(height:50),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  // color: Colors.blue,
                  child: FractionallySizedBox(
                    widthFactor: 0.99,
                    child: SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Transaction()));
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
                          'THÊM GIAO DỊCH',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
