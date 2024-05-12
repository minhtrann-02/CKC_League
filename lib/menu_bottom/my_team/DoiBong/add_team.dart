// ignore_for_file: camel_case_types, depend_on_referenced_packages, unused_import

import 'package:ckc_league/menu_bottom/home_page.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/choice_Image.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/contact_info.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/my_team.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_Team extends StatefulWidget {
  const Add_Team({super.key});

  @override
  State<StatefulWidget> createState() => Add_Team_State();
}

class Add_Team_State extends State<Add_Team> {
  String selectedValue = '';
  bool showBottomSheet = false;
  TextEditingController tendoi = TextEditingController();
  TextEditingController lop = TextEditingController();
  String selectedImageName = 'images/logo1.png';
  bool _showErrorTenDoi = false;
  bool _showErrorLop = false;
  @override
  void initState() {
    super.initState();
    getSelectedImageName();
  }

  // Future<void> initializeSharedPreferences() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  // }

  Future<void> getSelectedImageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedImageName =
          prefs.getString('selectedImageName') ?? 'images/logo1.png';
      prefs.setString('selectedImageName1', selectedImageName);
      print('image là: $selectedImageName');
    });
  }

  void _handleContinueButton() {
    String tenDoi = tendoi.text;
    String Lop = lop.text;
    setState(() {
      // Kiểm tra nếu người dùng không nhập giá trị
      if (tendoi.text.isEmpty) {
        _showErrorTenDoi = true; // Hiển thị thông báo lỗi cho trường SĐT
      } else {
        _showErrorTenDoi = false; // Xóa thông báo lỗi cho trường SĐT (nếu có)
      }
      if (lop.text.isEmpty) {
        _showErrorLop = true; // Hiển thị thông báo lỗi cho trường Email
      } else {
        _showErrorLop = false; // Xóa thông báo lỗi cho trường Email (nếu có)
      }

      // Kiểm tra nếu không có thông báo lỗi cho bất kỳ trường nào
      if (!_showErrorTenDoi && !_showErrorLop) {
        saveData('ten_doi', tenDoi);
        saveData('lop', Lop);
        print('gia trị chọn trong hàm handle: $selectedValue');
        print('gia trị chọn trong hàm handle: $tenDoi');
        print('gia trị chọn trong hàm handle: $Lop');
        saveSelectedValue(selectedValue);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Contact_Info()),
        );
        // Tiếp tục xử lý logic tiếp theo
      }
    });
  }

  void saveSelectedValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_value', value);
  }

  void saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
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
//                    Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => My_team()),
//   (Route<dynamic> route) => false,
// );
                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home_Page()));
                        
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
                  'Thông tin cơ bản',
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
            child: Column(
              children: [
                Column(
                
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              '$selectedImageName',
                              width: 100,
                              height: 90,
                              // fit: BoxFit.cover, // Phù hợp vớis vùng cắt
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
                                              Text('Chọn ảnh có sẵn',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Choice_Image()));
                                          },
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
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Text('Tên đội:',style:TextStyle(fontSize:18)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left:10,right:10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: tendoi,
                                  onChanged: (value) {
                                    setState(() {
                                      _showErrorTenDoi = false;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Tên đội',
                                    hintStyle: TextStyle(fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    errorText: _showErrorTenDoi
                                        ? 'Vui lòng nhập tên đội'
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   margin: EdgeInsets.only(bottom: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         width: 300,
                    //         height: 40,
                    //         child: TextField(
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(),
                    //             hintText: 'Tên viết tắt ',
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width:10
                            ),
                            Text('Khóa:',style:TextStyle(fontSize:18)),
                          ],
                        ),
                        Container(
                          // margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showBottomSheet = true;
                                  });
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                               backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                // shape: RoundedRectangleBorder(
                                                //   borderRadius:
                                                //       BorderRadius.circular(20.0),
                                                // ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '2020',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedValue = '2020';
                                                });
                                                print(selectedValue);
                                                saveSelectedValue(selectedValue);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                               backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                // shape: RoundedRectangleBorder(
                                                //   borderRadius:
                                                //       BorderRadius.circular(20.0),
                                                // ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '2021',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedValue = '2021';
                                                });
                                                print(selectedValue);
                                                saveSelectedValue(selectedValue);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                               backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                // shape: RoundedRectangleBorder(
                                                //   borderRadius:
                                                //       BorderRadius.circular(20.0),
                                                // ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '2022',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedValue = '2022';
                                                });
                                                print(selectedValue);
                                                saveSelectedValue(selectedValue);
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
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                          child: selectedValue.isNotEmpty
                                              ? Text(
                                                  selectedValue,
                                                  style: TextStyle(fontSize: 18),
                                                )
                                              : Text(
                                                  'Khoá',
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Text('Lớp:',style:TextStyle(fontSize:18)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left:10,right:10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: lop,
                                  onChanged: (value) {
                                    setState(() {
                                      _showErrorLop = false;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Lớp',
                                    hintStyle: TextStyle(fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    errorText:
                                        _showErrorLop ? 'Vui lòng nhập lớp' : null,
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
                        margin: EdgeInsets.only(top: 80),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                )
              ],
            ),
          ),
        ));
  }
}
