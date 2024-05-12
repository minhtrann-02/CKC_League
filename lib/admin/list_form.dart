import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/add_form.dart';
import 'package:ckc_league/admin/detail_form.dart';
import 'package:ckc_league/admin/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class List_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => List_Form_State();
}

class List_Form_State extends State<List_Form> {
  int selectedIndex = -1;
  late List data;
  late List<Data> dataList = [];
  List<Data> searchResults = [];
  List<Data> displayedList = [];
  bool isSearching = false;
  String searchQuery = '';
      String access_token ='';
  // final String url = 'http://192.168.70.91:8000/api/auth/HinhThuc';
  void fetchData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
        access_token = prefs.getString('accessToken') ?? '';
     final String url = 'http://10.0.2.2:8000/api/auth/HinhThuc?token=$access_token';
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

  Future<void> deleteProduct(int index) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
        access_token = prefs.getString('accessToken') ?? '';
    selectedIndex = index;
    final selectedDataItem = dataList[index];
    print('Giá trị chọn là $selectedIndex');
    final url = Uri.parse(
        'http://10.0.2.2:8000/api/auth/HinhThuc/${selectedDataItem.id}?token=$access_token');
    final response = await http.delete(url);

    print("Giá trị 2 là:${selectedDataItem.id}");
    if (response.statusCode == 200) {
      print('Xóa hình thức thành công!');
    } else {
      // Xử lý lỗi
      print('Lỗi: ${response.statusCode}');
    }
  }
  void handleRowTap1(int index) async {
  final selectedData = (isSearching ? searchResults : dataList)[index];
SharedPreferences prefs = await SharedPreferences.getInstance();
  // Lưu giá trị vào SharedPreferences
   prefs.setString('selectedDataId', selectedData.id.toString());
   prefs.setString('selectedDataTenHinhThuc', selectedData.ten_hinh_thuc ?? '');
   prefs.setString('selectedDataNoiDung', selectedData.noi_dung ?? '');
   prefs.setString('selectedDataSoTranToiThieu', selectedData.so_tran_toi_thieu.toString());
   prefs.setString('selectedDataSoDoiToiThieu', selectedData.so_doi_toi_thieu.toString());

  // Chuyển sang trang khác
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Detail_Form(),
    ),
  );
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
                'Xoá hình thức',
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
                'Bạn muốn xoá hình thức này?',
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
                      fetchData();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Đã xoá hình thức'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); 
                                      // Đóng hộp thoại thông báo
                                      setState(() {
                                        
                                      },);
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

  void initState() {
    super.initState();
    fetchData();
  }

  void searchInDataList(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        isSearching = true;
        searchResults = dataList.where((dataItem) {
          return dataItem.id.toString().toLowerCase().contains(query) ||
              dataItem.ten_hinh_thuc!.toLowerCase().contains(query) ||
              dataItem.noi_dung!.toLowerCase().contains(query) ||
              dataItem.so_tran_toi_thieu
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              dataItem.so_doi_toi_thieu
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList();
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFA011129),
            leading: IconButton(
              icon: const Icon(Icons.navigate_before_outlined),
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen_Admin()),
                );
              },
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Thêm',
                    child: ListTile(
                      leading: Icon(Icons.add, color: Colors.black),
                      title:
                          Text('Thêm', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Xoá',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.black),
                      title: Text('Xoá', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Sửa',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.black),
                      title: Text('Sửa', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
                onSelected: (String value) {
                  if (value == 'Xoá') {
                    print(selectedIndex);
                    if (selectedIndex != -1) {
                      showDeleteConfirmationDialog(context, selectedIndex);
                    } else {
                      showAlertNotification(context, selectedIndex);
                    }
                  } else {
                    if (value == "Thêm") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Add_Form()),
                      );
                    } else {
                      if (selectedIndex == -1) {
                        showAlertNotification(context, selectedIndex);
                      }
                      handleRowTap1(selectedIndex);
                      
                    }
                  }
                },
              )
            ],
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
            centerTitle: true,
            title: Text('DS hình thức thi đấu',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'BodoniModa',
                ))),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                      label: Text('Tên hình thức ',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: SizedBox(
                          width: 100,
                          child: Text('Nội dung',
                              style: TextStyle(color: Colors.white)))),
                  DataColumn(
                      label: Text('Số trận tối thiểu',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Số đội tối thiểu',
                          style: TextStyle(color: Colors.white))),
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
                          Text(
                            dataItem.ten_hinh_thuc ?? '',
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
                            dataItem.noi_dung ?? '',
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
                            dataItem.so_tran_toi_thieu.toString(),
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
                            dataItem.so_doi_toi_thieu.toString(),
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
          ),
        ));
  }
}
