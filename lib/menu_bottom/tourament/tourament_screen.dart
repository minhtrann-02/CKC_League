// ignore_for_file: camel_case_types, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import '../home/notification.dart';
import '../home/search.dart';
import 'infor-tourament_srceen.dart';

class Tourament_Screen extends StatefulWidget {
  const Tourament_Screen({Key? key});

  @override
  State<StatefulWidget> createState() => Tourament_Screen_State();
}

class Tourament_Screen_State extends State<Tourament_Screen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth_1 = MediaQuery.of(context).size.width;
    final buttonWidth_1 = screenWidth_1 * 0.4; // Tỉ lệ màn hình mong muốn
    final screenWidth_2 = MediaQuery.of(context).size.width;
    final buttonWidth_2 = screenWidth_2 * 0.3;

    // ignore: no_leading_underscores_for_local_identifiers
    void _showMenuStatus(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.green,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text(
                        'Chọn giá trị',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Trạng thái',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  )),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Đang đăng ký',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hoạt động',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Kết thúc',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _showMenuForm(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.green,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text(
                        'Chọn giá trị',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Hình thức',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  )),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Loại trực tiếp',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Đấu vòng tròn',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Chia bảng đấu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
          title: const Text(
            'Giải đấu',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: onNotification,
              icon: const Icon(Icons.notifications_rounded),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'Tất cả giải',
                ),
              ),
              Tab(
                child: Text(
                  'Giải của tôi',
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _showMenuStatus(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              side: const BorderSide(
                                  color: Colors
                                      .grey), // Màu sắc và độ dày của viền
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Độ cong góc viền
                              ),
                              minimumSize: Size(buttonWidth_1,
                                  0), // Đặt chiều rộng tối thiểu cho button
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Trạng thái',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                )
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _showMenuForm(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              side: const BorderSide(
                                  color: Colors
                                      .grey), // Màu sắc và độ dày của viền
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Độ cong góc viền
                              ),
                              minimumSize: Size(buttonWidth_1,
                                  0), // Đặt chiều rộng tối thiểu cho button
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Hình thức',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '3 Giải đấu',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              side: const BorderSide(
                                  color: Colors
                                      .grey), // Màu sắc và độ dày của viền
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Độ cong góc viền
                              ),
                              minimumSize: Size(buttonWidth_2,
                                  0), // Đặt chiều rộng tối thiểu cho button
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Sắp xếp',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 14,
              child: TabBarView(
                children: [
                  ListView(
                    children: <Widget>[
                      ListTile(
                        title: ElevatedButton(
                          onPressed: onInforTourament,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 25,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Hoạt động',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Giải bóng đá khoa CNTT 2023',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                const Text(
                                  '5/10 trận',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                LinearProgressIndicator(
                                  value: 0.5,
                                  minHeight: 5,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                                const Text(
                                  'Chia bảng đấu',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Khoa CNTT',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Sân Hiếu Hoàng Long - C19/7B4 Ấp 4B, Bình Hưng, Bình Chánh, TP.HCM',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: onInforTourament,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 25,
                                  width: 120,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Đang đăng ký',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Giải bóng đá toàn trường 2023',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                const Text(
                                  '0/20 trận',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                LinearProgressIndicator(
                                  value: 0,
                                  minHeight: 5,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                                const Text(
                                  'Chia bảng đấu',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Trường CĐKT Cao Thắng',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Sân Hiếu Hoàng Long - C19/7B4 Ấp 4B, Bình Hưng, Bình Chánh, TP.HCM',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: onInforTourament,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 25,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Kết thúc',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Giải bóng đá giao hữu 2023',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                const Text(
                                  '10/10 trận',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                LinearProgressIndicator(
                                  value: 1,
                                  minHeight: 5,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                                const Text(
                                  'Chia bảng đấu',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Khoa CNTT',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  'Sân Hiếu Hoàng Long - C19/7B4 Ấp 4B, Bình Hưng, Bình Chánh, TP.HCM',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 130,
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Giải bóng đá khoa CNTT 2023',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text(
                                '0/10 trận',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Chia bảng đấu',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Khoa CNTT',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Sân Hiếu Hoàng Long - C19/7B4 Ấp 4B, Bình Hưng, Bình Chánh, TP.HCM',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Hình ảnh nè'),
                              Text('Chỗ này là icon nè')
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Navigator
  void onSearch() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Search()),
      );
    });
  }

  void onNotification() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Notification_Scren()),
      );
    });
  }

  void onInforTourament() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InforTouament()),
      );
    });
  }
}
