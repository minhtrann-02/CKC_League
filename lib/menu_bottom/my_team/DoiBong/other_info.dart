// ignore_for_file: unused_import, unused_local_variable

import 'package:ckc_league/menu_bottom/my_team/DoiBong/my_team.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ckc_league/Object_API/object_api.dart';

class Other_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Other_Info_State();
}

class Other_Info_State extends State<Other_Info> {
  bool showBottomSheet = false;
  int nguoiquanlyid = 0;
  String khoa = '';
  String lop = '';
  String tendoibong = '';
  String logo = '';
  String sdt = '';
  String access_token = '';
  String tenlienhe = '';
  String email = '';
  String matkhau = '';
  String hoten = '';
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nguoiquanlyid = prefs.getInt('ID') ?? 0;
    khoa = prefs.getString('selected_value') ?? '';
    lop = prefs.getString('lop') ?? '';
    tendoibong = prefs.getString('ten_doi') ?? '';
    logo = prefs.getString('selectedImageName1') ?? '';
    sdt = prefs.getString('SDT') ?? '';
    tenlienhe = prefs.getString('TenLienHe') ?? '';
    matkhau = prefs.getString('matkhau') ?? '';
    email = prefs.getString('email') ?? '';
    print('ID người quản lý: $nguoiquanlyid');
    print('Tên người quản lý: $tenlienhe');
    print('Khóa: $khoa');
    print('Lớp:$lop');
    print('tên đội bóng: $tendoibong');
    print('Logo: $logo');
    print('SDT: $sdt');
    print('matkhau: $matkhau');
    print('Email: $email');
  }

  Future<void> addTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/football?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'nguoi_quan_ly_id': nguoiquanlyid,
        'khoa': khoa,
        'lop': lop,
        'sl_thanh_vien': 0,
        'ten_doi_bong': tendoibong,
        'logo': logo,
        'so_diem': 0,
        'so_tran_dau': 0,
        'so_tran_thang': 0,
        'so_tran_thua': 0,
        'so_ban_thang': 0,
        'so_ban_thua': 0,
        'trang_thai_dang_ky': 1,
      }),
      headers: headers,
    );
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm đội thành công ');
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => My_team()));
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
         Navigator.pop(context);
    
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
//  void addDoiTruong() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     access_token = prefs.getString('accessToken') ?? '';
//  hoten = prefs.getString('hoten')??'';
//  print('ho ten doi truong la: $hoten');


//     final String url =
//         'http://10.0.2.2:8000/api/auth/players?token=$access_token';
//     final headers = {'User-Agent': 'MyApp/1.0'};


//     final response = await http.post(
//       Uri.parse(url),
//       body: {
//         'doi_bong_id': idDoiBong.toString(),
//         'ten_cau_thu': hoten.toString(),
//         'so_ao': soao.text.toString(),
//         'id_tai_khoan': idTaiKhoanEmail.toString(), 
//         'vi_tri': selectedValue.toString(),
//         // 'vai_tro': seletedVaiTro.toString(),
//          'vai_tro': seletedVaiTro.toString(),
//         'avatar': selectedImageUser.toString(),
//         'so_tran_tham_gia': '0',
//         'so_ban_thang': '0',
//         'so_kien_tao': '0',
//         'so_the_vang': '0',
//         'so_the_do': '0',
//       },
//       headers: headers,
//     );

//     print(response.statusCode);
//     setState(() {
//       if (response.statusCode == 201) {
//         print('Thêm cầu thủ thành công ');
//         showSuccessDialogTT(context);
//         // tenhinhthuc.clear();
//         // tenthidau.clear();
//         // soao.clear();
//         // seletedVaiTro = 'Chọn vai trò';
//         // selectedValue = 'Vị trí thi đấu(Tùy chọn)';

//         setState(() {});
//       } else {
//         throw Exception('Failed to load data');
//       }
//     });
//   }
  Future<void> updateInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/Login/$nguoiquanlyid?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};

    final requestData = {
      'matkhau': matkhau,
      'hoten': tenlienhe,
      'email': email,
      'sdt': sdt,
      'loai_tai_khoan': 'User',
      'lop': lop,
      'avatar': '*',
      'trang_thai': 'Active',
    };
    final body = jsonEncode(requestData);
    final String requestBody = json.encode(requestData);

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
                      title: Row(
                        children: [
                          Icon(
                            Icons.check_circle, // Icon logout
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
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Thêm đội thành công',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.white,
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.navigate_before,
                    color: Colors.black,
                  )),
              SizedBox(
                width: 50,
                // height: 10
              ),
              Text(
                'Thông tin khác',
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'ĐỒNG PHỤC THI ĐẤU',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1), // Viền màu đen độ dày 2
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Độ cong bo tròn (0 để tạo hình vuông)
                            child: Image.asset(
                              'images/homekit.png',
                              width: 100,
                              height: 90,
                              // fit: BoxFit.cover, // Phù hợp với vùng cắt
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black),
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
                                      borderRadius: BorderRadius.only(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo_library),
                                              SizedBox(width: 10.0),
                                              Text('Chọn ảnh từ thư viện',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.blueGrey[
                                                800], // sử dụng màu xanh dương
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // chỉ định bán kính bo tròn
                                            ),
                                          ),
                                          child: Row(
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
                    ),
                    Text('Chính', style: TextStyle(color: Colors.black))
                  ],
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1), // Viền màu đen độ dày 2
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Độ cong bo tròn (0 để tạo hình vuông)
                            child: Image.asset(
                              'images/thirdkit.png',
                              width: 100,
                              height: 90,
                              // fit: BoxFit.cover, // Phù hợp với vùng cắt
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black),
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
                                      borderRadius: BorderRadius.only(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo_library),
                                              SizedBox(width: 10.0),
                                              Text('Chọn ảnh từ thư viện',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.blueGrey[
                                                800], // sử dụng màu xanh dương
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // chỉ định bán kính bo tròn
                                            ),
                                          ),
                                          child: Row(
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
                    ),
                    Text('Phụ', style: TextStyle(color: Colors.black))
                  ],
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1), // Viền màu đen độ dày 2
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Độ cong bo tròn (0 để tạo hình vuông)
                            child: Image.asset(
                              'images/gkkit.png',
                              width: 100,
                              height: 90,
                              // fit: BoxFit.cover, // Phù hợp với vùng cắt
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black),
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
                                      borderRadius: BorderRadius.only(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
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
                                           backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo_library),
                                              SizedBox(width: 10.0),
                                              Text('Chọn ảnh từ thư viện',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.blueGrey[
                                                800], // sử dụng màu xanh dương
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // chỉ định bán kính bo tròn
                                            ),
                                          ),
                                          child: Row(
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
                    ),
                    Text('GK', style: TextStyle(color: Colors.black))
                  ],
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 30, left: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GIỚI THIỆU',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      Icon(Icons.edit)
                    ])),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 150,
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Chưa có thông tin',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 130),
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    addTeam();
                    updateInfo();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: Text(
                    'THÊM',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
