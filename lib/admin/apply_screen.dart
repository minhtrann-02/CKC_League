// ignore_for_file: depend_on_referenced_packages, unused_import, unused_local_variable, use_build_context_synchronously, avoid_print, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:ffi';
import 'dart:io';

import 'package:ckc_league/admin/view_players.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apply_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Apply_Screen_State();
}

class Apply_Screen_State extends State<Apply_Screen> {
  // bool isChecked = false;
  int selectedCount = 0;
  int idGiaiDau = 0;
  String access_token = '';
  List<Data> dataList = [];
  List<Data> dataListDS = [];
  List<int> selectedIds = [];
  List<bool> isChecked = [];
  bool showReasonDialog = true;
  bool showBottomNav = false;
  int countCho = 0;
  int countTuChoi = 0;
  int countDangKy = 0;
  int idDanhSach = 0;
  int selectedDoiBongId = 0;
  int selectedGiaiDauId = 0;
  int doiBongid = 0;
  String selectedRawReason = 'Không đủ thành viên';
// Biến lưu trữ lý do từ chối thô
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      child: Text('Không đủ thành viên'),
      value: 'Không đủ thành viên',
    ),
    DropdownMenuItem(
      child: Text('Đã đủ đội'),
      value: 'Đã đủ đội',
    ),
    DropdownMenuItem(
      child: Text('Thông tin thành viên không hợp lệ'),
      value: 'Thông tin thành viên không hợp lệ',
    ),
  ];

  void showBottomNavigationBar() {
    setState(() {
      showBottomNav = true;
    });
  }

  void onCheckboxChanged(bool value, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    // Kiểm tra giá trị của isChecked[index]
    if (isChecked[index] == value) {
      // Nếu giá trị của isChecked[index] bằng value,
      // tức là checkbox đang được chọn
      // Không thực hiện bất kỳ thay đổi nào và thoát khỏi hàm
      return;
    }

    // Đánh dấu checkbox được chọn
    isChecked[index] = value;

    if (value) {
      // Xóa trạng thái chọn của các checkbox khác
      for (int i = 0; i < isChecked.length; i++) {
        if (i != index) {
          isChecked[i] = false;
        }
      }

      // Cập nhật danh sách ID được chọn
      selectedIds.clear();
      selectedIds.add(dataListDS[index].id!);
      selectedDoiBongId = dataListDS[index].doi_bong_id!;
      selectedGiaiDauId = dataListDS[index].giaiDauId!;
    } else {
      // Xóa trạng thái chọn của checkbox hiện tại
      isChecked[index] = false;
      selectedIds.remove(dataListDS[index].id);
      selectedDoiBongId = 0;
      selectedGiaiDauId = 0;
    }

    // Cập nhật giao diện
    setState(() {});
  });
}


  void printSelectedIds() async {
    print('Các ID đã chọn:');
    for (int i = 0; i < isChecked.length; i++) {
      if (isChecked[i]) {
        idDanhSach = dataListDS[i].id!;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('idDanhSach', idDanhSach);
        print('idDanh sách là: $idDanhSach');
        print(dataListDS[i].id);
      }
    }
  }

  void hideBottomNavigationBar() {
    setState(() {
      showBottomNav = false;
    });
  }

  void dsApply() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
    print('Id giải đấu: $idGiaiDau');
    String url = 'http://10.0.2.2:8000/api/auth/DangKyGiai';
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
          .where((item) =>
              [2, 1, -1].contains(item['trang_thai_dang_ky']) &&
              item['giai_dau_id'] == idGiaiDau)
          .toList();

      setState(() {
        dataListDS = filteredDataList.map((x) => Data.fromJson(x)).toList();
        isChecked = List.filled(
            dataListDS.length, false); // Khởi tạo danh sách trạng thái checkbox
        countCho =
            countStatus(dataListDS, 2); // Tính tổng trạng thái "Đang chờ"
        countDangKy =
            countStatus(dataListDS, 1); // Tính tổng trạng thái "Đã duyệt"
        countTuChoi =
            countStatus(dataListDS, -1); // Tính tổng trạng thái "Từ chối"
      });
      print('Lay danh sach dang ky thanh cong');
      for (var data in dataListDS) {
        print('id doi bong trng data1: ${data.doi_bong_id}');
        print('Tên đội bóng trong data1: ${data.tenDoiBong}');
        print('Ngay dang ky: ${data.ngaydangky}');
        print('Giai dau id: ${data.giaiDauId}');
        print('trang thai: ${data.trangThaiDangKy}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  int countStatus(List<Data> dataList, int status) {
    int count = 0;
    for (var data in dataList) {
      if (data.trangThaiDangKy == status) {
        count++;
      }
    }
    return count;
  }

  void checkDuplicateSelection() {
    for (int i = 0; i < dataListDS.length; i++) {
      if (isChecked[i]) {
        if (dataListDS[i].trangThaiDangKy == 1) {
          print('Trạng thái trong hàm void:${dataListDS[i].trangThaiDangKy}');
          // Trạng thái đã duyệt
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Thông báo'),
              content: Text('Bạn đã duyệt đội này rồi.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return; // Thoát khỏi hàm sau khi hiển thị thông báo
        } else {
          printSelectedIds();
          updateDuyet();
          Navigator.pop(context);
          setState(() {});
        }
      }
    }
  }

// void getTenQL() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     access_token = prefs.getString('accessToken') ?? '';
//     final String url =
//         'http://10.0.2.2:8000/api/auth/login?token=$access_token';
//     final headers = {'User-Agent': 'MyApp/1.0'};
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final List<dynamic> data = responseData['data'];
//       setState(() {
//         dataList = data.map((x) => Data.fromJson(x)).toList();
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
  Color getColorForStatus(int trangThaiDangKy) {
    if (trangThaiDangKy == 1) {
      return Colors.green; // Màu xanh lá
    } else if (trangThaiDangKy == -1) {
      return Colors.red; // Màu đỏ
    } else if (trangThaiDangKy == 2) {
      return Color.fromARGB(255, 255, 230, 0); // Màu vàng
    } else {
      return Colors.black; // Màu mặc định
    }
  }

  String getTextForStatus(int trangThaiDangKy) {
    if (trangThaiDangKy == 1) {
      return 'Đã duyệt';
    } else if (trangThaiDangKy == -1) {
      return 'Từ chối';
    } else if (trangThaiDangKy == 2) {
      return 'Đang chờ';
    } else {
      return 'Không xác định';
    }
  }

  void fetchData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/football?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách theo cột 'doi_bong_id' có trong dataListDS
      final filteredDataList = data
          .where((item) => dataListDS.any((x) => x.doi_bong_id == item['id']))
          .toList();

      // Tạo một danh sách phụ để lưu trữ thứ tự của các phần tử trong dataListDS
      final List<int?> sortOrder =
          dataListDS.map((x) => x.doi_bong_id).toList();

      // Sắp xếp danh sách theo thứ tự của sortOrder
      filteredDataList.sort((a, b) =>
          sortOrder.indexOf(a['id']).compareTo(sortOrder.indexOf(b['id'])));

      setState(() {
        dataList = filteredDataList.map((x) => Data.fromJson(x)).toList();
      });
      print('Data list là: $dataList');
      // print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void postDoiTrongGD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau1?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    print('hi: $access_token');
    final response = await http.post(Uri.parse(url),
        body: {
          'giai_dau_id': selectedGiaiDauId.toString(),
          'doi_bong_id': selectedDoiBongId.toString(),
          'bang_dau': 'null',
          'so_tran_thang': '0',
          'so_tran_thua': '0',
          'so_tran_hoa': '0',
          'tong_ban_thang': '0',
          'tong_ban_thua': '0',
          'so_the_vang': '0',
          'so_the_do': '0'
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm đội vào giải đấu thành công ');
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  Future<void> updateDuyet() async {
    print('doi_bong_id: $selectedDoiBongId');
    print('giai_dau_id: $selectedGiaiDauId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDanhSach = prefs.getInt('idDanhSach') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    print('id danh sách là: $idDanhSach');
    final url =
        'http://10.0.2.2:8000/api/auth/DangKyGiai/$idDanhSach?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
    final requestData = {
      'trang_thai_dang_ky': '1',
      'noi_dung': 'Thành công',
      'trang_thai_tb': '-1',
    };
    final String requestBody = json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.patchUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();
    print(response.statusCode);
    if (response.statusCode == HttpStatus.ok) {
      postDoiTrongGD();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined, // Icon logout
                    color: Colors.green,
                    size: 24,
                  ),
                  SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                  Text(
                    'Thành công',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              content: Text('Duyệt thành công'),
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
                   backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              ]);
        },
      );
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to update data');
    }
  }

  Future<void> updateTuChoi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDanhSach = prefs.getInt('idDanhSach') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    print('id danh sách là: $idDanhSach');
    print('Noi dung tu choi la: $selectedRawReason');
    final url =
        'http://10.0.2.2:8000/api/auth/DangKyGiai/$idDanhSach?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
    final requestData = {
      'trang_thai_dang_ky': '-1',
      'noi_dung': selectedRawReason,
      'trang_thai_tb': '-1',
    };
    final String requestBody = json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.patchUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();
    print(response.statusCode);
    if (response.statusCode == HttpStatus.ok) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning_rounded, // Icon logout
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                  Text(
                    'Từ chối',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: Text('Từ chối thành công'),
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
                )
              ]);
        },
      );
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    super.initState();
    dsApply();
    fetchData1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Danh sách đăng ký', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  dsApply();
                  fetchData1();
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.black),
            ),
          ],
        ),
        bottomNavigationBar: showBottomNav
            ? BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
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
                                  content: Text('Bạn muốn duyệt đội này?'),
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
                                        checkDuplicateSelection();
                                      },
                                      style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('Duyệt'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        printSelectedIds();

                        if (showReasonDialog) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Lý do từ chối'),
                              content: DropdownButtonFormField<String>(
                                value: selectedRawReason,
                                items: items.toSet().toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRawReason = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Chọn lý do',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedRawReason.isNotEmpty) {
                                      String selectedReason =
                                          selectedRawReason; // Sử dụng giá trị thô để lưu trữ lý do
                                      updateTuChoi();
                                      Navigator.pop(context);

                                      setState(() {});
                                    }
                                  },
                                  child: Text('Từ chối'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Lý do từ chối'),
                              content: DropdownButtonFormField<String>(
                                value: selectedRawReason,
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Vị trí cầu thủ không hợp lệ'),
                                    value: 'Vị trí cầu thủ không hợp lệ',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Đã đủ đội'),
                                    value: 'Đã đủ đội',
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                        'Thông tin thành viên không hợp lệ'),
                                    value: 'Thông tin thành viên không hợp lệ',
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedRawReason = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Chọn lý do',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedRawReason.isNotEmpty) {
                                      String selectedReason =
                                          selectedRawReason; // Sử dụng giá trị thô để lưu trữ lý do
                                      updateTuChoi();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      setState(() {});
                                    }
                                  },
                                  child: Text('Từ chối'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('Từ chối'),
                    ),
                  ],
                ),
              )
            : null,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              // margin:EdgeInsets.only(left:10,right:10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 246, 215),
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Đang chờ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 230, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(countCho.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 230, 0),
                                  fontSize: 18))
                        ])), //Đang xét
                Container(
                    width: 120,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 212, 248, 219),
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chấp nhận',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(countDangKy.toString(),
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18))
                        ])),
                Container(
                    width: 120,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 251, 213, 213),
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Từ chối',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(countTuChoi.toString(),
                              style: TextStyle(color: Colors.red, fontSize: 18))
                        ])),
              ])),
          Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('DANH SÁCH', style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.black45,
                ),
                dataListDS.isEmpty
                    ? Text(
                        'Chưa có đội đăng ký',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    : ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: dataList.length,
  itemBuilder: (context, index) {
    var data = dataList[index];
    var dataDS = dataListDS[index];
    int trangThaiDangKy = (dataDS.trangThaiDangKy!);

    return GestureDetector(
      onTap: () async{
         SharedPreferences prefs = await SharedPreferences.getInstance();
        doiBongid = dataListDS[index].doi_bong_id!;
            prefs.setInt('viewDoiBong',doiBongid);
  
        print('đúng là: $doiBongid');
       
          
        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View_Players(),
                      ),
                    );
      },
      child: Container(
        child: Row(
          children: [
            Checkbox(
              value: isChecked[index],
              onChanged: (bool? value) {
                onCheckboxChanged(value!, index);
                // Gán giá trị mới khi checkbox thay đổi
                setState(() {
                  // isChecked[index] = value ?? false;
               if (value == true) {
      onCheckboxChanged(value, index);
    }
                  if (isChecked.contains(true)) {
                   hideBottomNavigationBar();
                  } else {
                   
                      showBottomNavigationBar();
                  }
                });
              },
            ),
            Image.asset('${data.logo}', width: 50, height: 100),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTextForStatus(trangThaiDangKy),
                    style: TextStyle(
                      color: getColorForStatus(trangThaiDangKy),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${data.tenDoiBong}'),
                  Row(children: [
                    Text('6'),
                    SizedBox(width: 5),
                    Text('thành viên'),
                  ]),
                  Text('Tên người quản lý'),
                  Text('${dataDS.ngaydangky}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
)

              ]))
        ])));
  }
}
