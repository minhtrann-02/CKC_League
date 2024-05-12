import 'package:ckc_league/menu_bottom/my_team/QuyDoi/category.dart';
import 'package:ckc_league/menu_bottom/my_team/QuyDoi/fund_team.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Transaction_State();
}

class Transaction_State extends State<Transaction> {
  List<String> playerNames = []; // Danh sách giá trị tên cầu thủ
  int? selectedRadio;
  String access_token = '';
  int? idDoiBong = 0;
  String? selectedPlayer;
  bool _showErrorTieuDe = false;
  bool _showErrorSoTien = false;
  late SharedPreferences prefs;
  TextEditingController sotien = TextEditingController();
  TextEditingController tieude = TextEditingController();

  String selectedCategory = 'Chọn danh mục';
  String selectedPlayerName = ''; // Tên cầu thủ được chọn
  void fetchPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    String url = 'http://10.0.2.2:8000/api/auth/players';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      // Lọc danh sách theo cột 'doi_bong_id'
      final filteredDataList =
          data.where((item) => item['doi_bong_id'] == idDoiBong).toList();

      setState(() {
        playerNames = filteredDataList
            .map<String>((item) => item['ten_cau_thu'])
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void addformTT() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
    print('idDoiBong là: $idDoiBong');
    print('nguoi_dong_tien: ${selectedPlayer.toString()}');
    print('trang_thai: ${selectedRadio.toString()}');
    print('tieu_de: ${tieude.text.toString()}');
    print('so tien quy: ${sotien.text.toString()}');
    final String url =
        'http://10.0.2.2:8000/api/auth/QuyDoi?token=$access_token';
    final headers = {'User-Agent': 'MyApp/1.0'};

    final response = await http.post(
      Uri.parse(url),
      body: {
        'doi_bong_id': idDoiBong.toString(),
        'nguoi_dong_tien': selectedPlayer.toString(),
        'tieu_de': tieude.text.toString(),
        'trang_thai': selectedRadio.toString(),
        'danh_muc': selectedCategory.toString(),
        'so_tien_quy': sotien.text.toString(),
        'thoi_gian': formattedDate,
      },
      headers: headers,
    );

    print(response.statusCode);
    setState(() {
      if (response.statusCode == 201) {
        print('Thêm cầu thủ thành công ');
        showSuccessDialogTT(context);
        // tenhinhthuc.clear();
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  void showSuccessDialogTT(BuildContext context) {
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
          content: Text('Thêm giao dịch thành công'),
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
                sotien.clear();
                tieude.clear();
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

  void _handleContinueButtonTT() {
  String SoTien = sotien.text;
  String TieuDe = tieude.text;
  setState(() {
    // Kiểm tra nếu người dùng không nhập giá trị
    if (SoTien.isEmpty) {
      _showErrorSoTien = true; // Hiển thị thông báo lỗi cho trường SĐT
    } else {
      _showErrorSoTien = false; // Xóa thông báo lỗi cho trường SĐT (nếu có)
    }
    if (TieuDe.isEmpty) {
      _showErrorTieuDe = true; // Hiển thị thông báo lỗi cho trường Email
    } else {
      _showErrorTieuDe = false; // Xóa thông báo lỗi cho trường Email (nếu có)
    }
  });

  if (SoTien.isEmpty || TieuDe.isEmpty) {
    // Kiểm tra nếu một trong hai trường là rỗng
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          content: Text('Hãy nhập thông tin'),
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

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  } else if (int.parse(SoTien) <= 0) {
    // Kiểm tra nếu giá trị của sotien <= 0
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Lỗi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text('Số tiền phải lớn hơn 0'),
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

                setState(() {});
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
  } else if(selectedPlayer == null){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline, // Icon logout
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8), // Khoảng cách giữa Icon và Text
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          content: Text('Hãy chọn người đóng tiền'),
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

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
}else{
  addformTT();
}
}


  @override
  void initState() {
    super.initState();
    fetchPlayer();
    selectedRadio = 0; // Mặc định chọn radio button thứ nhất
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
        int? storedValue = prefs.getInt('selectedRadio');
        if (storedValue != null) {
          selectedRadio = storedValue;
          selectedCategory = getCategoryText(selectedRadio!);
        }
      });
    });
  }

  String getCategoryText(int selectedRadio) {
    if (selectedRadio == 1) {
      return 'Đóng quỹ';
    } else if (selectedRadio == 2) {
      return 'Giải thưởng';
    } else if (selectedRadio == 3) {
      return 'Tài trợ';
    } else if (selectedRadio == 4) {
      return 'Sân bãi';
    } else if (selectedRadio == 5) {
      return 'Ăn uống';
    } else if (selectedRadio == 6) {
      return 'Dụng cụ, công cụ';
    } else if (selectedRadio == 7) {
      return 'Phí tham gia giải đấu';
    } else if (selectedRadio == 8) {
      return 'Thăm hỏi thành viên';
    } else {
      return '';
    }
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thêm giao dịch',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.navigate_before_outlined, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.warning_rounded, // Icon logout
                          color: Colors.orange,
                          size: 24,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Thông báo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                        'Các thông tin vừa nhập chưa được lưu! Bạn có muốn tiếp tục?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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

                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            child: Text(
                              'Quay lại',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Fund_Team()));

                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('THÔNG TIN CƠ BẢN',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tieude,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tiêu đề',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          errorText:
                              _showErrorTieuDe ? 'Vui lòng nhập tiêu đề' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
             TextField(
  controller: sotien,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Số tiền',
    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    errorText: _showErrorSoTien ? 'Vui lòng nhập số tiền' : null,
  ),
  keyboardType: TextInputType.number,
  inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
  ],
  onChanged: (value) {
    setState(() {
      // Kiểm tra nếu giá trị nhập là 0
      if (int.parse(value) == '0') {
        _showErrorSoTien = true; // Hiển thị thông báo lỗi
      } else {
        _showErrorSoTien = false; // Xóa thông báo lỗi (nếu có)
      }
    });
  },
),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Category()));
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Danh mục',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.redAccent[700],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              selectedCategory,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        onChanged: (val) {
                          setSelectedRadio(val as int);
                        },
                      ),
                      Text('Đã thu tiền'),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        onChanged: (val) {
                          setSelectedRadio(val as int);
                        },
                      ),
                      Text('Chưa thu tiền'),
                    ],
                  ),
                ],
              ),
              Text('TUỲ CHỌN NÂNG CAO',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: selectedPlayer,
                hint: Text('Người đóng tiền'),
                isExpanded: true,
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('Chọn giá trị'),
                  ),
                  ...playerNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPlayer = newValue;
                  });
                  if (newValue != null) {
                    print(newValue); // In giá trị đã chọn
                  }
                },
                dropdownColor: Colors.grey[200],
                style: TextStyle(color: Colors.black),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                underline: Container(
                  height: 2,
                  color: Colors.grey,
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
                      _handleContinueButtonTT();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      'THÊM',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
