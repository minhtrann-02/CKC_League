// ignore_for_file: depend_on_referenced_packages, camel_case_types, non_constant_identifier_names

import 'dart:io';

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/admin_info.dart';
import 'package:ckc_league/admin/image_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Update_Info extends StatefulWidget {
  const Update_Info({super.key});

  @override
  State<StatefulWidget> createState() => Update_Info_State();
}

class Update_Info_State extends State<Update_Info> {
  bool showBottomSheet = false;
  String hoten = '';
  String email = '';
  String avatar = '';
  String matkhau = '';
  String lop = '';
  String loaitaikhoan = '';
  String trangthai = '';
  int id = 0;
  String sdt = '';
  late List data;
  String access_token = '';
  TextEditingController sdtupdate = TextEditingController();
  TextEditingController tenupdate = TextEditingController();
  late SharedPreferences prefs;
  String selectedImageUser = 'images/admin1.png';
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    id = prefs.getInt('id') ?? 0;
    print('ID là: $id');
    setState(() {});
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    print('Token là: $access_token');
    final String url =
        'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách theo cột 'nguoi_quan_ly_id'
      final filteredDataList = data.where((item) => item['id'] == id).toList();

      // In tất cả giá trị id thỏa điều kiện lên console
      for (var item in filteredDataList) {
        email = item['email'];
        id = item['id'];
        avatar = item['avatar'];
        sdt = item['sdt'];
        hoten = item['hoten'];

        // print('ID là: $id');
        // print('hoten: $hoten');
        // print('id: $id');
        // print('sdt: $sdt');
        // print('email: $email');
        // print('avatar: $avatar');
      }
      setState(() {});
    } else {
      print('Lỗi ${response.statusCode}');
    }
    setState(() {});
  }

  Future<void> getHoten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hoten = prefs.getString('hoten') ?? '';
    id = prefs.getInt('id') ?? 0;
    sdt = prefs.getString('sdt') ?? '';
    email = prefs.getString('email') ?? '';
    loaitaikhoan = prefs.getString('loaitaikhoan') ?? '';
    lop = prefs.getString('lop') ?? '';
    matkhau = prefs.getString('matkhau') ?? '';
    avatar = prefs.getString('avatar') ?? '';
    trangthai = prefs.getString('trang_thai') ?? "";
    print(id);
    print(hoten);
    print('loai tai khoan $loaitaikhoan');
    print(sdt);
    print(matkhau);
    print(email);
    print('avatar" $avatar');
    print(lop);
    setState(() {});
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<Data> dataList =
          List<Data>.from(responseData.map((x) => Data.fromJson(x)));

      // Lấy giá trị hoten từ đối tượng đầu tiên trong danh sách dataList
      hoten = dataList[0].hoten!;

      setState(() {
        // Cập nhật UI khi có dữ liệu
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  //   Future<void> getSelectedImageName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     // selectedImageUser =
  //     //     prefs.getString('selectedImageUser') ?? 'images/logo1.png';
  //     prefs.setString('selectedImageNameAdmin', selectedImageUser);
  //     print('image là: $selectedImageUser');
  //   });
  // }
  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    selectedImageUser =
        prefs.getString('selectedImageNameAdmin') ?? 'images/admin1.png';
    setState(() {}); // Gọi setState để cập nhật giao diện
  }

  Future<void> updateInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('ID') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/Login/$id?token=$access_token'; // Thay đổi URL của API tương ứng
    print('update');
    print(id);
    print(selectedImageUser);
    print(matkhau);
    print(loaitaikhoan);
    print(sdtupdate.text.toString());
    print(trangthai);
    print(tenupdate.text.toString());
    print(lop);
    final requestData = {
      'mat_khau': matkhau,
      'email': email,
      'hoten': tenupdate.text.toString(),
      'sdt': sdtupdate.text.toString(),
      'loai_tai_khoan ': loaitaikhoan,
      'lop': lop,
      'avatar': selectedImageUser,
      'trang_thai': trangthai,
    };
    json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.putUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
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
            content: const Text('Cập nhật thành công'),
            actions: [
              ElevatedButton(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Admin_Info()),
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
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    super.initState();

    data = [];
    getHoten();
    getInfo();
    getData();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('CẬP NHẬT THÔNG TIN',
              style: TextStyle(color: Colors.white)),
          elevation: 0,
          backgroundColor: const Color(0xFA011129),
          leading: IconButton(
            icon: const Icon(
              Icons.navigate_before_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Admin_Info()));
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('$selectedImageUser'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.black),
                            onPressed: () {
                              setState(() {
                                showBottomSheet = true;
                              });
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          0.8), // opacity giữa 0 và 1
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.camera_alt),
                                              SizedBox(
                                                  width:
                                                      8.0), // thêm khoảng cách giữa icon và text
                                              Text(
                                                'Chụp ảnh',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo_library),
                                              SizedBox(width: 10.0),
                                              Text('Chọn ảnh từ hệ thống',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Image_User()));
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Colors.blueGrey[800],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // chỉ định bán kính bo tròn
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.cancel),
                                              SizedBox(width: 10),
                                              Text('Hủy',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).then((value) {
                                setState(() {
                                  showBottomSheet = false;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              child: Row(children: [
                            const Text('Họ tên: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Expanded(
                              child: TextField(
                                controller: tenupdate,
                                decoration: const InputDecoration(
                                  border:
                                      InputBorder.none, // Loại bỏ đường viền
                                  enabledBorder: InputBorder
                                      .none, // Loại bỏ đường viền khi không được tương tác
                                  focusedBorder: InputBorder
                                      .none, // Loại bỏ đường viền khi được tương tác
                                  contentPadding: EdgeInsets.all(
                                      0), // Xóa khoảng cách giữa nội dung và viền
                                ),
                                style: const TextStyle(fontSize: 20),
                                // Các thuộc tính khác của TextField
                              ),
                            ),
                          ])),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(children: [
                            const Text('SĐT: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Expanded(
                              child: TextField(
                                controller: sdtupdate,
                                decoration: const InputDecoration(
                                  border:
                                      InputBorder.none, // Loại bỏ đường viền
                                  enabledBorder: InputBorder
                                      .none, // Loại bỏ đường viền khi không được tương tác
                                  focusedBorder: InputBorder
                                      .none, // Loại bỏ đường viền khi được tương tác
                                  contentPadding: EdgeInsets.all(
                                      0), // Xóa khoảng cách giữa nội dung và viền
                                ),
                                style: const TextStyle(fontSize: 20),
                                // Các thuộc tính khác của TextField
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.99,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            updateInfo();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Cập nhật thông tin',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
