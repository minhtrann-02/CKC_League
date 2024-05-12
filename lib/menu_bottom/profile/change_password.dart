// ignore_for_file: unused_import, unused_local_variable

import 'package:ckc_league/menu_bottom/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';

class Change_Password extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Change_Password_State();
}

class Change_Password_State extends State<Change_Password> {
  String email = '';
  int id = 0;
  String hoten = '';
  String sdt = '';
  String loaitaikhoan = '';
  String lop = '';
  String matkhau='';
  String currentPassword='';
  String trang_thai = '';
  String avatar ='';
  String access_token = '';
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController rePass = TextEditingController();
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
  currentPassword = prefs.getString('matkhau')??'';
    setState(() {});
  }


void fetchData() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
  print('Token là: $access_token');
       final String url = 'http://10.0.2.2:8000/api/auth/Login';
  final headers = {'User-Agent': 'MyApp/1.0','Authorization': 'Bearer $access_token',};
  final response = await http.get(Uri.parse(url), headers: headers);
  
  print(response.statusCode);
  
  if (response.statusCode == 200) {
    // API request thành công
    final responseData = jsonDecode(response.body);
    final status = responseData['status'];
    final message = responseData['message'];
    final dataList = responseData['data'] as List<dynamic>;
    final token = responseData['token'];
    bool isMatched = false;
    String userType = "";
    print(token);
    for (var data in dataList) {
      final id = data['id'];
      final matkhau = data['matkhau'];
      final email = data['email'];
      final hoten = data['hoten'];
      final sdt = data['sdt'];
      final loaiTaiKhoan = data['loai_tai_khoan'];
      final lop = data['lop'];
      final avatar = data['avatar'];
      final trang_thai = data['trang_thai'];
      final createdAt = data['created_at'];
      final updatedAt = data['updated_at'];
         print('Ho ten: $hoten');
         print('ID: $id');
         SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('hoten', hoten);
         prefs.setInt('id', id);
          prefs.setString('sdt', sdt);
          prefs.setString('matkhau',matkhau);
           prefs.setString('loaitaikhoan', loaiTaiKhoan);
            prefs.setString('lop', lop);
         prefs.setString('email', email);
         prefs.setString('avatar',avatar);
         prefs.setString('trang_thai', trang_thai);
        break;
      
    }
  } else {
    // API request thất bại
    throw Exception('Failed to load data');
  }
}
  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id') ?? 0;
    hoten = prefs.getString('hoten') ?? '';
    sdt = prefs.getString('sdt') ?? '';
    loaitaikhoan = prefs.getString('loaitaikhoan') ?? '';
    lop = prefs.getString('lop') ?? '';
    avatar = prefs.getString('avatar') ?? '';
    email = prefs.getString('email') ?? '';
    trang_thai = prefs.getString('trang_thai') ?? '';
    access_token = prefs.getString('accessToken') ?? '';
    print(id);
    print(hoten);
    print(sdt);
    print(loaitaikhoan);
    print(lop);
    print(email);
    print(newPass.text);
    print(avatar);
    print(trang_thai);
    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/Login/$id?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
    final requestData = {
      'hoten': hoten,
      'sdt': sdt,
      'email':email,
      'matkhau': newPass.text,
      'lop':lop,
      'loai_tai_khoan': loaitaikhoan,
      'avatar': avatar,
      'trang_thai': trang_thai,
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
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
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
          content: Text('Cập nhật thành công'),
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
              Navigator.of(context).pop(); // Đóng hộp thoại
                  oldPass.clear();
                  newPass.clear();
                  rePass.clear();
                 
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
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
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to update data');
    }
  }

// Hàm xử lý logic khi người dùng nhấn nút Button
  void handleSubmitButton() {
    // Lấy giá trị từ các trường nhập liệu
    String oldPassword = oldPass.text;
    String newPassword = newPass.text;
    String rePassword = rePass.text;

    // Kiểm tra nếu không nhập vào bất kỳ trường nào
    if (oldPassword.isEmpty || newPassword.isEmpty || rePassword.isEmpty) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
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
          content: Text('Vui lòng nhập giá trị'),
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

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
      return;
    }

   print(currentPassword);
  if (oldPassword != currentPassword) { // Thay `currentPassword` bằng giá trị mật khẩu hiện tại
    // Hiển thị thông báo lỗi
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
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
          content: Text('Mật khẩu cũ không trùng khớp'),
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

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
    return;
  }

    // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu có khớp nhau không
    if (newPassword != rePassword) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
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
          content: Text('Mật khẩu mới không trùng khớp'),
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

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
      return;
    }

    // Kiểm tra mật khẩu mới có đủ yêu cầu không
    if (newPassword.length < 8 && !newPassword.contains(RegExp(r'[A-Z]'))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Mật khẩu mới phải có kí tự hoa và hơn 8 kí tự!'),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
  updateData();
    // Các xử lý tiếp theo sau khi kiểm tra thành công
    // ...
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title:
              Text('Thay đổi mật khẩu', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mật khẩu hiện tại:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Đặt độ bo tròn nhẹ ở 4 góc
                      color: Colors.white, // Màu nền của TextField
                      border: Border.all(color: Colors.black), // Đường viền đen
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.3), // Màu bóng của TextField
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Độ dịch chuyển của bóng
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: oldPass,
                      obscureText: true,
                      // Các thuộc tính của TextField
                      decoration: InputDecoration(
                        border: InputBorder.none, // Bỏ viền của TextField
                        hintText: 'Nhập mật khẩu hiện tại',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  Text(
                    'Mật khẩu mới: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Đặt độ bo tròn nhẹ ở 4 góc
                      color: Colors.white, // Màu nền của TextField
                      border: Border.all(color: Colors.black), // Đường viền đen
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.3), // Màu bóng của TextField
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Độ dịch chuyển của bóng
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: newPass,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Bỏ viền của TextField
                        hintText: 'Nhập mật khẩu mới',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  Text(
                    'Nhập lại mật khẩu mới: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Đặt độ bo tròn nhẹ ở 4 góc
                      color: Colors.white, // Màu nền của TextField
                      border: Border.all(color: Colors.black), // Đường viền đen
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.3), // Màu bóng của TextField
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Độ dịch chuyển của bóng
                        ),
                      ],
                    ),
                    child: TextField(
                      obscureText: true,
                      controller: rePass,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Bỏ viền của TextField
                        hintText: 'Nhập lại mật khẩu mới',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  FractionallySizedBox(
                    widthFactor: 0.99,
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          handleSubmitButton();
                        
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'THAY ĐỔI',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
