// ignore_for_file: avoid_print, unused_import, unused_local_variable

import 'package:ckc_league/menu_bottom/leagues/add_player_GD.dart';
import 'package:ckc_league/menu_bottom/leagues/infor-leagues_srceen.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/add_players.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';
import 'dart:io';

class Pick_Players extends StatefulWidget {
  @override
  State<Pick_Players> createState() => Pick_Players_State();
}

class Pick_Players_State extends State<Pick_Players> {
  late List<Data> dataList = [];
  List<bool> isChecked = []; // Danh sách lưu trạng thái checkbox
  bool selectAll = false;
  int selectedCount = 0;
  String access_token = '';
  int nguoiquanlyid = 0;
  int? idDoiBong = 0;
  int? slthanhvien = 0;
  String idGiaiDau = '';
  String teamName = '';
  String lop = '';
  String logo = '';
  int khoa = 0;
  List<int> selectedPlayerIDs =
      []; // Danh sách lưu trữ ID của các cầu thủ đã chọn

  // Cập nhật danh sách ID cầu thủ khi checkbox được thay đổi
  void updateSelectedPlayerIDs(int playerID, bool isChecked) {
    if (isChecked) {
      // Nếu checkbox được chọn, thêm ID vào danh sách
      selectedPlayerIDs.add(playerID);
    } else {
      // Nếu checkbox bị bỏ chọn, loại bỏ ID khỏi danh sách
      selectedPlayerIDs.remove(playerID);
    }
  }

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id') ?? 0;
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    nguoiquanlyid = prefs.getInt('ID') ?? 0;
    teamName = prefs.getString('teamName') ?? '';
    slthanhvien = prefs.getInt('itemCount') ?? 0;
    lop = prefs.getString('lop') ?? '';
    logo = prefs.getString('logoTeam') ?? '';
    khoa = prefs.getInt('khoa') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('Các giá trị trong hàm update là:');
    print('iDDoiBong la :$idDoiBong');
    print('nguoiquanlyid: $nguoiquanlyid');
    print('teamName: $teamName');
    print('lop:$lop');
    print('logo:$logo');
    print('khoa:$khoa');

    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/football/$idDoiBong?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
    final requestData = {
      'nguoi_quan_ly_id': nguoiquanlyid.toString(),
      'khoa': khoa.toString(),
      'lop': lop.toString(),
      'ten_doi_bong': teamName.toString(),
      'sl_thanh_vien': slthanhvien.toString(),
      'logo': logo.toString(),
      'so_diem': '0',
      'so_tran_dau': '0',
      'so_tran_thang': '0',
      'so_tran_thua': '0',
      'so_ban_thang': '0',
      'so_ban_thua': '0',
      'trang_thai_dang_ky': 2,
    };
    final String requestBody = json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.putUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();
    print(response.statusCode);
    if (response.statusCode == HttpStatus.ok) {
      print('Cập nhật trạng thái đăng ký thành công');
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to cập nhật trạng thái');
    }
  }

  void validateSelectedCount() {
    if (selectedCount < 12 || selectedCount > 25) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning, // Icon logout
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
          content: Text('Bạn phải chọn ít nhất 12 và nhiều nhất là 25 thành viên'),
          actions: [
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
            
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
    } else {
      printSelectedPlayerIDs();
      postPlayers(); // In danh sách ID của cầu thủ đã chọn lên console
      applyTourament();
    }
  }

  void applyTourament() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getString('IDGiaiDau') ?? '';
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    print('Id giải đấu là: $idGiaiDau');
    DateTime currentDate = DateTime.now();
    String formattedDate =
        '${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year} ${currentDate.hour.toString().padLeft(2, '0')}:${currentDate.minute.toString().padLeft(2, '0')}:${currentDate.second.toString().padLeft(2, '0')}'; // Định dạng ngày, tháng, năm, giờ, phút và giây
    print('Ngay dang ky: ${formattedDate.toString()}');
    print('ID đội bóng: $idDoiBong');
    final String url =
        'http://10.0.2.2:8000/api/auth/DangKyGiai?token=$access_token';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      // 'Authorization': 'Bearer $access_token'
    };

    final response = await http.post(Uri.parse(url),
        body: {
          'doi_bong_id': idDoiBong.toString(),
          'giai_dau_id': idGiaiDau.toString(),
          'ngay_dang_ky': formattedDate.toString(),
          'trang_thai_dang_ky': '2',
          'noi_dung': 'Đã đăng ký',
          'trang_thai_tb': '-1',
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Đăng ký thành công ');
        showSuccessDialog(context);
        updateData();
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  void postPlayers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getString('IDGiaiDau') ?? '';
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    print('Id giải đấu là: $idGiaiDau');

    print('ID đội bóng: $idDoiBong');
    final String url = 'http://10.0.2.2:8000/api/auth/CauThuTrongGiaiDau';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };

    for (int playerID in selectedPlayerIDs) {
      final response = await http.post(Uri.parse(url),
          body: {
            'id_giai_dau': idGiaiDau.toString(),
            'id_cau_thu': playerID
                .toString(), // Sử dụng giá trị từ mảng selectedPlayerIDs
            'so_tran_tham_gia': '0',
            'so_ban_thang': '0',
            'so_the_vang': '0',
            'so_the_do': '0'
          },
          headers: headers);
      print(response.statusCode);

      if (response.statusCode == 201) {
        print('Thêm cầu thủ chọn vào giải thành công');
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  void printSelectedPlayerIDs() {
    print("Danh sách ID cầu thủ đã chọn:");
    for (int playerID in selectedPlayerIDs) {
      print(playerID);
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle, // Icon logout
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text('Đăng ký thành công'),
          actions: [
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nguoiquanlyid = prefs.getInt('ID') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print(nguoiquanlyid);
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
          .where((item) => item['nguoi_quan_ly_id'] == nguoiquanlyid)
          .toList();

      setState(() {
        dataList = filteredDataList.map((x) => Data.fromJson(x)).toList();
        isChecked = List.filled(
            dataList.length, false); // Khởi tạo danh sách trạng thái checkbox
      });
      if (dataList.isNotEmpty) {
        idDoiBong = dataList[0].id;
        teamName = dataList[0].tenDoiBong!;
        logo = dataList[0].logo!;
        khoa = dataList[0].khoa!;
        lop = dataList[0].lop!;
      } else {
        print('Chưa có cầu thủ');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('idDoiBong', idDoiBong!);
      prefs.setString('logoTeam', logo!);
      prefs.setString('lop', lop!);
      prefs.setString('teamName', teamName!);
      prefs.setInt('khoa', khoa!);
      // print(dataList);
      // print(dataList[0].id);
      // print(dataList[0].tenDoiBong);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    print(nguoiquanlyid);
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
          data.where((item) => item['doi_bong_id'] == idDoiBong).toList();

      setState(() {
        dataList = filteredDataList.map((x) => Data.fromJson(x)).toList();
        isChecked = List.filled(
            dataList.length, false); // Khởi tạo danh sách trạng thái checkbox
      });
      for (var data in dataList) {
        print(data.ten_cau_thu);
        print(data.so_ao);
        print(data
            .avatar); // In ra giá trị thuộc tính 'avatar' của mỗi phần tử trong mảng
      }
    } else {
      // throw Exception('Failed to load data');
      print('Lỗi ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chọn thành viên', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchData();
                fetchPlayer();
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: const Color.fromARGB(255, 220, 217, 217),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thành viên đã chọn',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        Text(
                          selectedCount.toString(),
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Thành viên yêu cầu',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        Row(
                          children: [
                            Text(
                              '12',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Icon(Icons.chevron_right),
                            Text(
                              '25',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Add_Players_GD(),
                            ),
                          );
                        },
                        child: Text('THÊM THÀNH VIÊN',
                            style: TextStyle(fontSize: 15)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Màu nền của button
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Màu chữ của button
                        ),
                      ),
                    ),
                    Container(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text('HỦY ĐĂNG KÝ', style: TextStyle(fontSize: 15)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red), // Màu nền của button
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Màu chữ của button
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vận động viên',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        print('so luong ct là: ${dataList.length}');
                        if (dataList.length == 1) {
                          // Trường hợp không có giá trị nào trong dataList
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Chưa có thành viên',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else {
                          var data = dataList[index];
                          return Container(
                            color: const Color.fromARGB(255, 224, 224, 224),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Detail_Player(),
                                    //   ),
                                    // );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              child: Checkbox(
                                                value: isChecked[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked[index] =
                                                        value ?? false;
                                                    if (isChecked[index]) {
                                                      selectedCount++;
                                                    } else {
                                                      selectedCount--;
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                data.avatar ??
                                                    'images/user1.png',
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.ten_cau_thu ??
                                                        '', // Sử dụng giá trị từ dataList
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    data.vi_tri ??
                                                        '', // Sử dụng giá trị từ dataList
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    data.so_ao.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Container(
                                      //   child: IconButton(
                                      //     icon: Icon(Icons.edit),
                                      //     onPressed: () {},
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        'Bằng việc nhấn nút "HOÀN THÀNH", đồng nghĩa bạn đã đọc và đồng ý với Điều lệ của giải đấu',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(
                      color: Colors.black87, // Màu sắc của đường gạch ngang
                      thickness: 1, // Độ dày của đường gạch ngang
                      height:
                          10, // Khoảng cách giữa đường gạch ngang và phần tiếp theo
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectAll,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectAll = value ?? false;
                                      if (selectAll) {
                                        selectedCount = dataList.length;
                                        for (int i = 0;
                                            i < isChecked.length;
                                            i++) {
                                          isChecked[i] = true;
                                          selectedPlayerIDs.add(dataList[i]
                                              .id!); // Thêm ID của cầu thủ vào danh sách
                                        }
                                      } else {
                                        selectedCount = 0;
                                        for (int i = 0;
                                            i < isChecked.length;
                                            i++) {
                                          isChecked[i] = false;
                                          selectedPlayerIDs.remove(dataList[i]
                                              .id!); // Loại bỏ ID của cầu thủ khỏi danh sách
                                        }
                                      }
                                    });
                                  },
                                ),
                                Text('Chọn tất cả',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              validateSelectedCount();
                            },
                            child: Text(
                              'HOÀN THÀNH',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
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
  }
}
