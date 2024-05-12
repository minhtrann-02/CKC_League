// ignore_for_file: await_only_futures, unnecessary_string_interpolations, file_names, depend_on_referenced_packages

import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/menu_bottom/leagues/pick_player.dart';
import 'package:ckc_league/menu_bottom/my_team/DoiBong/image_user.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Add_Players_GD extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Add_Players_GD_State();
}

class Add_Players_GD_State extends State<Add_Players_GD> {
  bool showBottomSheet = false;
  bool _showErrorSoAo = false;
  bool _showErrorTenTD = false;
  bool _showErrorEmail = false;
  bool playerExists = false;
  String selectedValue = 'Vị trí thi đấu(Tùy chọn)';
  String seletedVaiTro = 'Vị trí thi đấu(Tùy chọn)';
  String soAoValue = '';
  String access_token = '';
  String selectedImageUser = 'images/user1.png';
  int nguoiquanlyid = 0;
  int? idDoiBong = 0;
  List<Data> dataList = [];
  int idTaiKhoanEmail =0;
  late SharedPreferences prefs;
  bool exists = false;
  TextEditingController soao = TextEditingController();
  TextEditingController tenthidau = TextEditingController();
  TextEditingController emailTaiKhoan = TextEditingController();
  TextEditingController hoten = TextEditingController();
  TextEditingController sdt = TextEditingController();

  Future<bool> getIDExist(int idTaiKhoanEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  idDoiBong = prefs.getInt('idDoiBong') ?? 0;
  final String url = 'http://10.0.2.2:8000/api/auth/players?token=$access_token';
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<dynamic> data = responseData['data'];

    // Lọc danh sách dữ liệu dựa trên giá trị của 'doi_bong_id'
    final filteredData = data.where((x) => x['doi_bong_id'] == idDoiBong).toList();

    // Kiểm tra tồn tại của 'idTaiKhoanEmail' trong danh sách
    bool exists = false;
    for (var item in filteredData) {
      if (item['id_tai_khoan'] == idTaiKhoanEmail) {
        exists = true;
        break;
      }
    }

    return exists;
  } else {
    throw Exception('Failed to load data');
  }
}




void addform() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  nguoiquanlyid = prefs.getInt('nguoiquanlyid') ?? 0;
  idDoiBong = prefs.getInt('idDoiBong1') ?? 0;
  access_token = prefs.getString('accessToken') ?? '';
  idTaiKhoanEmail = prefs.getInt('idTaiKhoanEmail') ?? 0;
  print('idDoiBong trong màn hình thêm cầu thủ: $idDoiBong');
  selectedImageUser = prefs.getString('selectedImageUser') ?? '';
  print(selectedImageUser);
  final String url = 'http://10.0.2.2:8000/api/auth/players?token=$access_token';
  final headers = {'User-Agent': 'MyApp/1.0'};
  print(nguoiquanlyid);
  print(idDoiBong);
  print(tenthidau.text.toString());
  print(soao.text.toString());
  print(selectedValue);
  print(seletedVaiTro);
  print('idTaiKhoanEmail là: $idTaiKhoanEmail');

  // Kiểm tra sự tồn tại của cầu thủ trước khi thêm
bool playerExists = await getIDExist(idTaiKhoanEmail);

  if (playerExists) {
    // Hiển thị thông báo "Cầu thủ đã tồn tại"
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: const Text('Cầu thủ đã tồn tại'),
          actions: [
            ElevatedButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  
                });
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.red,
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
    // Thực hiện thêm cầu thủ
    final response = await http.post(
      Uri.parse(url),
      body: {
        'doi_bong_id': idDoiBong.toString(),
        'ten_cau_thu': tenthidau.text.toString(),
        'id_tai_khoan': idTaiKhoanEmail.toString(),
        'so_ao': soao.text.toString(),
        'vi_tri': selectedValue.toString(),
        'vai_tro': seletedVaiTro.toString(),
        'avatar': selectedImageUser.toString(),
        'so_tran_tham_gia': '0',
        'so_ban_thang': '0',
        'so_kien_tao': '0',
        'so_the_vang': '0',
        'so_the_do': '0',
      },
      headers: headers,
    );

    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm cầu thủ thành công');
        showSuccessDialog(context);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
}




void getIDLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  String url = 'http://10.0.2.2:8000/api/auth/Login';
  final headers = {
    'User-Agent': 'MyApp/1.0',
    'Authorization': 'Bearer $access_token'
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final List<dynamic> data = responseData['data'];
    print('Email tài khoản từ controller là: ${emailTaiKhoan.text}');
    
    // Lọc danh sách theo cột 'nguoi_quan_ly_id'
    final filteredDataList = data
        .where((item) => item['email'] == emailTaiKhoan.text)
        .toList();

    if (filteredDataList.isNotEmpty) {
      final id = filteredDataList[0]['id'];
      prefs.setInt('idTaiKhoanEmail', id);
      print('ID từ hàm getIDLogin: $id');
      await getIDExist(id); // Truyền giá trị email mới vào hàm getIDExist()
      addform();
    } else {
      // Xử lý trường hợp không tìm thấy email trong danh sách
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined, // Icon logout
                  color: Colors.red,
                  size: 24,
                ),
                SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                Text(
                  'Thông báo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: const Text('Email không tồn tại'),
            actions: [
              ElevatedButton(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.red,
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
  } else {
    throw Exception('Failed to load data');
  }
}


  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
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
          content: const Text('Thêm cầu thủ thành công'),
          actions: [
            ElevatedButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pick_Players()),
                );
                tenthidau.clear();
                soao.clear();
                seletedVaiTro = 'Chọn vai trò';
                selectedValue = 'Vị trí thi đấu(Tùy chọn)';
                tenthidau.clear();

                setState(() {});
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

void showSuccessDialogTT(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
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
          content: const Text('Thêm cầu thủ thành công'),
          actions: [
            ElevatedButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                  Navigator.pop(context);
              
               
                tenthidau.clear();
                soao.clear();
                seletedVaiTro = 'Chọn vai trò';
                selectedValue = 'Vị trí thi đấu(Tùy chọn)';
              

                setState(() {});
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
  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    selectedImageUser = prefs.getString('selectedImageUser') ?? '';
    setState(() {}); // Gọi setState để cập nhật giao diện
  }

//   Future<bool> checkPlayerExistence(List<dynamic> players) async {
//   for (var player in players) {
//     if (player['doi_bong_id'] == idDoiBong && player['so_ao'] == soao.text.toString()) {
//       return true; // Cầu thủ đã tồn tại
//     }
//   }
//   return false; // Cầu thủ không tồn tại
// }
  void getPlayers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    final String url =
        'http://10.0.2.2:8000/api/auth/players?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách dữ liệu dựa trên giá trị của "doi_bong_id"
      final filteredData =
          data.where((x) => x['doi_bong_id'] == idDoiBong).toList();

      setState(() {
        dataList = filteredData.map((x) => Data.fromJson(x)).toList();
      });
      print('respons:${response.body}');
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();

    // getSelectedImageName();
    getPlayers();
        initializeSharedPreferences();
  }

  Future<void> getSelectedImageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // selectedImageUser =
      //     prefs.getString('selectedImageUser') ?? 'images/logo1.png';
      prefs.setString('selectedImageUser1', selectedImageUser);
      print('image là: $selectedImageUser');
    });
  }

 


  void addformTT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nguoiquanlyid = prefs.getInt('nguoiquanlyid') ?? 0;
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    selectedImageUser = prefs.getString('selectedImageUser') ?? '';
    idTaiKhoanEmail = prefs.getInt('idTaiKhoanEmail')??0;
    print(selectedImageUser);
    final String url =
        'http://10.0.2.2:8000/api/auth/players?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};
    print(nguoiquanlyid);
    print(idDoiBong);
    print(tenthidau.text.toString());
    print(soao.text.toString());
    print('Giá trị chọn là:$selectedValue');
    print(seletedVaiTro);

    final response = await http.post(
      Uri.parse(url),
      body: {
        'doi_bong_id': idDoiBong.toString(),
        'ten_cau_thu': tenthidau.text.toString(),
        'so_ao': soao.text.toString(),
        'id_tai_khoan': idTaiKhoanEmail.toString(), 
        'vi_tri': selectedValue.toString(),
        // 'vai_tro': seletedVaiTro.toString(),
         'vai_tro': seletedVaiTro.toString(),
        'avatar': selectedImageUser.toString(),
        'so_tran_tham_gia': '0',
        'so_ban_thang': '0',
        'so_kien_tao': '0',
        'so_the_vang': '0',
        'so_the_do': '0',
      },
      headers: headers,
    );

    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm cầu thủ thành công ');
        showSuccessDialogTT(context);
        // tenhinhthuc.clear();
        // tenthidau.clear();
        // soao.clear();
        // seletedVaiTro = 'Chọn vai trò';
        // selectedValue = 'Vị trí thi đấu(Tùy chọn)';

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  bool checkSoAoExists(String soAoValue) {
    // Lặp qua danh sách cầu thủ từ API và kiểm tra giá trị so_ao
    for (var player in dataList) {
      if (player.so_ao == int.parse(soAoValue)) {
        return true; // Giá trị so_ao đã tồn tại
      }
    }
    return false; // Giá trị so_ao không tồn tại
  }

  void _showMenuVaiTro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              height: 50,
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vai trò',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                      seletedVaiTro = 'Vận động viên';
                      print('Giá trị chọn là $seletedVaiTro');
                    });
                    // fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Vận động viên',
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
                      seletedVaiTro = 'Ông Bầu';
                      print('Giá trị chọn là $seletedVaiTro');
                    });
                    // fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ông Bầu',
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
                    seletedVaiTro = 'HLV Trưởng';
                    print('Giá trị chọn là $seletedVaiTro');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'HLV Trưởng',
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
                    seletedVaiTro = 'Trợ lí HLV';
                    print('Giá trị chọn là $seletedVaiTro');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Trợ lí HLV',
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
                    seletedVaiTro = 'HLV Thủ Môn';
                    print('Giá trị chọn là $seletedVaiTro');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'HLV Thủ Môn',
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
                    seletedVaiTro = 'Đội Trưởng';
                    print('Giá trị chọn là $seletedVaiTro');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Đội Trưởng',
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
        // fetchData(selectedValue); // Gọi hàm fetchData() để cập nhật danh sách
      }
    });
  }

  void _handleContinueButtonTT() {
    setState(() {
      // Kiểm tra nếu người dùng không nhập giá trị
      if (soao.text.isEmpty) {
        _showErrorSoAo = true; // Hiển thị thông báo lỗi cho trường SĐT
      } else {
        _showErrorSoAo = false; // Xóa thông báo lỗi cho trường SĐT (nếu có)
      }
      if (tenthidau.text.isEmpty) {
        _showErrorTenTD = true; // Hiển thị thông báo lỗi cho trường Email
      } else {
        _showErrorTenTD = false; // Xóa thông báo lỗi cho trường Email (nếu có)
      }

      // Kiểm tra nếu không có thông báo lỗi cho bất kỳ trường nào
      if (!_showErrorTenTD && !_showErrorSoAo&&!_showErrorEmail) {
        if (checkSoAoExists(soAoValue)) {
          // Hiển thị thông báo giá trị đã tồn tại
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined, // Icon logout
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                    Text(
                      'Thông báo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                content: const Text('Số áo đã tồn tại'),
                actions: [
                  ElevatedButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          print('giá trị selectedValue là :$selectedValue');
          print('giá trị seletedVaiTro là :$seletedVaiTro');
        } else if (selectedValue == 'Vị trí thi đấu(Tùy chọn)' ||
            seletedVaiTro == 'Chọn vai trò') {
          // Hiển thị thông báo lỗi yêu cầu người dùng chọn giá trị
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Thông báo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                content: const Text('Bạn chưa chọn vị trí hoặc vai trò!'),
                actions: [
                  ElevatedButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
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
          addformTT();
          // Tiếp tục xử lý logic tiếp theo
        }
      }
    });
  }

  void _handleContinueButton() {
    setState(() {
      // Kiểm tra nếu người dùng không nhập giá trị
      if (soao.text.isEmpty) {
        _showErrorSoAo = true; // Hiển thị thông báo lỗi cho trường SĐT
      } else {
        _showErrorSoAo = false; // Xóa thông báo lỗi cho trường SĐT (nếu có)
      }
      if (tenthidau.text.isEmpty) {
        _showErrorTenTD = true; // Hiển thị thông báo lỗi cho trường Email
      } else {
        _showErrorTenTD = false; // Xóa thông báo lỗi cho trường Email (nếu có)
      }
      if(emailTaiKhoan.text.isEmpty){
        _showErrorEmail = true;
      }else{
        _showErrorEmail = false;
      }

      // Kiểm tra nếu không có thông báo lỗi cho bất kỳ trường nào
      if (!_showErrorTenTD && !_showErrorSoAo&&!_showErrorEmail) {
        if (checkSoAoExists(soAoValue)) {
          // Hiển thị thông báo giá trị đã tồn tại
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined, // Icon logout
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                    Text(
                      'Thông báo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                content: const Text('Số áo đã tồn tại'),
                actions: [
                  ElevatedButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          print('giá trị selectedValue là :$selectedValue');
          print('giá trị seletedVaiTro là :$seletedVaiTro');
        } else if (selectedValue == 'Vị trí thi đấu(Tùy chọn)' ||
            seletedVaiTro == 'Chọn vai trò') {
          // Hiển thị thông báo lỗi yêu cầu người dùng chọn giá trị
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Thông báo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                content: const Text('Bạn chưa chọn vị trí hoặc vai trò'),
                actions: [
                  ElevatedButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
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
          getIDLogin();
        //  getIDExist();
        // addform();
          // Tiếp tục xử lý logic tiếp theo
        }
      }
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
              color: Colors.white,
              height: 50,
              alignment: Alignment.center,
              child: const Row(
                children: [
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text(
                  //     'Hủy',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 100),
                    child: Text(
                      'Vị trí thi đấu(Tùy chọn)',
                      style: TextStyle(
                          color: Colors.black,
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
                      selectedValue = 'Thủ môn';
                      print('Giá trị chọn là Thủ môn');
                    });
                    // fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Thủ môn',
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
                      selectedValue = 'Hậu vệ';
                      print('Giá trị chọn là $selectedValue');
                    });
                    // fetchData(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hậu vệ',
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
                    selectedValue = 'Tiền vệ';
                    print('Giá trị chọn là $selectedValue');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Tiền vệ',
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
                    selectedValue = 'Tiền Đạo';
                    print('Giá trị chọn là $selectedValue');
                  });
                  // fetchData(selectedValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Tiền Đạo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            // Container(
            //   height: 40,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border(
            //       bottom: BorderSide(
            //         color: Colors.grey.shade300,
            //         width: 1,
            //       ),
            //     ),
            //   ),
            //   child: TextButton(
            //     onPressed: () {
            //       setState(() {
            //         selectedValue = 'Khác';
            //         print('Giá trị chọn là $selectedValue');
            //       });
            //       // fetchData(selectedValue);
            //       Navigator.pop(context);
            //     },
            //     child: const Text(
            //       'Khác',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 15,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    ).then((value) {
      // Xử lý khi giá trị combobox được chọn
      if (value != null) {
        setState(() {
          selectedValue = value;
        });
        // fetchData(selectedValue); // Gọi hàm fetchData() để cập nhật danh sách
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thêm thành viên GD', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pick_Players()),
                );
           
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Độ cong bo tròn (0 để tạo hình vuông)
                                child: Image.asset(
                                  '$selectedImageUser',
                                  width: 100,
                                  height: 90,
                                  // fit: BoxFit.cover, // Phù hợp vớis vùng cắt
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      showBottomSheet = true;
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                                0.8), // opacity giữa 0 và 1
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                 foregroundColor: Colors.black, backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.camera_alt),
                                                    SizedBox(
                                                        width:
                                                            8.0), // thêm khoảng cách giữa icon và text
                                                    Text(
                                                      'Chụp ảnh',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                 foregroundColor: Colors.black, backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.photo_library),
                                                    SizedBox(width: 10.0),
                                                    Text('Chọn ảnh từ hệ thống',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Image_User()),
                                                  );
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                 backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.photo_library),
                                                    SizedBox(width: 10.0),
                                                    Text('Chọn ảnh từ thư viện',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                 backgroundColor: Colors.blueGrey[
                                                      800], // sử dụng màu xanh dương
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0), // chỉ định bán kính bo tròn
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.cancel),
                                                    SizedBox(width: 10),
                                                    Text('Hủy',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        showBottomSheet = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              Text(
                                  'Liên kết thành viên với tài khoản trên hệ thống',
                                  style: TextStyle(color: Colors.black))
                            ]),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                    controller:emailTaiKhoan,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   _showErrorTenDoi = false;
                                        // });
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Nhập email tài khoản',
                                        hintStyle: const TextStyle(fontSize: 18),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        errorText: _showErrorEmail
                                            ? 'Vui lòng nhập email'
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('THÔNG TIN THI ĐẤU',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          soAoValue = value;
                                          _showErrorSoAo = false;
                                        });
                                      },
                                      controller: soao,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Số áo',
                                        hintStyle: const TextStyle(fontSize: 18),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        errorText: _showErrorSoAo
                                            ? 'Vui lòng nhập số áo'
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _showErrorTenTD = false;
                                        });
                                      },
                                      controller: tenthidau,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Tên thi đấu',
                                        hintStyle: const TextStyle(fontSize: 18),
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        errorText: _showErrorTenTD
                                            ? 'Vui lòng nhập tên thi đấu'
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showMenuStatus(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Vị trí thi đấu(tùy chọn)',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                  color: Colors.redAccent[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            selectedValue,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.navigate_next_rounded,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // GestureDetector(
                            //   onTap: () {
                            //     _showMenuVaiTro(context);
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.grey),
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Expanded(
                            //           child: Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Row(
                            //                 children: [
                            //                   Text(
                            //                     'Vai trò',
                            //                     style: TextStyle(
                            //                       color: Colors.black54,
                            //                       fontSize: 13,
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 5),
                            //                   Text(
                            //                     '*',
                            //                     style: TextStyle(
                            //                       color: Colors.redAccent[700],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               Text(
                            //                 seletedVaiTro,
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 15,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Icon(
                            //           Icons.navigate_next_rounded,
                            //           color: Colors.black,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ]),
                    ),
                    const SizedBox(height: 20),
                    const Text('THÔNG TIN CÁ NHÂN',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              // controller: tendoi,
                              onChanged: (value) {
                                // setState(() {
                                //   _showErrorTenDoi = false;_showErrorTenDoi
                                // });
                              },
                              controller: hoten,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Họ và tên',
                                hintStyle: TextStyle(fontSize: 18),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                // errorText: _showErrorTenDoi
                                //     ? 'Vui lòng nhập tên đội'
                                //     : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              // controller: tendoi,
                              onChanged: (value) {
                                // setState(() {
                                //   _showErrorTenDoi = false;
                                // });
                              },
                              controller: sdt,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Số điện thoại',
                                hintStyle: TextStyle(fontSize: 18),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                // errorText: _showErrorTenDoi
                                //     ? 'Vui lòng nhập tên đội'
                                //     : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // addform();
                                        // getPlayers();
                                        _handleContinueButton();
                                      },
                                      child: const Text('HOÀN THÀNH',
                                          style: TextStyle(fontSize: 15)),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(255, 213, 246,
                                                    215)), // Màu nền của button
                                        foregroundColor: MaterialStateProperty
                                            .all<Color>(Colors
                                                .green), // Màu chữ của button
                                      ),
                                    ),
                                  ),
                                ]),
                                Container(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _handleContinueButtonTT();
                                    },
                                    child: const Text('TIẾP TỤC THÊM',
                                        style: TextStyle(fontSize: 15)),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors
                                                  .green), // Màu nền của button
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors
                                                  .white), // Màu chữ của button
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
