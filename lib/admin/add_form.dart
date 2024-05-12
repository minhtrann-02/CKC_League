import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Add_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Add_Form_State();
}

class Add_Form_State extends State<Add_Form> {
  final numberFormatter = FilteringTextInputFormatter.digitsOnly;
  String? ten_hinh_thuc = '';
  String? noi_dung = '';
  String access_token = '';
  int? so_doi_toi_thieu = 0;
  int? so_tran_toi_thieu = 0;
  int selectedId = 0;
  int? id = 0;
  late List<Data> dataList = [];
  TextEditingController noidung = TextEditingController();
  TextEditingController tenhinhthuc = TextEditingController();
  TextEditingController sotran = TextEditingController();
  TextEditingController sodoi = TextEditingController();

 Future<int> getMaxId() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/HinhThuc?token=$access_token';
  final response = await http.get(Uri.parse(url), headers: {'User-Agent': 'MyApp/1.0'});

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<dynamic> data = responseData['data'];

    int maxId = data.fold(0, (prev, item) => item['id'] > prev ? item['id'] : prev);
    return maxId + 1;
  } else {
    throw Exception('Failed to load data');
  }
}
  void showSuccessDialog(BuildContext context) {
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
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text('Thêm hình thức thành công'),
          actions: [
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
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
  }

  void addform() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/HinhThuc?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    print('hi: $access_token');
    print(noidung.text);
    print(tenhinhthuc.text);
    print(sotran.text.toString());
    print(sodoi.text.toString());
     final maxId = await getMaxId();
    print(maxId.toString());
    final response = await http.post(Uri.parse(url),
        body: {
          'id': maxId.toString(),
          'noi_dung': noidung.text,
          'ten_hinh_thuc': tenhinhthuc.text,
          'so_tran_toi_thieu': sotran.text.toString(),
          'so_doi_toi_thieu': sodoi.text.toString(),
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm hình thức thành công ');
        showSuccessDialog(context);
        tenhinhthuc.clear();
        noidung.clear();
        sodoi.clear();
        sotran.clear();

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFA011129),
          title: Text('Thêm hình thức'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'Nhập đầy đủ thông tin',
                  style: TextStyle(fontFamily: 'BodoniModa', fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên hình thức: ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          child: TextFormField(
                            controller: tenhinhthuc,
                            decoration: const InputDecoration(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nội dung: ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: noidung,
                                  maxLines: 2,
                                  decoration: const InputDecoration(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số trận tối thiểu: ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        inputFormatters: [numberFormatter],
                                        keyboardType: TextInputType.number,
                                        controller: sotran,
                                        decoration: const InputDecoration(),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Số đội tối thiểu: ',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Container(
                                            child: TextFormField(
                                              inputFormatters: [
                                                numberFormatter
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: sodoi,
                                              decoration:
                                                  const InputDecoration(),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // saveData();
                                      addform();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFA011129)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'THÊM',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]))
            ]))));
  }
}
