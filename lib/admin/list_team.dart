// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class List_Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => List_Team_State();
}

class List_Team_State extends State<List_Team> {
  String quality = '';
  int teamCount = 0;
  int nguoiquanlyid = 0;
  String selectedValue = 'Tất cả';
  List<Data> searchResults = [];
  List<Data> displayedList = [];
  bool isSearching = false;
  String searchQuery = '';
  int selectedIndex = -1;
  String access_token = '';
  bool hasTeams = false; // Biến để kiểm tra số đội
  late List data;
  List<Data> dataList = []; // Khởi tạo một mảng mới

  void fetchData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/football?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        dataList = data.map((x) => Data.fromJson(x)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchData(String selectedValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/football?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['data'] != null) {
        dataList = (responseData['data'] as List)
            .map((item) => Data.fromJson(item))
            .toList();
      } else {
        dataList = []; // Đặt danh sách là rỗng nếu không có dữ liệu
      }

      if (selectedValue != 'Tất cả') {
        // Lọc danh sách nếu giá trị combobox khác "Tất cả"
        dataList = dataList
            .where((item) => item.khoa == int.parse(selectedValue))
            .toList();
      }

      teamCount = dataList.length; // Cập nhật giá trị của teamCount

      setState(() {
        // Cập nhật giá trị số lượng đội bóng để hiển thị trên màn hình
        quality = teamCount.toString();
        hasTeams = teamCount > 0; // Kiểm tra nếu có đội thì hasTeams = true
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void handleRowTap(int index) {
    setState(() {
      selectedIndex = index; // Cập nhật chỉ số của dòng được chọn
      final selectedDataItem =
          dataList[index]; // Lấy dữ liệu của dòng được chọn
      print(
          'Selected ID: ${selectedDataItem.id}'); // In ra ID của dòng được chọn
    });
  }

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
                    setState(() {
                      selectedValue = 'Tất cả';
                      print('Giá trị chọn là Tất cả');
                    });
                    fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Tất cả',
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
                    setState(() {
                      selectedValue = '2020';
                      print('Giá trị chọn là $selectedValue');
                    });
                    fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '2020',
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
                  setState(() {
                    selectedValue = '2021';
                    print('Giá trị chọn là $selectedValue');
                  });
                  fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  '2021',
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
                  setState(() {
                    selectedValue = '2022';
                    print('Giá trị chọn là $selectedValue');
                  });
                  fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  '2022',
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
    ).then((value) {
      // Xử lý khi giá trị combobox được chọn
      if (value != null) {
        setState(() {
          selectedValue = value;
        });
        fetchData(selectedValue); // Gọi hàm fetchData() để cập nhật danh sách
      }
    });
  }
   Future<void> deleteProduct(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    selectedIndex = index;
    final selectedDataItem = dataList[index];
    print('Giá trị chọn là $selectedIndex');
    final url = Uri.parse(
        'http://10.0.2.2:8000/api/auth/football/${selectedDataItem.id}?token=$access_token');
    final response = await http.delete(url);

    print("Giá trị 2 là:${selectedDataItem.id}");
    if (response.statusCode == 200) {
      print('Xóa đội thành công!');
    } else {
      // Xử lý lỗi
      print('Lỗi: ${response.statusCode}');
    }
  }

  void searchInDataList(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        isSearching = true;
        searchResults = dataList.where((dataItem) {
          return dataItem.id.toString().toLowerCase().contains(query) ||
              dataItem.tenDoiBong!.toLowerCase().contains(query) ||
              dataItem.sl_thanh_vien.toString().toLowerCase().contains(query) ||
              dataItem.lop.toString().toLowerCase().contains(query) ||
              dataItem.khoa.toString().toLowerCase().contains(query);
        }).toList();
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

   void showAlertNotification(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded, // Icon logout
                color: Colors.orange,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'BodoniModa',
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text(
                'Bạn chưa chọn giá trị!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'BodoniModa',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'BodoniModa',
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
   void showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.delete, // Icon logout
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Xoá đội bóng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text(
                'Bạn muốn xoá đội bóng này?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Xoá',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Đóng hộp thoại
                      deleteProduct(productId); // Xoá sản phẩm
                      fetchData1();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Đã xoá đội bóng'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Đóng hộp thoại thông báo
                                  setState(() {});
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Huỷ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Xử lý khi người dùng chọn không đăng xuất ở đây
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
   void _showAddRefereeDialog(BuildContext context) {
    String fullName = '';
    String position = '';
    final screenWidth_1 = MediaQuery.of(context).size.width;
    final buttonWidth_1 = screenWidth_1 * 0.4;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm đội bóng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                // controller: hoten,
                onChanged: (value) {
                  fullName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Họ tên',
                ),
              ),
              Container(
                  child: Row(children: [
                Text('Vị trí: '),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  onPressed: () {
                    _showMenuStatus(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(
                        color: Colors.grey), // Màu sắc và độ dày của viền
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Độ cong góc viền
                    ),
                    minimumSize: Size(buttonWidth_1,
                        0), // Đặt chiều rộng tối thiểu cho button
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedValue,
                        style: TextStyle(fontSize: 15),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                      )
                    ],
                  ),
                ),
              ]))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedValue == 'Chọn giá trị') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Vui lòng chọn vị trí!'),
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
                } else {
                  // Thực hiện thêm trọng tài với họ tên và vị trí đã nhập
                  // _addReferee(hoten.text, position);

                  // Đóng hộp thoại
                  Navigator.of(context).pop();
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                // Đóng hộp thoại
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    data = [];
    fetchData(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth_1 = MediaQuery.of(context).size.width;
    final buttonWidth_1 = screenWidth_1 * 0.4; // Tỉ lệ màn hình mong muốn
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFA011129),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Danh sách đội bóng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Điều hướng trở lại trang trước
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Tìm kiếm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                searchInDataList(value);
              },
            ),
          ),
        ),
         actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Xoá',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.black),
                  title: Text('Xoá', style: TextStyle(color: Colors.black)),
                ),
              ),
            
            ],
            onSelected: (String value) {
              if (value == 'Xoá') {
                print('Lựa chọn: $value');
                print(selectedIndex);
                if (selectedIndex != -1) {
                  showDeleteConfirmationDialog(context, selectedIndex);
                } else {
                  showAlertNotification(context, selectedIndex);
                }
              } 
            },
          )
        ],
      ),
      body: Container(
          child: Column(children: [
        Container(
          height: 50,
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  _showMenuStatus(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(
                      color: Colors.grey), // Màu sắc và độ dày của viền
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Độ cong góc viền
                  ),
                  minimumSize: Size(
                      buttonWidth_1, 0), // Đặt chiều rộng tối thiểu cho button
                ),
                child: Row(
                  children: [
                    Text(
                      selectedValue,
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
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTableTheme(
              data: DataTableThemeData(
                headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.black), // Đổi màu của dòng tiêu đề thành màu xanh
              ),
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('ID', style: TextStyle(color: Colors.white))),
                        DataColumn(
                      label: Text('Logo',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Tên đội ',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: SizedBox(
                          width: 100,
                          child: Text('Số lượng thành viên',
                              style: TextStyle(color: Colors.white)))),
                  DataColumn(
                      label:
                          Text('Lớp', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label:
                          Text('Khoá', style: TextStyle(color: Colors.white))),
                ],
                rows: (isSearching ? searchResults : dataList)
                    .asMap()
                    .entries
                    .map(
                  (entry) {
                    final index = entry.key;
                    final dataItem = entry.value;

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            dataItem.id.toString(),
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                            ),
                          ),
                        ),
                         DataCell(
                          Image.asset('${dataItem.logo}',width:30),
                          // Text(
                          //   dataItem.logo ?? '',
                          //   style: TextStyle(
                          //     color: selectedIndex == index
                          //         ? Colors.blue
                          //         : Colors
                          //             .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                          //   ),
                          // ),
                        ),
                        DataCell(
                          Text(
                            dataItem.tenDoiBong ?? '',
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            dataItem.sl_thanh_vien.toString(),
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Hiển thị dấu "..." khi quá dài
                            maxLines: 1, // Giới hạn chỉ hiển thị 1 dòng
                          ),
                        ),
                        DataCell(
                          Text(
                            dataItem.lop.toString(),
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            dataItem.khoa.toString(),
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .black, // Đổi màu chữ của dòng được chọn thành màu xanh
                            ),
                          ),
                        ),
                      ],
                      onSelectChanged: (isSelected) {
                        setState(() {
                          if (isSelected != null && isSelected) {
                            selectedIndex = index;
                            handleRowTap(
                                index); // Lưu chỉ số của dòng được chọn
                          }
                        });
                      },
                      selected: selectedIndex == index,
                    );
                  },
                ).toList(),
              ),
            ),
            )
          ),
        )
      ])),
    );
  }
}
