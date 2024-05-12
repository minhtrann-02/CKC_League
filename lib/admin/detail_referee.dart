// ignore_for_file: unused_import

import 'dart:io';
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
class Detail_Referee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Detail_Referee_State();
}
class Detail_Referee_State extends State<Detail_Referee>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cập nhật trọng tài'),
         leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
      ),
    );
  }
}