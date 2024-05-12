// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Test extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Test_State();
}
class Test_State extends State<Test>{
void initState(){
super.initState();
connectToAPI();
}
  Future<void> connectToAPI() async {
  final url = Uri.parse('http://192.168.70.91:8000/api/auth/login');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'email': 'admin@vinasupport.com', 'password': '123456'});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final accessToken = jsonResponse['access_token'];

    print('Access Token: $accessToken');
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
  @override
  Widget build(BuildContext context ){
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
    );
  }
}