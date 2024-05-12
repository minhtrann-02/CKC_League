// ignore_for_file: unused_import

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/menu_bottom/home/notification.dart';
import 'package:ckc_league/menu_bottom/home/search.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/add_team.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/detail_team.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
class My_team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => My_team_State();
}

class My_team_State extends State<My_team> {
  String quality = '';
  int teamCount = 0;
  int nguoiquanlyid = 0;
  String access_token = '';
  bool hasTeams = false; // Biến để kiểm tra số đội
  late List data;
    List dataSL = [];
  List<Data> dataList = []; // Khởi tạo một mảng mới
  List<Data> dataListSL = [];
  int idDoiBong =0;
  int? totalPlayer = 0;
  int itemCount = 0;
  int soLuongDoi = 0;
  int idNguoiQL = 0;
  int idTaiKhoan = 0;
  String logoSL = '';
  String tenDB = '';
  int khoaSL = 0;
  int IDTV = 0;
  String lopSL = '';
void getSLPlayer() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idDoiBong = prefs.getInt('idDoiBong')??0;
    print(nguoiquanlyid);
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
       print('item Count là: $itemCount');
       prefs.setInt('itemCount',itemCount);
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

void fetchPlayer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  idTaiKhoan = prefs.getInt('ID') ?? 0;
  print('id Tai khoan : $idTaiKhoan');
  String url = 'http://10.0.2.2:8000/api/auth/players';
  final headers = {
    'User-Agent': 'MyApp/1.0',
    'Authorization': 'Bearer $access_token'
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<dynamic> data = responseData['data'];

    // Lọc danh sách theo cột 'nguoi_quan_ly_id'
    final filteredDataList =
        data.where((item) => item['id_tai_khoan'] == idTaiKhoan).toList();

    // In tất cả giá trị id thỏa điều kiện lên console
    for (var item in filteredDataList) {
   var IDTV = item['doi_bong_id']; 
       print('item id là: $IDTV'); //biến này lấy đúng 
   
          prefs.setInt('IDTV1',IDTV);
   
    }
fetchData(IDTV);
  } else {
print('Lỗi ${response.statusCode}');
  }
}


//  Future<void> updateSL() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     idDoiBong = prefs.getInt('idDoiBong') ?? 0;//
//     soLuongDoi = prefs.getInt('itemCount')??0;
//     lopSL = prefs.getString('lopSL')??'';
//     tenDB = prefs.getString('tenDB')??'';
//     logoSL = prefs.getString('logoSL')??'';
//      khoaSL = prefs.getInt('khoaSL')??0;
//       idNguoiQL = prefs.getInt('nguoiquanlyidSL')??0;
//     access_token = prefs.getString('accessToken') ?? '';
//     print('idDoiBong: $idDoiBong');
//     print('1:$soLuongDoi');
//     print('2:$khoaSL');
//    print('3:$idNguoiQL');
//     print('4:$lopSL');
//      print('5:$soLuongDoi');
//       print('6:$tenDB');
//        print('7:$logoSL');
//     print('Token trong hàm update: $access_token');
//     final url =
//         'http://10.0.2.2:8000/api/auth/football/$idDoiBong?token=$access_token'; // Thay đổi URL của API tương ứng
//     final headers = {'Content-Type': 'application/json'};
//     // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
//     final requestData = {
//     'nguoi_quan_ly_id': idNguoiQL,//sai 
//     'khoa': khoaSL,
//     'lop':lopSL,
//     'sl_thanh_vien':soLuongDoi,
//     'ten_doi_bong':tenDB,
//     'logo':logoSL,
//     'so_diem':0,
//     'so_tran_dau':0,
//     'so_tran_thang':0,
//     'so_tran_thua':0,
//     'so_ban_thang':0,
//     'so_ban_thua':0,
//     'trang_thai_dang_ky':0,

//     };
//     final String requestBody = json.encode(requestData);

//     final client = HttpClient()
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//     final request = await client.patchUrl(Uri.parse(url));

//     request.headers.contentType = ContentType.json;
//     request.headers.add('User-Agent', 'MyApp/1.0');
//     request.write(jsonEncode(requestData));

