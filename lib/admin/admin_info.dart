import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/image_user.dart';
import 'package:ckc_league/admin/main_screen.dart';
import 'package:ckc_league/admin/update_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ckc_league/menu_bottom/profile/change_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Admin_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Admin_Info_State();
}

class Admin_Info_State extends State<Admin_Info> {
  bool showBottomSheet = false;
  String hoten = '';
  String email = '';
  int id = 0;
  String avatar = 'images/admin1.png';
  String sdt = '';
  late List data;
  String access_token = '';
  late SharedPreferences prefs;
  // String selectedImageUser = 'images/admin1.png';
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // email = prefs.getString('email') ?? '';
    id = prefs.getInt('id') ?? 0;
    // hoten = prefs.getString('hoten') ?? '';
    // avatar = prefs.getString('avatar') ?? 'images/admin1.png';
    // sdt = prefs.getString('sdt') ?? '';

    setState(() {});
  }

  // Future<void> getHoten() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   id = prefs.getInt('id') ?? 0;

  //   email = prefs.getString('email') ?? '';

  //   setState(() {});
  // }
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
        

        print('ID là: $id');
        print('hoten: $hoten');
        print('id: $id');
        print('sdt: $sdt');
        print('email: $email');
        print('avatar: $avatar');
      }
      setState(() {});
    } else {
      print('Lỗi ${response.statusCode}');
    }
    setState(() {
      
    });
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
  // Future<void> initializeSharedPreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  //   selectedImageUser =
  //       prefs.getString('selectedImageNameAdmin') ?? 'images/admin1.png';
  //   setState(() {}); // Gọi setState để cập nhật giao diện
  // }

  @override
  void initState() {
    super.initState();
    getData();
    getInfo();
    setState(() {});
    // getHoten();
    data = [];

    // initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text('THÔNG TIN CÁ NHÂN', style: TextStyle(color: Colors.white)),
          elevation: 0,
          backgroundColor: Color(0xFA011129),
          leading: IconButton(
            icon: const Icon(
              Icons.navigate_before_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen_Admin()));
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
                          backgroundImage: AssetImage('$avatar'),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: IconButton(
                        //     icon: Icon(Icons.camera_alt, color: Colors.black),
                        //     onPressed: () {
                        //       setState(() {
                        //         showBottomSheet = true;
                        //       });
                        //       // showModalBottomSheet(
                        //       //   context: context,
                        //       //   builder: (BuildContext context) {
                        //       //     return Container(
                        //       //       height: 200,
                        //       //       decoration: BoxDecoration(
                        //       //         color: Colors.white.withOpacity(
                        //       //             0.8), // opacity giữa 0 và 1
                        //       //         borderRadius: BorderRadius.only(
                        //       //           topLeft: Radius.circular(20.0),
                        //       //           topRight: Radius.circular(20.0),
                        //       //           bottomLeft: Radius.circular(20.0),
                        //       //           bottomRight: Radius.circular(20.0),
                        //       //         ),
                        //       //       ),
                        //       //       child: Column(
                        //       //         mainAxisAlignment:
                        //       //             MainAxisAlignment.center,
                        //       //         children: [
                        //       //           ElevatedButton(
                        //       //             style: ElevatedButton.styleFrom(
                        //       //              backgroundColor: Colors.white,
                        //       //               foregroundColor: Colors.black,
                        //       //               shape: RoundedRectangleBorder(
                        //       //                 borderRadius:
                        //       //                     BorderRadius.circular(20.0),
                        //       //               ),
                        //       //             ),
                        //       //             child: Row(
                        //       //               mainAxisAlignment:
                        //       //                   MainAxisAlignment.center,
                        //       //               children: [
                        //       //                 Icon(Icons.camera_alt),
                        //       //                 SizedBox(
                        //       //                     width:
                        //       //                         8.0), // thêm khoảng cách giữa icon và text
                        //       //                 Text(
                        //       //                   'Chụp ảnh',
                        //       //                   style: TextStyle(fontSize: 20),
                        //       //                 ),
                        //       //               ],
                        //       //             ),
                        //       //             onPressed: () {},
                        //       //           ),
                        //       //           ElevatedButton(
                        //       //             style: ElevatedButton.styleFrom(
                        //       //              backgroundColor: Colors.white,
                        //       //               foregroundColor: Colors.black,
                        //       //               shape: RoundedRectangleBorder(
                        //       //                 borderRadius:
                        //       //                     BorderRadius.circular(20.0),
                        //       //               ),
                        //       //             ),
                        //       //             child: Row(
                        //       //               mainAxisAlignment:
                        //       //                   MainAxisAlignment.center,
                        //       //               children: [
                        //       //                 Icon(Icons.photo_library),
                        //       //                 SizedBox(width: 10.0),
                        //       //                 Text('Chọn ảnh từ hệ thống',
                        //       //                     style:
                        //       //                         TextStyle(fontSize: 20)),
                        //       //               ],
                        //       //             ),
                        //       //             onPressed: () {
                        //       //               Navigator.push(
                        //       //                   context,
                        //       //                   MaterialPageRoute(
                        //       //                       builder: (context) =>
                        //       //                           Image_User()));
                        //       //             },
                        //       //           ),
                        //       //           ElevatedButton(
                        //       //             style: ElevatedButton.styleFrom(
                        //       //              backgroundColor: Colors.blueGrey[
                        //       //                   800], // sử dụng màu xanh dương
                        //       //               foregroundColor: Colors.white,
                        //       //               shape: RoundedRectangleBorder(
                        //       //                 borderRadius: BorderRadius.circular(
                        //       //                     20.0), // chỉ định bán kính bo tròn
                        //       //               ),
                        //       //             ),
                        //       //             child: Row(
                        //       //               mainAxisAlignment:
                        //       //                   MainAxisAlignment.center,
                        //       //               children: [
                        //       //                 Icon(Icons.cancel),
                        //       //                 SizedBox(width: 10),
                        //       //                 Text('Hủy',
                        //       //                     style:
                        //       //                         TextStyle(fontSize: 20)),
                        //       //               ],
                        //       //             ),
                        //       //             onPressed: () {
                        //       //               Navigator.pop(context);
                        //       //             },
                        //       //           ),
                        //       //         ],
                        //       //       ),
                        //       //     );
                        //       //   },
                        //       // ).then((value) {
                        //       //   setState(() {
                        //       //     showBottomSheet = false;
                        //       //   });
                        //       // });
                        //     },
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Text('ID: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('$id', style: TextStyle(fontSize: 20)),
                        ])),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 1,
                      height: 5,
                      color: Colors.black26,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              child: Row(children: [
                            Text('Họ tên: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text('$hoten', style: TextStyle(fontSize: 20)),
                          ])),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              child: Row(children: [
                            Text('Email: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text('$email', style: TextStyle(fontSize: 20)),
                          ])),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              child: Row(children: [
                            Text('SĐT: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text('$sdt', style: TextStyle(fontSize: 20)),
                          ])),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.black26,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.99,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Change_Password()));
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
                            'THAY ĐỔI MẬT KHẨU',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FractionallySizedBox(
                      widthFactor: 0.99,
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Update_Info()));
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
                            'CẬP NHẬT THÔNG TIN',
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
