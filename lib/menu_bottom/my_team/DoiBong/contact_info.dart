// ignore_for_file: depend_on_referenced_packages, unused_local_variable, unnecessary_null_comparison

import 'package:ckc_league/menu_bottom/my_team/DoiBong/other_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact_Info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Contact_Info_State();
}

class Contact_Info_State extends State<Contact_Info> {
  TextEditingController sdt = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController ten = TextEditingController();
  bool _showErrorSDT = false;
  bool _showErrorEmail = false;
  bool _showErrorTen = false;
  void _handleContinueButton() {
    String SDT = sdt.text;
    String Email = email.text;
    String TenLienHe = ten.text;
    bool isValidSDT = false;
    setState(() {
      // Kiểm tra nếu người dùng không nhập giá trị
      if (sdt.text.isEmpty) {
        _showErrorSDT = true; // Hiển thị thông báo lỗi cho trường SĐT
      }else if(SDT.length != 10 || !isNumeric(SDT)){
    _showErrorSDT = true; // Hiển thị thông báo lỗi cho trường SĐT không hợp lệ
      } else {
        _showErrorSDT = false; // Xóa thông báo lỗi cho trường SĐT (nếu có)
      }
      if (email.text.isEmpty) {
        _showErrorEmail = true; // Hiển thị thông báo lỗi cho trường Email
      } else {
        _showErrorEmail = false; // Xóa thông báo lỗi cho trường Email (nếu có)
      }
      if (ten.text.isEmpty) {
        _showErrorTen = true; // Hiển thị thông báo lỗi cho trường Tên
      } else {
        _showErrorTen = false; // Xóa thông báo lỗi cho trường Tên (nếu có)
      }

      // Kiểm tra nếu không có thông báo lỗi cho bất kỳ trường nào
      if (!_showErrorSDT && !_showErrorEmail && !_showErrorTen) {
        saveData('SDT', SDT);
        saveData('Email', Email);
        saveData('TenLienHe', TenLienHe);
        print('gia trị chọn trong hàm handle: $SDT');
        print('gia trị chọn trong hàm handle: $Email');
        print('gia trị chọn trong hàm handle: $TenLienHe');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Other_Info()),
        );
        // Tiếp tục xử lý logic tiếp theo
      }
    });
  }

  void saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
bool isNumeric(String value) {
  if (value == null) {
    return false;
  }
  return double.tryParse(value) != null;
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
                'Thông tin liên hệ',
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
          //backgroundColor: Colors.white,
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width:10),
                      Text('Số điện thoại:',style:TextStyle(fontSize:18)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10,right:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: sdt,
                            onChanged: (value) {
                              setState(() {
                                _showErrorSDT = false;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: ' Số điện thoại',
                              hintStyle: TextStyle(fontSize: 18),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              errorText:
                                  _showErrorSDT ? 'SĐT không hợp lệ' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width:10),
                      Text('Email:',style:TextStyle(fontSize:18)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10,right:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _showErrorEmail = false;
                              });
                            },
                            controller: email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 18),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              errorText:
                                  _showErrorEmail ? 'Email không được trống' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width:10),
                      Text('Tên người liên hệ:',style:TextStyle(fontSize:18)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10,right:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ten,
                            onChanged: (value) {
                              setState(() {
                                _showErrorTen = false;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Tên người liên hệ',
                              hintStyle: TextStyle(fontSize: 18),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              errorText: _showErrorTen
                                  ? 'Tên người liên hệ không được trống'
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _handleContinueButton();
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
                      'TIẾP TỤC',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
