// ignore_for_file: unused_local_variable

import 'package:ckc_league/Object_API/create.dart';
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Demo_State();
}

class Demo_State extends State<Demo> {
  bool isScreenLoading = false;
  final String url = 'http://10.0.2.2:8000/api/products';
  int selectedProductId = -1; // Mặc định không có sản phẩm nào được chọn
  int selectedValueIndex = -1; // Mặc định không có giá trị nào được chọn
  int productId = 0;
  List<Data> data = [];
  List<Data> filteredData = [];
  List<Data> newFilteredData = [];
  List<Data> initialData = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  void resetState() {
    setState(() {
      filteredData.clear(); // Xóa dữ liệu hiện có trong filteredData
      filteredData.addAll(newFilteredData); // Thêm dữ liệu mới vào filteredData
      newFilteredData.clear(); // Xóa dữ liệu tạm thời
      // Gán các giá trị khởi tạo ban đầu tại đây
    });
    fetchData(); // Tải lại dữ liệu mới từ API
  }
  void saveEditedValue(String newName, String newPrice) {
  // Lấy sản phẩm được chọn từ danh sách sản phẩm
  Data selectedProduct = filteredData[selectedValueIndex];

  // Cập nhật giá trị mới cho sản phẩm
  selectedProduct.tensp = newName;
  selectedProduct.gia = int.parse(newPrice);
  print('name $newName');
    print('price $newPrice');

  // Thực hiện gọi API để cập nhật giá trị
 updateProduct(selectedProduct, newName, newPrice);
}
  void showEditDialog(BuildContext context, String name, String price) {
  nameController.text = name; // Gán giá trị hiện tại của tên vào controller
  priceController.text = price; // Gán giá trị hiện tại của giá vào controller

  showDialog(
  context: context,
  builder: (BuildContext context) {
    String tempName = nameController.text; // Biến tạm lưu giá trị mới của tên
    String tempPrice = priceController.text; // Biến tạm lưu giá trị mới của giá

    return AlertDialog(
      title: Text('Sửa thông tin'),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Tên',
            ),
            onChanged: (value) {
              tempName = value; // Cập nhật giá trị mới vào biến tạm
            },
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Giá',
            ),
            onChanged: (value) {
              tempPrice = value; // Cập nhật giá trị mới vào biến tạm
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng hộp thoại
          },
          child: Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            // Thực hiện lưu giá trị mới vào API
            saveEditedValue(tempName, tempPrice);

            Navigator.of(context).pop(); // Đóng hộp thoại
          },
          child: Text('Lưu'),
        ),
      ],
    );
  },
);

}

  void updateProduct(Data product, String newName, String newPrice) async {
  final String apiUrl = 'http://10.0.2.2:8000/api/products/${product.id}';

  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final Map<String, dynamic> requestData = {
    'name': newName,
    'price': int.parse(newPrice),
  };

  final String requestBody = json.encode(requestData);

  final http.Response response =
      await http.put(Uri.parse(apiUrl), headers: headers, body: requestBody);
  print(response.statusCode);
  if (response.statusCode == 200) {
    // Cập nhật thành công
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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Cập nhật lại danh sách sản phẩm sau khi cập nhật thành công
    fetchData();
  } else {
    // Cập nhật không thành công
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Cập nhật không thành công!'),
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
  }
}
  void showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xoá sản phẩm'),
          content: Text('Bạn có chắc chắn muốn xoá sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                deleteProduct(productId); // Xoá sản phẩm
                fetchData();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Thông báo'),
                      content: Text('Đã xoá sản phẩm'),
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
              child: Text('Xoá'),
            ),
          ],
        );
      },
    );
  }

  void fetchData() async {
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      List<dynamic> results = decodedJson['data'];
      List<Data> newData = [];

      for (int i = 0; i < results.length; i++) {
        var customerJson = results[i];
        newData.add(Data.fromJson(customerJson));
      }

      setState(() {
        filteredData.clear(); // Xóa dữ liệu hiện tại trong filteredData
        filteredData
            .addAll(newData); // Thêm dữ liệu mới từ newData vào filteredData
        initialData =
            List.from(filteredData); // Cập nhật initialData với dữ liệu mới

        // Đặt lại selectedValueIndex nếu cần thiết
        if (selectedValueIndex >= filteredData.length) {
          selectedValueIndex = -1;
        }

        newFilteredData =
            List.from(initialData); // Cập nhật newFilteredData với dữ liệu mới
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/products/$productId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Thành công, xử lý dữ liệu hoặc cập nhật danh sách sản phẩm
      print('Xóa sản phẩm thành công!');
    } else {
      // Xử lý lỗi
      print('Lỗi: ${response.statusCode}');
    }
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
        title: Text('Demo API'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchData();
                isScreenLoading = true; // Hiển thị biểu tượng loading
              });

              // Thực hiện các hoạt động reload dữ liệu ở đây

              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  isScreenLoading = false; // Tắt biểu tượng loading
                });
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedValueIndex == index;

                      return ListTile(
                        onTap: () {
                          setState(() {
                            final ma = filteredData[index].id.toString();
                            ma == productId;
                            selectedValueIndex = index;
                            selectedProductId = int.parse(ma);
                            print('Mã sp: $selectedProductId');
                          });
                        },
                        title: Text(
                          filteredData[index].tensp.toString() ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.blue
                                : null, // Thay đổi màu sắc nếu được chọn
                          ),
                        ),
                        subtitle:
                            Text(filteredData[index].gia.toString() ?? ""),
                      );
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Create()));
                          },
                          child: Text(
                            'Thêm',
                            style: TextStyle(color: Colors.black),
                          )),
                      OutlinedButton(
                        onPressed: () {
                          if (selectedProductId != -1) {
                            showDeleteConfirmationDialog(
                                context, selectedProductId);
                          }
                        },
                        child: Text(
                          'Xoá',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    OutlinedButton(
  onPressed: () {
    if (selectedProductId != -1) {
      int id = int.parse(filteredData[selectedValueIndex].id.toString());
      String name = filteredData[selectedValueIndex].tensp.toString();
      String price = filteredData[selectedValueIndex].gia.toString();
      // updateProduct(id,name,price);
      showEditDialog(context, name, price);
    }
  },
  child: Text(
    'Sửa',
    style: TextStyle(color: Colors.black),
  ),
),

                    ],
                  ),
                )
              ],
            ),
          ),
          if (isScreenLoading)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
