// ignore_for_file: unused_import

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Create extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Create_State();
}

class Create_State extends State<Create> {
  TextEditingController gia = TextEditingController();
    TextEditingController ten = TextEditingController();
  final String url = 'http://10.0.2.2:8000/api/products';
  List<Data> data = [];
  List<Data> filteredData = [];
  void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông báo'),
        content: Text('Thêm thành công!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  void fetchData() async {
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.post(Uri.parse(url),  body: {
        'name': ten.text,
        'price': gia.text,
      },headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Sản phẩm được tạo thành công!');
     
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create API')),
        body: Container(
          height: 300,
          child: Column(
            children: [
              TextField(
                controller: ten,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tên',
                ),
              ),
              TextField(
                controller: gia,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Giá',
                ),
              ),
               OutlinedButton(
                          onPressed: () {
                           fetchData();
                           
                          },
                          child: Text(
                            'Thêm',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
            ],
          ),
        ));
  }
}
