import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/list_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Add_User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Add_User_State();
}

enum SingingCharacter { Admin, User }

class Add_User_State extends State<Add_User> {
  String? defaultLopValue;
  bool isTextFieldEnabled = true;
  String access_token = '';
  SingingCharacter? _character = SingingCharacter.Admin;

  final TextEditingController email = TextEditingController();
  final TextEditingController matkhau = TextEditingController();
  final TextEditingController hoten = TextEditingController();
  final TextEditingController sdt = TextEditingController();
  final TextEditingController repass = TextEditingController();
  List<String> dropdownValues = [];
  String selectedValue = 'Chọn giá trị';

  Future<bool> checkDuplicateEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        List<dynamic> accounts = responseData['data'];
        for (var account in accounts) {
          if (account['email'] == email) {
            return true; // Email đã tồn tại
          }
        }
      }
    }

    return false; // Email không trùng lặp
  }

 Future<void> fetchLoaiTaiKhoan() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8000/api/auth/LoaiTaiKhoan?token=$access_token'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final jsonData = data['data'] as List<dynamic>;

    // Lưu trữ tất cả các giá trị loai_tai_khoan vào danh sách dropdownValues
    dropdownValues =
        jsonData.map((item) => item['loai_tai_khoan'].toString()).toList();

    // In ra các giá trị từ cột loai_tai_khoan
    for (String value in dropdownValues) {
      print(value);
    }

    selectedValue = dropdownValues[0]; // Gán giá trị đầu tiên cho selectedValue
    setState(() {});
  } else {
    throw Exception('Failed to load data');
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
          content: Text('Thêm tài khoản thành công'),
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
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchLoaiTaiKhoan();
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.cancel_outlined, // Icon logout
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thêm tài khoản thất bại',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text('Tài khoản đã tồn tại'),
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
                email.clear();
                matkhau.clear();
                sdt.clear();
                repass.clear();
                hoten.clear();
                setState(() {});
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
  }

  void showErrorPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.cancel_outlined, // Icon logout
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
          content: Text('Mật khẩu không trùng khớp! Vui lòng nhập lại!'),
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
  }

  Future<int> getMaxId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
    final response =
        await http.get(Uri.parse(url), headers: {'User-Agent': 'MyApp/1.0'});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      int maxId =
          data.fold(0, (prev, item) => item['id'] > prev ? item['id'] : prev);
      return maxId + 1;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    bool isEmailDuplicated = await checkDuplicateEmail(email.text);
    if (isEmailDuplicated) {
      showErrorDialog(context);
      return;
    }
    // final maxId = await getMaxId();
    // print(maxId.toString());
    final response = await http.post(Uri.parse(url),
        body: {
          // 'id': maxId.toString(),
          'email': email.text,
          'matkhau': matkhau.text,
          'loai_tai_khoan': selectedValue.toString(),
          'sdt': sdt.text,
          'lop': 'Chưa có',
          'hoten': hoten.text,
          'avatar': 'Chưa có',
          'trang_thai': 'Active'
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm tài khoản thành công ');
        showSuccessDialog(context);
        email.clear();
        matkhau.clear();
        sdt.clear();
        repass.clear();
        hoten.clear();
        _character = SingingCharacter.Admin;
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  if (email.text.isNotEmpty ||
                      sdt.text.isNotEmpty ||
                      matkhau.text.isNotEmpty ||
                      hoten.text.isNotEmpty ||
                      repass.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber, // Icon logout
                                color: Colors.orange[600],
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Cảnh báo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                              'Thông tin hiện tại chưa được lưu. Bạn có muốn thoát?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                   backgroundColor: Colors.orange[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                  child: Text(
                                    'Quay lại',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => List_User()));
                  }
                },
                child: Text(
                  'HUỶ',
                  style: TextStyle(fontFamily: 'Anton', color: Colors.blue),
                ),
              ),
              Text(
                'THÊM USER',
                style: TextStyle(fontFamily: 'Anton', color: Colors.black54),
              ),
              TextButton(
                onPressed: () async {
                  String emailValue = email.text;
                  String matkhauValue = matkhau.text;
                  String hotenValue = hoten.text;
                  String sdtValue = sdt.text;
                  String repassValue = repass.text;

                  if (emailValue.isEmpty ||
                      matkhauValue.isEmpty ||
                      hotenValue.isEmpty ||
                      sdtValue.isEmpty ||
                      repassValue.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber, // Icon logout
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Cảnh báo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: Text('Vui lòng nhập đầy đủ thông tin!'),
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
                    // Hiển thị thông báo lỗi hoặc thực hiện các hành động khác khi các trường rỗng
                  } else if (!emailValue.endsWith('@caothang.edu.vn')) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber, // Icon logout
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Cảnh báo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: Text('Email không hợp lệ!'),
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
                    // Hiển thị thông báo lỗi hoặc thực hiện các hành động khác khi email không hợp lệ
                  } else if (sdtValue.length != 10 ||
                      !sdtValue.startsWith('0')) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber, // Icon logout
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Cảnh báo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: Text('Số điện thoại không hợp lệ!'),
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
                    // Hiển thị thông báo lỗi hoặc thực hiện các hành động khác khi số điện thoại không hợp lệ
                  } else if (matkhauValue.length <= 6 ||
                      !matkhauValue.contains(RegExp(r'[A-Z]'))) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber, // Icon logout
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Cảnh báo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                              'Mật khẩu phải có ít nhất 6 kí tự và chứa ít nhất 1 kí tự viết hoa!'),
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
                    // Hiển thị thông báo lỗi hoặc thực hiện các hành động khác khi mật khẩu không hợp lệ
                  } else {
                    bool isEmailDuplicated =
                        await checkDuplicateEmail(emailValue);
                    if (matkhauValue != repassValue) {
                      print('matkhau không trùng khớp');
                      showErrorPassword(context);
                    } else {
                      if (isEmailDuplicated) {
                        showErrorDialog(context);
                      } else {
                        print(
                            'Giá trị được chọn là ${_character.toString().split('.').last}');
                        fetchData();
                      }
                    }
                  }
                },
                child: Text(
                  'LƯU',
                  style: TextStyle(fontFamily: 'Anton', color: Colors.blue),
                ),
              )
            ],
          )),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(children: [
                      Text(
                        'Nhập đầy đủ thông tin',
                        style: TextStyle(
                            fontFamily: 'Anton',
                            color: Colors.black54,
                            fontSize: 20),
                      ),
                    ]),
                  ),
                  Container(
                      // height: 200,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                             Row(
                              children: [
                                Text(
                                  'Họ tên',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                Expanded(
                                    child: TextField(
                                  controller: hoten,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Họ tên',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                ))
                              ],
                            ),
                            Row(children: [
                              Text('Số điện thoại: ',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: sdt,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Số điện thoại',
                                  hintStyle: TextStyle(color: Colors.black38),
                                ),
                              ))
                            ]),
                            Row(
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                Expanded(
                                    child: TextField(
                                  controller: email,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Email Cao Thắng',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                ))
                              ],
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text('Loại tài khoản: ',
                                      style: TextStyle(fontSize: 20)),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    items: dropdownValues.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Mật khẩu',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Expanded(
                                    child: TextField(
                                  obscureText: true,
                                  controller: matkhau,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                ))
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Nhập lại',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Expanded(
                                    child: TextField(
                                  obscureText: true,
                                  controller: repass,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Nhập lại mật khẩu',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                ))
                              ],
                            ),
                           
                           
                            
                          ])),
                ]),
          ),
        ));
  }
}
