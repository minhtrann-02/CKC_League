// ignore_for_file: camel_case_types, unused_import

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/account/login_screen.dart';
import 'package:ckc_league/menu_bottom/profile/change_pass_user.dart';
import 'package:ckc_league/menu_bottom/profile/change_password.dart';
import 'package:ckc_league/menu_bottom/profile/achievements_screen.dart';
import 'package:ckc_league/menu_bottom/profile/info_basic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../home/notification.dart';
import '../home/search.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<StatefulWidget> createState() => Profile_Screen_State();
}

class Profile_Screen_State extends State<Profile_Screen> {
  String hoten = '';
  String email = '';
  // String id = '';
  late List data;
   final String url = 'http://192.168.70.69:8000/api/login';

     Future<void> getHoten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hoten = prefs.getString('hoten') ?? '';
    //  id = prefs.getString('id') ?? '';
      email = prefs.getString('email') ?? '';
      // print('ID là: $id');
    setState(() {});
  }

  void fetchData()async{
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<Data> dataList = List<Data>.from(responseData.map((x) => Data.fromJson(x)));

    // Lấy giá trị hoten từ đối tượng đầu tiên trong danh sách dataList
    hoten = dataList[0].hoten!;

    setState(() {
      // Cập nhật UI khi có dữ liệu
    });
  } else {
    throw Exception('Failed to load data');
  }
  }

     @override
  void initState() {
    super.initState();
    data = [];
      getHoten();
  
  }
  @override
  Widget build(BuildContext context) {
    getHoten();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFA011129),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
        title: const Text(
          'Tài khoản',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: onNotification,
            icon: const Icon(Icons.notifications_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 90,
              color: const Color.fromRGBO(1, 17, 41, 5),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child:  Column(
                      children: [
                        Text(
                          hoten ?? '', 
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          email??'',
                          style: TextStyle(color: Colors.white60),
                        )
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'THÔNG TIN CÁ NHÂN',
                          style: TextStyle(
                              color: Color.fromRGBO(1, 17, 41, 5),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Info_basic()));
                            },
                            child: const Text(
                              'Sửa',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 52, 119, 55),
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.facebook),
                        Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                        Text('Chưa có liên kết tài khoản Facebook',
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month_rounded),
                        Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                        Text('Chưa có ngày sinh',
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.phone),
                        Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                        Text('Chưa có số điện thoại',
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.info),
                        Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                        Text('Chưa có giới thiệu bản thân',
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('THÀNH TÍCH CÁ NHÂN',
                              style: TextStyle(
                                  color: Color.fromRGBO(1, 17, 41, 5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Achievements_screen()),
                                );
                              },
                              child: const Text('Tất cả',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 52, 119, 55))))
                        ]),
                  ),
                  Container(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/tshirt.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Giải tham dự',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 234, 234),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/gold-cup.png',
                                      width: 50, height: 50),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Giải nhất',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 234, 234),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/silver-cup.png',
                                      width: 50, height: 50),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Giải nhì',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 234, 234),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/bronze-cup.png',
                                      width: 50, height: 50),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Giải ba',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 234, 234),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/cup4.png',
                                      width: 50, height: 50),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Giải tư',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 234, 234),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Change_Password_User()),
        );
              },
            child:  Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.vpn_key),
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    Text(
                      'Thay đổi mật khẩu',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            Icons.logout, // Icon logout
                            color: Colors.red,
                            size: 24,
                          ),
                          SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Bạn có chắc chắn muốn đăng xuất?',
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
                                  'Có',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Không',
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
                                 backgroundColor: Colors.grey,
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
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Navigator
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