//     final response = await request.close();
//   print(response.statusCode);
//     if (response.statusCode == HttpStatus.ok) {
//       print('Cập nhật sl đội thành công!');
//     } else {
//       // Xử lý lỗi khi cập nhật không thành công
//       print('Cập nhật số lượng không thành công');
//     }
//   }

  void fetchData(IDTV) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
     nguoiquanlyid = prefs.getInt('ID') ?? 0;
     IDTV  = prefs.getInt('IDTV1')??0;
     print('IDTV là: $IDTV');//sai
    final String url =
        'http://10.0.2.2:8000/api/auth/football?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['data'] != null) {
        for (var item in responseData['data']) {
          Data data = Data.fromJson(item);
          if (data.nguoiQuanLyId == nguoiquanlyid||data.id==IDTV) {
            dataList.add(data);
            print('data là:${data.khoa}');
              print('lớp:${data.lop}');
                 print('tên đội bóng: ${data.tenDoiBong}');
                 logoSL = data.logo!;
                 khoaSL = data.khoa!;
                 tenDB = data.tenDoiBong!;
                 lopSL = data.lop!;
                 idDoiBong =data.id!; 
                 print('logo: $logoSL');
          }
        }
      }
     
      teamCount = dataList.length;
      prefs.setString('logoSL',logoSL);
      prefs.setInt('idDoiBong',idDoiBong);
            prefs.setInt('idDoiBong1',idDoiBong);
        prefs.setString('lopSL',lopSL);
        prefs.setInt('khoaSL',khoaSL);
          prefs.setString('tenDB',tenDB);
      prefs.setInt('nguoiquanlyidSL', nguoiquanlyid);
      prefs.setInt('soLuongDoi',teamCount);
      
      print('Người quản lý ID: $nguoiquanlyid');
      print('Số lượng đội: $teamCount');

      // Cập nhật giá trị số lượng đội bóng để hiển thị trên màn hình
      quality = teamCount.toString();
      hasTeams = teamCount > 0; // Kiểm tra nếu có đội thì hasTeams = true
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    data = [];
    // getData();
      fetchPlayer();
    // fetchData();
  
    getSLPlayer();
    // updateSL();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
            centerTitle: true,
            title: const Text(
              'My Team',
              style: TextStyle(color: Colors.black),
            ),
           
            bottom: TabBar(
              labelColor: Colors.black, // Màu của văn bản được chọn
              unselectedLabelColor:
                  Colors.grey, // Màu của văn bản chưa được chọn
              tabs: [
                Tab(text: 'Đội của tôi'), // Tab "Tất cả"
                Tab(text: 'Khám phá'), // Tab "Đã thu"
              ],
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
            height: 600,
            child: TabBarView(
              children: [
                // Nội dung của trang "Tất cả"
                Center(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10,left:10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green), // Màu nền của button
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // Màu chữ của button
                              ),
                              child: Text('Đã tạo')),
                          // ElevatedButton(
                          //     onPressed: () {},
                          //     style: ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               const Color.fromARGB(255, 235, 235,
                          //                   235)), // Màu nền của button
                          //       foregroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               Colors.black), // Màu chữ của button
                          //     ),
                          //     child: Text('Được phân công')),
                          // ElevatedButton(
                          //     onPressed: () {},
                          //     child: Text('Đang tham gia'),
                          //     style: ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               const Color.fromARGB(255, 235, 235,
                          //                   235)), // Màu nền của button
                          //       foregroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               Colors.black), // Màu chữ của button
                          //     )),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(children: [
                                Text('Số đội',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    )),
                                Text(quality ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))
                              ]),
                            ),
                            Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(teamCount);
                                    if (teamCount == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Add_Team()));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.info, // Icon logout
                                                  color: Colors.blue,
                                                  size: 24,
                                                ),
                                                SizedBox(
                                                    width:
                                                        8), // Khoảng cách giữa Icon và Text
                                                Text(
                                                  'Thông báo',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 16),
                                                Text(
                                                  'Bạn đã có đội rồi!',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                       backgroundColor: Colors.blue,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Text('Thêm',
                                      style: TextStyle(fontSize: 20)),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green), // Màu nền của button
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // Màu chữ của button
                                  )),
                            )
                          ],
                        )),
                    SingleChildScrollView(
                      child: hasTeams
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final team = dataList[index];
                                // Hiển thị container cho từng đội tại đây

                                return Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Detail_Team()),
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              '${team.logo}',
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  team.khoa.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  team.tenDoiBong.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '$itemCount thành viên',
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  team.lop.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text('Chưa có đội nào'),
                            ),
                    ),
                  ],
                )),
                // Nội dung của trang "Đã thu"
                Center(
                  child: Text('ĐANG PHÁT TRIỂN'),
                ),
                // Nội dung của trang "Đã chi"
              ],
            ),
          ))),
    );
  }

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
