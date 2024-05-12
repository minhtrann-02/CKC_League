import 'package:flutter/material.dart';

class Ranking_Screen extends StatefulWidget {
  const Ranking_Screen({super.key});

  @override
  State<Ranking_Screen> createState() => _Ranking_ScreenState();
}

class _Ranking_ScreenState extends State<Ranking_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          'Bảng xếp hạng',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bảng A
            Container(
              color: const Color(0xFA011129),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Bảng A',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '#   Đội',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Trận',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'T-H-B',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Hiệu số',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Điểm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Đội bóng 1
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo1.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 01',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 2
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo2.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 02',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 3
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '3',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo3.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 03',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 4
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '4',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo4.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 04',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bảng B
            Container(
              color: const Color(0xFA011129),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Bảng B',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '#   Đội',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Trận',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'T-H-B',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Hiệu số',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Điểm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Đội bóng 1
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo1.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 01',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 2
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo2.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 02',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 3
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '3',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo3.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 03',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Đội bóng 4
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Text(
                          '4',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            'images/logo4.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                        const Text(
                          'Đội bóng 04',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16)),
                              TextSpan(
                                  text: '-0-', style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '0',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 40),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
