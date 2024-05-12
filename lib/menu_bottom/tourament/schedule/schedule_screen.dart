// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'match-details_screen.dart';

class Schedule_Screen extends StatefulWidget {
  const Schedule_Screen({super.key});

  @override
  State<Schedule_Screen> createState() => _Schedule_ScreenState();
}

class _Schedule_ScreenState extends State<Schedule_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          'Lịch thi đấu',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // BẢNG A
            Container(
              color: Colors.teal[900],
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'BẢNG A',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Trận 01
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 1'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 01'),
                          Image.asset(
                            'images/logo1.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('01/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo2.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 02'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trận 02
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 2'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 03'),
                          Image.asset(
                            'images/logo3.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('01/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo4.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 04'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trận 03
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 3'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 01'),
                          Image.asset(
                            'images/logo1.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('02/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo3.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 03'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trận 04
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 4'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 02'),
                          Image.asset(
                            'images/logo2.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('02/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo4.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 04'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trận 05
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 5'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 01'),
                          Image.asset(
                            'images/logo1.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('03/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo4.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 04'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trận 06
            FractionallySizedBox(
              widthFactor: 1,
              child: SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade50),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text('Trận 1'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đội bóng 02'),
                          Image.asset(
                            'images/logo2.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('03/06'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'images/logo3.png',
                            height: 50,
                            width: 50,
                          ),
                          const Text('Đội bóng 03'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // BẢNG B
            Container(
              color: Colors.teal[900],
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'BẢNG B',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Trận 01
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Text('Trận 1'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 01'),
                      Image.asset(
                        'images/logo1.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('01/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo2.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 02'),
                    ],
                  ),
                ],
              ),
            ),
            // Trận 02
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 2'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 03'),
                      Image.asset(
                        'images/logo3.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('01/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo4.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 04'),
                    ],
                  ),
                ],
              ),
            ),
            // Trận 03
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 3'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 01'),
                      Image.asset(
                        'images/logo1.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('02/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo3.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 03'),
                    ],
                  ),
                ],
              ),
            ),
            // Trận 04
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 4'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 02'),
                      Image.asset(
                        'images/logo2.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('02/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo4.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 04'),
                    ],
                  ),
                ],
              ),
            ),
            // Trận 05
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 5'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 01'),
                      Image.asset(
                        'images/logo1.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('03/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo4.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 04'),
                    ],
                  ),
                ],
              ),
            ),
            // Trận 06
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 6'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đội bóng 02'),
                      Image.asset(
                        'images/logo2.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('03/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo3.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Đội bóng 03'),
                    ],
                  ),
                ],
              ),
            ),
            // BÁN KẾT
            Container(
              color: Colors.brown[700],
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'BÁN KẾT',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //Trận BÁN KẾT 1
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 1'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Nhất bảng A'),
                      Image.asset(
                        'images/logo1.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('05/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo2.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Nhì bảng B'),
                    ],
                  ),
                ],
              ),
            ),
            //Trận BÁN KẾT 2
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                      ),
                      child: const Text('Trận 2'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Nhất bảng b'),
                      Image.asset(
                        'images/logo3.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('05/06'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'images/logo4.png',
                        height: 50,
                        width: 50,
                      ),
                      const Text('Nhì bảng A'),
                    ],
                  ),
                ],
              ),
            ),
            // CHUNG KẾT
            Container(
              color: Colors.lightGreen[800],
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'CHUNG KẾT',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //Trận CHUNG KẾT
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nhất bảng A'),
                  Image.asset(
                    'images/logo1.png',
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '-',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('07/06'),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'images/logo2.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text('Nhì bảng B'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDetails() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatchDetails_Screen()),
        );
      },
    );
  }
}
