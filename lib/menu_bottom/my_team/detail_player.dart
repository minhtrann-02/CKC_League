// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';

class Detail_Player extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Detail_Player_State();
}

class Detail_Player_State extends State<Detail_Player> {
  String access_token = '';
  int selectedId = 0;
  String ten = '';
  String vitri = '';
  int soao = 0;
  String avatar = 'images/user.png';
  String vaitro = '';
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    selectedId = prefs.getInt('selectedId') ?? 0;
    String url = 'http://10.0.2.2:8000/api/auth/players/$selectedId';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.statusCode);
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      ten =
          responseData['data']['ten_cau_thu']; // Lấy giá trị 'ten' từ response
      soao = responseData['data']['so_ao']; // Lấy giá trị 'so_ao' từ response
      avatar = responseData['data']['avatar'];
      vitri = responseData['data']['vi_tri'];
      vaitro = responseData['data']['vai_tro'];
      setState(() {
        
      });
      // In ra các giá trị đã lấy được từ API
      print('Tên: $ten');
      print('Số áo: $soao');
      print('Vi tri: $vitri');
      print('Avatar: $avatar');
      print('Vai tro: $vaitro');
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color(0xFA011129),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
          title: Text('Chi tiết thành viên'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            Container(
              color: Color(0xFA011129),
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ten,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Container(
                              // width: 20,
                              // height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                 color: Colors.green,
                              ),
                              padding: EdgeInsets.all(5),
                             
                              child: Text(vaitro,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)))
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(avatar),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(FontAwesomeIcons.tshirt,
                                    color: Colors.grey, size: 25),
                              ),
                              Row(
                                children: [
                                  Text('Số ', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 5),
                                   Text(soao.toString(), style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(FontAwesomeIcons.futbol,
                                    color: Colors.grey, size: 25),
                              ),
                              Text(vitri, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(Icons.calendar_month_outlined,
                                    color: Colors.grey, size: 25),
                              ),
                              Text('Chưa có ngày sinh',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black54)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(Icons.phone,
                                    color: Colors.grey, size: 25),
                              ),
                              Text('Chưa có số điện thoại',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black54)),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text('GIẢI ĐẤU',
                            style: TextStyle(
                              fontFamily: 'Bitter',
                              fontSize: 20,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/tshirt.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Giải tham dự ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              child: Row(children: [
                                Image.asset('images/silver-cup.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Giải nhì ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Image.asset('images/cup4.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Giải tư ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, left: 50),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/gold-cup.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Vô địch ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15, left: 50),
                              child: Row(children: [
                                Image.asset('images/bronze-cup.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Giải ba ',
                                        style:
                                            TextStyle(fontFamily: 'BodoniModa'),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              color: Colors.blue,
                              child: SizedBox(
                                height: 50,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('TRẬN ĐẤU',
                            style: TextStyle(
                              fontFamily: 'Bitter',
                              fontSize: 20,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/flag_grey.png',
                                        width: 50, height: 50),
                                    Container(
                                      // margin: EdgeInsets.only(left: 10,right:10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Trận tham gia ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              child: Row(children: [
                                Image.asset('images/flag_yellow.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Trận hoà ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, left: 50),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/flag_green.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Trận thắng ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15, left: 40),
                              child: Row(children: [
                                Image.asset('images/flag_red.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Trận thua ',
                                        style:
                                            TextStyle(fontFamily: 'BodoniModa'),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('GHI BÀN',
                            style: TextStyle(
                              fontFamily: 'Bitter',
                              fontSize: 20,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/theball.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Bàn thắng ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              child: Row(children: [
                                Image.asset('images/theball_2.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Cú đúp ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Image.asset('images/theball_4.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Poker ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, left: 80),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/the red ball.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Phản lưới',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15, left: 70),
                              child: Row(children: [
                                Image.asset('images/theball_3.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Hattrick',
                                        style:
                                            TextStyle(fontFamily: 'BodoniModa'),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              color: Colors.blue,
                              child: SizedBox(
                                height: 50,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('THẺ PHẠT',
                            style: TextStyle(
                              fontFamily: 'Bitter',
                              fontSize: 20,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/yellow_card.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Thẻ vàng ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              child: Row(children: [
                                Image.asset('images/thecard.png',
                                    width: 50, height: 50),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('Thẻ đỏ gián tiếp ',
                                          style: TextStyle(
                                              fontFamily: 'BodoniModa'))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, left: 50),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('images/red_card.png',
                                        width: 50, height: 50),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Thẻ đỏ',
                                              style: TextStyle(
                                                  fontFamily: 'BodoniModa'))
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              color: Colors.blue,
                              child: SizedBox(
                                height: 50,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ))));
  }
}
