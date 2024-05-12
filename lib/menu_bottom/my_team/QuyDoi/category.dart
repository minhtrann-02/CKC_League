import 'package:ckc_league/menu_bottom/my_team/QuyDoi/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Category_State();
}

class Category_State extends State<Category> {
  int? selectedRadio;
  late SharedPreferences prefs;
  late String text;
   @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
      });
    });
  }

    String getText(int? selectedRadio) {
    if (selectedRadio == 1) {
      return 'Đóng quỹ';
    } else if (selectedRadio == 2) {
      return 'Giải thưởng';
    } else if (selectedRadio == 3) {
      return 'Tài trợ';
    } else {
      return '';
    }
  }
    void setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
    prefs.setInt('selectedRadio', val!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Transaction()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chọn danh mục',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Điều hướng trở lại trang trước
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THU',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Đóng quỹ'),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
  value: 2,
  groupValue: selectedRadio,
  onChanged: (val) {
    setSelectedRadio(val as int?);
   
  },
  title: Text('Giải thưởng'),
),

                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Tài trợ'),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    value: 4,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Sân bãi'),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
                    value: 5,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Ăn uống'),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
                    value: 6,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Dụng cụ, công cụ'),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
                    value: 7,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Phí tham gia giải đấu'),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black26,
                  ),
                  RadioListTile(
                    value: 8,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int?);
                    },
                    title: Text('Thăm hỏi thành viên'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
