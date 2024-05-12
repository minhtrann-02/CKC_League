import 'package:flutter/material.dart';

import 'schedule/schedule_screen.dart';

class InforTouament extends StatefulWidget {
  const InforTouament({Key? key}) : super(key: key);

  @override
  State<InforTouament> createState() => _InforTouamentState();
}

class _InforTouamentState extends State<InforTouament> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset('images/ckcbanner2.jpg'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Tên giải đấu
                    const Text(
                      'GIẢI ĐẤU',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'Bóng đá khoa CNTT 2023',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    //Thông tin giải đấu
                    Table(
                      children: const [
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                'Hình thức',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Chia bảng đấu',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Gạch ngang giữa các dòng
                        TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                'Ban tổ chức',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Khoa CNTT',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                'Địa điểm',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Sân Hiếu Hoàng Long',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //Quản lý giải đấu
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'QUẢN LÝ GIẢI ĐẤU',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50, // Chiều cao của menu
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: onSchedule,
                              child: const Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    'Lịch thi đấu',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Icon(Icons.group),
                                  SizedBox(width: 10),
                                  Text(
                                    'Bảng xếp hạng',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade300),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Icon(Icons.group),
                                  SizedBox(width: 10),
                                  Text(
                                    'Đội thi đấu',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey.shade300),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.align_vertical_bottom_rounded),
                                SizedBox(width: 10),
                                Text(
                                  'Thống kê',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Thống kê tổng quát
                    const SizedBox(height: 25),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'THỐNG KÊ TỔNG QUÁT',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4E4E4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/group.png',
                                  height: 60,
                                  width: 60,
                                ),
                                const Text(
                                  '8',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Đội bóng',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/flag_grey.png',
                                  height: 60,
                                  width: 60,
                                ),
                                const Text(
                                  '16',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Trận đấu',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSchedule() {
    setState(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Schedule_Screen()),
        );
      },
    );
  }
}
