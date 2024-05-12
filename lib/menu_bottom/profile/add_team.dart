import 'package:ckc_league/menu_bottom/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class Add_Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Add_Team_State();
}

class Add_Team_State extends State<Add_Team> {
  bool showBottomSheet = false;
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile_Screen()),
                      );
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
                )
              ],
            ),
          ),
        ),
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
                                color: Colors.black,
                                width: 1), // Viền màu đen độ dày 2
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Độ cong bo tròn (0 để tạo hình vuông)
                            child: Image.asset(
                              'images/logo1.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover, // Phù hợp với vùng cắt
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
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Tên đội',
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
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Khoá ',
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
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Khoá ',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
