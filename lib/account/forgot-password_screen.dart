// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Forgot_Screen extends StatefulWidget {
  const Forgot_Screen({super.key});

  @override
  State<Forgot_Screen> createState() => _Forgot_ScreenState();
}

class _Forgot_ScreenState extends State<Forgot_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
        child: Column(
          children: [
            const Text(
              'Vui lòng nhập địa chỉ email của bạn đã đăng ký để nhận hướng dẫn',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email",
                  // contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.99,
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text(
                    'GỬI',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
