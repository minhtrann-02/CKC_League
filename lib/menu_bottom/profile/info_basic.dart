import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Info_basic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Info_basic_State();
}

class Info_basic_State extends State<Info_basic> {
  bool showBottomSheet = false;
  String hoten = '';
  String email ='';
  int id = 0;
  late List data;
   final String url = 'http://192.168.70.91:8000/api/login';

     Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.getString('email') ?? '';
      id = prefs.getInt('id')?? 0;
      print('ID là: $id');
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
      getData();
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.navigate_before,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 50,
                    // height: 10
                  ),
                  Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ))),
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
                        backgroundImage: AssetImage('images/user.png'),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                style: TextStyle(fontSize: 20)),
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
                                                style: TextStyle(fontSize: 20)),
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
              margin: EdgeInsets.only(top: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              SizedBox(
                width:300,
                height:50,
                                child:     TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Họ Tên',
                      ),
                    ),
              ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Khoá ',
                          ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Lớp',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Điện thoại',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Giới thiệu bản thân',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                width: 300,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'XÁC NHẬN',
                      style: TextStyle(color: Colors.white),
                    ))),
          ],
        ),
      ),
    );
  }
}
