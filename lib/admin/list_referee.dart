// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/detail_referee.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class List_Referee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => List_Referee_State();
}

class List_Referee_State extends State<List_Referee> {
  String selectedHoten = '';
  String selectedVitri = '';
  int seletedThephat = 0;
  int seletedTongsotran = 0;
  int seletedPhatden = 0;
  int selectedIndex = -1;
  late List<Data> dataList = [];
  late List data;
  List<Data> searchResults = [];
  List<Data> displayedList = [];
  bool isSearching = false;
  String searchQuery = '';
  String? selectedValue = '';
  String access_token = '';
  TextEditingController hoten = TextEditingController();
  TextEditingController vitri = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    String url = 'http://10.0.2.2:8000/api/auth/referee';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
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
        'http://10.0.2.2:8000/api/auth/referee/${selectedDataItem.id}?token=$access_token');
    final response = await http.delete(url);

    print("Giá trị 2 là:${selectedDataItem.id}");
    if (response.statusCode == 200) {
      print('Xóa hình thức thành công!');
    } else {
      // Xử lý lỗi
      print('Lỗi: ${response.statusCode}');
    }
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
                'Xoá trong tài',
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
                'Bạn muốn xoá trọng tài này?',
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
                            content: Text('Đã xoá trọng tài'),
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

  void handleRowTap(int index) {
    setState(() {
      selectedIndex = index; // Cập nhật chỉ số của dòng được chọn
      final selectedDataItem =
          dataList[index]; // Lấy dữ liệu của dòng được chọn
      print(
          'Selected ID: ${selectedDataItem.id}'); // In ra ID của dòng được chọn
    });
  }

  void searchInDataList(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        isSearching = true;
        searchResults = dataList.where((dataItem) {
          return dataItem.id.toString().toLowerCase().contains(query) ||
              dataItem.ho_ten!.toLowerCase().contains(query) ||
              dataItem.vi_tri!.toLowerCase().contains(query) ||
              dataItem.the_phat.toString().toLowerCase().contains(query) ||
              dataItem.tong_so_tran.toString().toLowerCase().contains(query) ||
              dataItem.phat_den.toString().toLowerCase().contains(query);
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

  void _showAddRefereeDialog(BuildContext context) {
    String fullName = '';
    String position = '';
    final screenWidth_1 = MediaQuery.of(context).size.width;
    final buttonWidth_1 = screenWidth_1 * 0.4;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm trọng tài'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hoten,
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
                    setState(() {});
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
                        selectedValue!,
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
                  _addReferee(hoten.text, position);
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

  void saveData(int index) {
    // Lấy giá trị từ các trường nhập liệu
    selectedIndex = index;
    final selectedDataItem = dataList[index]; // Lấy dữ liệu của dòng được chọn
    final newData = Data(
        id: selectedDataItem.id,
        ho_ten: fullNameController.text,
        vi_tri: selectedVitri,
        the_phat: seletedThephat,
        phat_den: seletedPhatden,
        tong_so_tran: seletedTongsotran);
    print(newData.id);
    print(newData.ho_ten);
    print(newData.vi_tri);
    print(newData.the_phat);
    print(newData.phat_den);
    print(newData.tong_so_tran);
    updateData(newData); // Gọi hàm updateData để cập nhật dữ liệu
  }

  Future<void> updateData(Data newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(selectedIndex);
    access_token = prefs.getString('accessToken') ?? '';
    print('Token trong hàm update: $access_token');
    final url =
        'http://10.0.2.2:8000/api/auth/referee/${newData.id}?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON

    final requestData = {
      'id': newData.id,
      'ho_ten': newData.ho_ten,
      'vi_tri': newData.vi_tri,
      'the_phat': newData.the_phat,
      'phat_den': newData.phat_den,
      'tong_so_tran': newData.tong_so_tran
    };
    final String requestBody = json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.putUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Cập nhật thành công!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  fetchData();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      throw Exception('Failed to update data');
    }
  }

  Future<http.Response> createData(Data newData) async {
    final String createUrl =
        'http://10.0.2.2:8000/api/auth/HinhThuc?token=$access_token';

    final requestData = {
      'id': newData.id,
      'ho_ten': fullNameController.text,
      'vi_tri': newData.vi_tri,
    };

    final String requestBody = json.encode(requestData);
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final http.Response response = await http.post(Uri.parse(createUrl),
        headers: headers, body: requestBody);

    return response;
  }

  Future<http.Response> deleteData(int id) async {
    final String deleteUrl =
        'http://10.0.2.2:8000/api/auth/referee/$id?token=$access_token';

    final http.Response response = await http.delete(Uri.parse(deleteUrl));

    return response;
  }

  // void updateData(Data newData) async {
  //   final createResponse = await createData(newData);

  //   final deleteResponse = await deleteData(newData.id!);

  //   print(createResponse.statusCode);
  //   print(deleteResponse.statusCode);

  //   if (createResponse.statusCode == 201 && deleteResponse.statusCode == 200) {
  //     // Cập nhật thành công
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Thông báo'),
  //           content: Text('Cập nhật thành công!'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Đóng hộp thoại
  //                 Navigator.of(context).pop();
  //                 setState(() {});
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // Cập nhật không thành công
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Thông báo'),
  //           content: Text('Cập nhật không thành công!'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Đóng hộp thoại
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void _showUpdateRefereeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cập nhật trọng tài'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Họ tên',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedHoten = value;
                  });
                },
              ),
              Container(
                child: Row(
                  children: [
                    Text('Vị trí: '),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _showMenuUpdate(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedVitri.isNotEmpty
                                ? selectedVitri
                                : 'Chọn giá trị',
                            style: TextStyle(fontSize: 15),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String fullName = fullNameController.text;
                String position = positionController.text;

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
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Thực hiện cập nhật trọng tài với họ tên và vị trí đã nhập
                  // _updateReferee(fullName, position);
                  saveData(selectedIndex);
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
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
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
                        fontWeight: FontWeight.bold,
                      ),
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
                    selectedValue = 'Trọng tài chính';
                    print('Giá trị chọn là $selectedValue');
                    setState(() {});
                  });
                  selectedValue = 'Trọng tài chính';
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text(
                  'Trọng tài chính',
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
                    selectedValue = 'Trọng tài biên';
                    setState(() {});
                    print('Giá trị chọn là $selectedValue');
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  'Trọng tài biên',
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
                    selectedValue = 'Trọng tài bàn';

                    print('Giá trị chọn là $selectedValue');
                  });

                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text(
                  'Trọng tài bàn',
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
          setState(() {});
        });
      }
    });
  }

 void _showMenuUpdate(BuildContext context) {
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
                      fontWeight: FontWeight.bold,
                    ),
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
                selectedVitri = 'Trọng tài chính';
                Navigator.pop(context, selectedVitri);
              },
              child: const Text(
                'Trọng tài chính',
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
                selectedVitri = 'Trọng tài biên';
                Navigator.pop(context, selectedVitri);
              },
              child: const Text(
                'Trọng tài biên',
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
                selectedVitri = 'Trọng tài bàn';
                Navigator.pop(context, selectedVitri);
              },
              child: const Text(
                'Trọng tài bàn',
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
        selectedVitri = value;
      });
    }
  });
}


  Future<int> getMaxId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url =
        'http://10.0.2.2:8000/api/auth/referee?token=$access_token';
    final response =
        await http.get(Uri.parse(url), headers: {'User-Agent': 'MyApp/1.0'});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      int maxId =
          data.fold(0, (prev, item) => item['id'] > prev ? item['id'] : prev);
      return maxId + 1;
    } else {
      throw Exception('Failed to load data');
    }
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
          content: Text('Thêm trọng tài thành công'),
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
                setState(() {
                  fetchData();
                });
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

  void _addReferee(String fullName, String position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final String url = 'http://10.0.2.2:8000/api/auth/referee';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    print(selectedValue);
    final maxId = await getMaxId();
    print(maxId.toString());
    final response = await http.post(Uri.parse(url),
        body: {
          'id': maxId.toString(),
          'ho_ten': hoten.text,
          'the_phat': '0',
          'phat_den': '0',
          'tong_so_tran': '0',
          'vi_tri': selectedValue,
        },
        headers: headers);
    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm trọng tài thành công ');
        showSuccessDialog(context);

        hoten.clear();
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFA011129),
        title: Text(
          'Danh sách trọng tài',
          style: TextStyle(
            fontFamily: 'BodoniModa',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.pop(context);
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
                value: 'Sửa',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.black),
                  title: Text('Sửa', style: TextStyle(color: Colors.black)),
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
              } else {
                if (value == "Thêm") {
                  _showAddRefereeDialog(context);
                } else {
                  //sửa
                  if (selectedIndex != -1) {
                    _showUpdateRefereeDialog(context);
                  } else {
                    showAlertNotification(context, selectedIndex);
                  }
                }
              }
            },
          )
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: MaterialStateColor.resolveWith((states) =>
                        Colors
                            .black), // Đổi màu của dòng tiêu đề thành màu xanh
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text('ID',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Họ tên',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Vị trí',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Tổng số thẻ phạt',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Tổng số phạt đền',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Số trận đã bắt',
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
                                dataItem.ho_ten ?? '',
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
                                dataItem.vi_tri ?? '',
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
                                dataItem.the_phat.toString(),
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
                                dataItem.phat_den.toString(),
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
                                dataItem.tong_so_tran.toString(),
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
                                selectedHoten = dataItem.ho_ten ?? '';
                                selectedVitri = dataItem.vi_tri ?? '';
                                seletedThephat = dataItem.the_phat ?? 0;
                                seletedPhatden = dataItem.phat_den ?? 0;
                                seletedTongsotran = dataItem.tong_so_tran ?? 0;
                                setState(() {
                                  fullNameController.text = selectedHoten;
                                });

                                print('selectedHoten là: $selectedHoten');
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
              ))),
    );
  }
}
