// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/admin/list_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
class Detail_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Detail_Form_State();
}

class Detail_Form_State extends State<Detail_Form> {
  String? ten_hinh_thuc = '';
  String? noi_dung = '';
  int? so_doi_toi_thieu = 0;
  int? so_tran_toi_thieu = 0;
  int selectedId  = 0;
  int? id = 0;
  String access_token='';
    late List<Data> dataList = [];
  TextEditingController noidung = TextEditingController();
  TextEditingController tenhinhthuc = TextEditingController();
  TextEditingController sotran = TextEditingController();
  TextEditingController sodoi = TextEditingController();
final numberFormatter = FilteringTextInputFormatter.digitsOnly;


void fetchData() async {
  try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
        access_token = prefs.getString('accessToken') ?? '';
  id = prefs.getString('selectedDataId') != '' ? int.tryParse(prefs.getString('selectedDataId')!) : null;
  final String url = 'http://10.0.2.2:8000/api/auth/HinhThuc?token=$access_token';
    final Data selectedData = await fetchDataById(id);
      setState(() {
      tenhinhthuc.text = selectedData.ten_hinh_thuc!;
      noidung.text = selectedData.noi_dung!;
      sotran.text = selectedData.so_tran_toi_thieu.toString();
      sodoi.text = selectedData.so_doi_toi_thieu.toString();
    });
    // In ra các giá trị trả về
    print('ten_hinh_thuc: ${selectedData.ten_hinh_thuc}');
    print('noi_dung: ${selectedData.noi_dung}');
    print('so_tran_toi_thieu: ${selectedData.so_tran_toi_thieu}');
    print('so_doi_toi_thieu: ${selectedData.so_doi_toi_thieu}');
  } catch (e) {
    print('Error fetching data: $e');
  }
}

void saveData() {
  // Lấy giá trị từ các trường nhập liệu
  final newData = Data(
    id: id,
    ten_hinh_thuc: tenhinhthuc.text,
    noi_dung: noidung.text,
    so_tran_toi_thieu: int.tryParse(sotran.text),
    so_doi_toi_thieu: int.tryParse(sodoi.text),
  );

  updateData(newData); // Gọi hàm updateData để cập nhật dữ liệu
}
// Future<http.Response> deleteData(int id) async {
//   final String deleteUrl = 'http://192.168.70.91:8000/api/auth/HinhThuc/$id?token=$access_token';

//   final http.Response response = await http.delete(Uri.parse(deleteUrl));
  
//   return response;
// }

Future<void> updateData(Data newData) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
 
        access_token = prefs.getString('accessToken') ?? '';
        print('Token trong hàm update: $access_token');
  final url = 'http://10.0.2.2:8000/api/auth/HinhThuc/${newData.id}?token=$access_token'; // Thay đổi URL của API tương ứng
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
final requestData = {
    'id':newData.id,
    'ten_hinh_thuc': newData.ten_hinh_thuc,
    'noi_dung': newData.noi_dung,
    'so_tran_toi_thieu': newData.so_tran_toi_thieu,
    'so_doi_toi_thieu': newData.so_doi_toi_thieu,
  };
    final String requestBody = json.encode(requestData);
    
    final client = HttpClient()
  ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
        content: Text('Cập nhật thành công'),
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
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => List_Form()),
                );
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
  } else {
    // Xử lý lỗi khi cập nhật không thành công
    throw Exception('Failed to update data');
  }
}


// Future<http.Response> createData(Data newData) async {
//   final String createUrl = 'http://192.168.70.91:8000/api/auth/HinhThuc?token=$access_token';
//   print('id là: ${newData.id}');
//   final requestData = {
//     'id': newData.id,
//     'ten_hinh_thuc': newData.ten_hinh_thuc,
//     'noi_dung': newData.noi_dung,
//     'so_tran_toi_thieu': newData.so_tran_toi_thieu,
//     'so_doi_toi_thieu': newData.so_doi_toi_thieu,
//   };
// print('id là: $id');
//   final String requestBody = json.encode(requestData);
//   final Map<String, String> headers = {'Content-Type': 'application/json'};

//   final http.Response response = await http.post(Uri.parse(createUrl), headers: headers, body: requestBody);
  
//   return response;
// }


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
//                 setState(() {
                  
//                 });
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




Future<Data> fetchDataById(int? id) async {
  final String apiUrl = 'http://10.0.2.2:8000/api/auth/HinhThuc/$id?token=$access_token';
  print(id);
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(apiUrl), headers: headers);
  
  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    final dynamic data = responseData['data'];
    return Data.fromJson(data);
  } else {
    throw Exception('Failed to load data');
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
          backgroundColor: Color(0xFA011129),
          title: Text('Chi tiết hình thức'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Điều hướng trở lại trang trước
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'Cập nhật hình thức',
                  style: TextStyle(fontFamily: 'BodoniModa', fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên hình thức: ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          child: TextFormField(
                            controller: tenhinhthuc,
                            decoration: const InputDecoration(
                             
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nội dung: ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: noidung,
                              
                                  maxLines: 2,
                                  decoration: const InputDecoration(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số trận tối thiểu: ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Container(
                                      child: TextFormField(
                                    inputFormatters: [numberFormatter],
                                    keyboardType: TextInputType.number,
                                       controller:
                                            sotran,
                                        decoration: const InputDecoration(
                                         
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Số đội tối thiểu: ',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Container(
                                            child: TextFormField(
                                              inputFormatters: [numberFormatter],
                                              keyboardType: TextInputType.number,
                                              controller:
                                                  sodoi,
                                              decoration: const InputDecoration(
                                               
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.99,
                                child: SizedBox(
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // saveData();
                                      saveData();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFA011129)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'CẬP NHẬT',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]))
            ]))));
  }
}
