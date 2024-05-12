// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/add_user.dart';
import 'package:ckc_league/admin/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class List_User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => List_User_State();
}

class List_User_State extends State<List_User> {
  late List data;
  int selectedIndex = -1;
  int? id = 0;
  late List<Data> dataList = [];
  String searchValue = '';
  TextEditingController loaitaikhoan  = TextEditingController();
  List<Data> searchResults = [];
  List<Data> displayedList = [];
  bool isSearching = false;
  String searchQuery = '';
  String access_token ='';
  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      access_token = prefs.getString('accessToken') ?? '';
       String url = 'http://10.0.2.2:8000/api/auth/Login?token=$access_token';
       final headers = {'User-Agent': 'MyApp/1.0',};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        dataList = data.map((x) => Data.fromJson(x)).toList();
      });
      print(response.body);
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  void handleRowTap(int index) {
    setState(() {
      selectedIndex = index; // Cập nhật chỉ số của dòng được chọn
      final selectedDataItem =
          dataList[index]; // Lấy dữ liệu của dòng được chọn
      // print(
      //     'Selected ID: ${selectedDataItem.id}'); // In ra ID của dòng được chọn
    });
  }
 void addLoaiTK() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/LoaiTaiKhoan?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
  
    // final maxId = await getMaxId();
    // print(maxId.toString());
    final response = await http.post(Uri.parse(url),
        body: {
          // 'id': maxId.toString(),
         'loai_tai_khoan': loaitaikhoan.text.toString()
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm loại tài khoản thành công ');
        showSuccessDialog(context);
      

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle, // Icon logout
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Text('Thêm thành công'),
          actions: [
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteProduct(int index) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
      access_token = prefs.getString('accessToken') ?? '';
    selectedIndex = index;
    final selectedDataItem = dataList[index];
    print('Selected ID là: ${selectedDataItem.id}');
  final url = Uri.parse(
        'http://10.0.2.2:8000/api/auth/Login/${selectedDataItem.id}?token=$access_token');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Xóa tài khoản thành công!');
    } else {
      // Xử lý lỗi
      print('Lỗi: ${response.statusCode}');
    }
  }
//  Future<void> deleteProduct(int index) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     access_token = prefs.getString('accessToken') ?? '';
//     selectedIndex = index;
//     final selectedDataItem = dataList[index];
//     print('Giá trị chọn là $selectedIndex');
//     final url = Uri.parse(
//         'http://10.0.2.2:8000/api/auth/referee/${selectedDataItem.id}?token=$access_token');
//     final response = await http.delete(url);

//     print("Giá trị 2 là:${selectedDataItem.id}");
//     if (response.statusCode == 200) {
//       print('Xóa hình thức thành công!');
//     } else {
//       // Xử lý lỗi
//       print('Lỗi: ${response.statusCode}');
//     }
//   }
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
                'Xoá tài khoản',
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
                'Bạn muốn xoá tài khoản này?',
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
                            content: Text('Đã xoá tài khoản'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Đóng hộp thoại thông báo
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
  void showAddLoaiTaiKhoan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thêm loại tài khoản',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5),
              TextField(
                controller: loaitaikhoan,
                // onChanged: (value) {
                //   fullName = value;
                // },
                decoration: InputDecoration(
                  labelText: 'Loại tài khoản',
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Thêm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Đóng hộp thoại
                    
                      
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Đã xoá tài khoản'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Đóng hộp thoại thông báo
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.green,
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

//   void filterDataList() {  
//   filteredList = dataList.where((dataItem) {
//     // Kiểm tra nếu giá trị tìm kiếm tồn tại trong bất kỳ trường nào của dữ liệu
//     return dataItem.id.toString().contains(searchValue) ||
//         dataItem.hoten!.contains(searchValue) ||
//         dataItem.email!.contains(searchValue) ||
//         dataItem.loaiTaiKhoan!.contains(searchValue) ||
//         dataItem.trang_thai!.contains(searchValue);
//   }).toList();
// }

// void searchInDataList(String query) {
//   setState(() {
//     searchQuery = query;
//     searchResults = dataList.where((dataItem) {
//       // Kiểm tra nếu giá trị tìm kiếm tồn tại trong bất kỳ trường nào của dữ liệu
//       return dataItem.id.toString().contains(query) ||
//           dataItem.hoten!.contains(query) ||
//           dataItem.email!.contains(query) ||
//           dataItem.loaiTaiKhoan!.contains(query) ||
//           dataItem.trang_thai!.contains(query);
//     }).toList();
//   });
// }


void searchInDataList(String query) {
  setState(() {
    searchQuery = query;
    if (query.isNotEmpty) {
      isSearching = true;
      searchResults = dataList.where((dataItem) {
         return dataItem.id.toString().toLowerCase().contains(query) ||
          dataItem.hoten!.toLowerCase().contains(query) ||
          dataItem.email!.toLowerCase().contains(query) ||
          dataItem.loaiTaiKhoan!.toLowerCase().contains(query) ||
          dataItem.trang_thai!.toLowerCase().contains(query);
      }).toList();
    } else {
setState(() {
      isSearching = false;
    });
    }
  });
}

void updateDisplayedList() {
  setState(() {
    if (searchResults.isNotEmpty) {
      displayedList = searchResults; // Sử dụng searchResults nếu có tìm kiếm
    } else {
      displayedList = dataList; // Sử dụng dataList nếu không có tìm kiếm
    }
  });
}



 @override
  void initState() {
  super.initState();
  fetchData();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFA011129),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen_Admin()));
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
                  title: Text('Thêm', style: TextStyle(color: Colors.black)),
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
                value: 'Thêm loại tài khoản',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.black),
                  title: Text('Thêm loại tài khoản', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
            onSelected: (String value) {
              if (value == 'Xoá') {
                print('Lựa chọn: $value');
                print(selectedIndex);
                if (selectedIndex != -1) {
                  showDeleteConfirmationDialog(context, selectedIndex);
                }
              } else {
                if (value == "Thêm") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add_User()),
                );
                } else {
                 showAddLoaiTaiKhoan(context);
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
        title: Text('Danh sách tài khoản'),
      ),
      body: Container(
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
              label: Text('Họ tên', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Email', style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text('Loại tài khoản', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Trạng thái', style: TextStyle(color: Colors.white))),
        ],
        rows: (isSearching ? searchResults : dataList).asMap().entries.map(
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
                    dataItem.hoten ?? '',
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
                    dataItem.email ?? '',
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
                    dataItem.loaiTaiKhoan ?? '',
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
                    dataItem.trang_thai ?? '',
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
                    handleRowTap(index); // Lưu chỉ số của dòng được chọn
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
),
),
    );
  }
}
