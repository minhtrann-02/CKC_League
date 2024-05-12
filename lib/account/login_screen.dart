// ignore_for_file: unused_import, unused_local_variable

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/account/signup_screen.dart';
import 'package:ckc_league/admin/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../menu_bottom/home_page.dart';
import 'forgot-password_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => Login_ScreenState();
}

// ignore: camel_case_types
class Login_ScreenState extends State<Login_Screen> {
  bool _obscureText = true;
  String access_token = '';
  late List data;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
          content: Text('Đăng nhập thành công!'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home_Page()),
                );
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

  @override
  void initState() {
    super.initState();
    connectToAPI();
    data = [];
  }

  Future<void> connectToAPI() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'email': 'admin@vinasupport.com', 'password': '123456'});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      access_token = jsonResponse['access_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', access_token);
      print('Access Token: $access_token');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void fetchData() async {
    print('Token là: $access_token');
    final String url = 'http://10.0.2.2:8000/api/auth/Login';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    print(response.statusCode);

    if (response.statusCode == 200) {
      // API request thành công
      final responseData = jsonDecode(response.body);
      final status = responseData['status'];
      final message = responseData['message'];
      final dataList = responseData['data'] as List<dynamic>;
      final token = responseData['token'];
      final emailInput = email.text;
      final passwordInput = password.text;
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

        if (email == emailInput && matkhau == passwordInput) {
          // Giá trị nhập liệu trùng khớp với một đối tượng từ API
          isMatched = true;
          userType = loaiTaiKhoan;
          print('Ho ten: $hoten');
          print('ID: $id');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('hoten', hoten);
          prefs.setInt('ID', id);
          prefs.setString('sdt', sdt.toString());
          prefs.setString('matkhau', matkhau);
          prefs.setString('loaitaikhoan', loaiTaiKhoan);
          prefs.setString('lop', lop);
          prefs.setString('email', email);
          prefs.setString('avatar', avatar);
          prefs.setString('trang_thai', trang_thai);
          break;
        }
      }

      if (isMatched) {
        // Đăng nhập thành công
        print('Đăng nhập thành công!');
        showSuccessDialog(context);
        email.clear();
        password.clear();

        if (userType == "admin" || userType == "Admin") {
          // Chuyển đến trang admin
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen_Admin()),
          );
        } else if (userType == "user" || userType == "User") {
          // Chuyển đến trang homepage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_Page()),
          );
        }
      } else {
        // Giá trị nhập liệu không trùng khớp với bất kỳ đối tượng từ API
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined, // Icon logout
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                      Text(
                        'Thất bại',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  content:
                      Text('Email hoặc mật khẩu sai! Vui lòng kiểm tra lại'),
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
                ));
      }
    } else {
      // API request thất bại
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bạn chưa có tài khoản?',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            TextButton(
              onPressed: onSignUp,
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'images/logo_app.png',
                  width: 200,
                  height: 200,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Chào mừng bạn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    // contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPassWord,
                      child: const Text(
                        "Quên mật khẩu?",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.99,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: onLogin,
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
                        'ĐĂNG NHẬP',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //Navigator
  void onSignUp() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUp_Screen()),
        );
      },
    );
  }

  void onForgotPassWord() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Forgot_Screen()),
        );
      },
    );
  }

  void onLogin() {
    final String emailInput = email.text;
    final String passwordInput = password.text;

    if (emailInput.isNotEmpty && passwordInput.isNotEmpty) {
      // Email và mật khẩu không rỗng
      fetchData(); // Thực hiện hàm fetchData() ở đây

      // setState(() {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => Home_Page()),
      //   );
      // });
    } else {
      // Email hoặc mật khẩu rỗng
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập email và mật khẩu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
