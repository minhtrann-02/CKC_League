// ignore_for_file: camel_case_types, unused_import, unused_local_variable
import 'dart:io';
import 'package:ckc_league/menu_bottom/home_page.dart';
import 'package:ckc_league/menu_bottom/leagues/infor-leagues_srceen.dart';
import 'package:ckc_league/menu_bottom/leagues/leagues_screen.dart';
import 'package:flutter/material.dart';
import '../../Object_API/object_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Notification_Scren extends StatefulWidget {
  const Notification_Scren({super.key});

  @override
  State<Notification_Scren> createState() => _Notification_ScrenState();
}

class _Notification_ScrenState extends State<Notification_Scren> {
  int countCho = 0;
  int countTuChoi = 0;
  int idDanhSach1 = 0;
  int countDangKy = 0;
  int idGiaiDau = 0;
  String noidungTB = '';
  int idDoiBong = 0;
  String thoigian = '';
  String noiDung = '';
  String tenGiaiDau = '';
  bool showRedDot = false;
  List<Data> dataList = [];
  List<Data> dataListDS = [];
  List<int> selectedIds = [];
  List<bool> isChecked = [];
  List<int> idListDS = []; 
  String access_token = '';
  int countStatus(List<Data> dataList, int status) {
    int count = 0;
    for (var data in dataList) {
      if (data.trangThaiDangKy == status) {
        count++;
      }
    }
    return count;
  }
  void getIDDangKyGiai() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  idDoiBong = prefs.getInt('idDoiBong') ?? 0;
  idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
  print('Phan Đình Tuấn: $idDoiBong');
  print('id giai dau la:$idGiaiDau');
  String url = 'http://10.0.2.2:8000/api/auth/DangKyGiai?token=$access_token';
  final headers = {
    'User-Agent': 'MyApp/1.0',
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    final List<dynamic> data = responseData['data'];

    List<int> idList = [];

    for (var item in data) {
      if (item['doi_bong_id'] == idDoiBong) {
        idList.add(item['id']);
      }
    }

    setState(() {
      // Cập nhật danh sách id đã lọc
      idListDS = idList;
    });
    for (var id in idListDS) {
  print('id: $id');
  
}

  } else {
    print('Load failed');
  }
}


void getTenGiaiDau() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  idDoiBong = prefs.getInt('idDoiBong') ?? 0;
  idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
  
  String url = 'http://10.0.2.2:8000/api/auth/GiaiDau/$idGiaiDau?token=$access_token';
  final headers = {
    'User-Agent': 'MyApp/1.0',
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
     tenGiaiDau = responseData['data']['ten_giai_dau'];
    
    setState(() {
      
    });
    // Gán giá trị tên giải đấu vào biến text
   
  } else {
    print('Load failed');
  }
}

Future<void> updateThongBao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDanhSach1 = prefs.getInt('idDangKyGiai') ?? 0;
    access_token = prefs.getString('accessToken') ?? '';
     noidungTB = prefs.getString('noidungTB') ?? '';
   print('id UPdateTongbao:$idDanhSach1');//sai 
    final url =
        'http://10.0.2.2:8000/api/auth/DangKyGiai/$idDanhSach1?token=$access_token'; // Thay đổi URL của API tương ứng
    final headers = {'Content-Type': 'application/json'};
    // final body = jsonEncode(newData.toJson()); // Chuyển đổi đối tượng newData thành JSON
    final requestData = { 
      'trang_thai_dang_ky': '-1',
      'noi_dung':noidungTB,
      'trang_thai_tb': '1',
    };
    final String requestBody = json.encode(requestData);

    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final request = await client.patchUrl(Uri.parse(url));

    request.headers.contentType = ContentType.json;
    request.headers.add('User-Agent', 'MyApp/1.0');
    request.write(jsonEncode(requestData));

    final response = await request.close();
    print(response.statusCode);
    if (response.statusCode == HttpStatus.ok) {
     print('Cập nhật trạng thái thông báo thành công');
    } else {
      // Xử lý lỗi khi cập nhật không thành công
      print('Cap nhat khong thanh cong');
    }
  }
  //  void lấy () async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   access_token = prefs.getString('accessToken') ?? '';
  //    nguoiquanlyid = prefs.getInt('ID') ?? 0;
  //   final String url =
  //       'http://10.0.2.2:8000/api/auth/football?token=$access_token';
  //   final headers = {'User-Agent': 'MyApp/1.0'};
  //   final response = await http.get(Uri.parse(url), headers: headers);
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);

  //     if (responseData['data'] != null) {
  //       for (var item in responseData['data']) {
  //         Data data = Data.fromJson(item);
  //         if (data.nguoiQuanLyId == nguoiquanlyid) {
  //           dataList.add(data);
  //           print('data là:${data.khoa}');
  //             print('lớp:${data.lop}');
  //                print('tên đội bóng: ${data.tenDoiBong}');
  //                logoSL = data.logo!;
  //                khoaSL = data.khoa!;
  //                tenDB = data.tenDoiBong!;
  //                lopSL = data.lop!;
  //                idDoiBong =data.id!; 
  //                print('logo: $logoSL');
  //         }
  //       }
  //     }
     
  //     teamCount = dataList.length;
  //     prefs.setString('logoSL',logoSL);
  //     prefs.setInt('idDoiBong',idDoiBong);
  //       prefs.setString('lopSL',lopSL);
  //       prefs.setInt('khoaSL',khoaSL);
  //         prefs.setString('tenDB',tenDB);
  //     prefs.setInt('nguoiquanlyidSL', nguoiquanlyid);
  //     prefs.setInt('soLuongDoi',teamCount);
      
  //     print('Người quản lý ID: $nguoiquanlyid');
  //     print('Số lượng đội: $teamCount');

  //     // Cập nhật giá trị số lượng đội bóng để hiển thị trên màn hình
  //     quality = teamCount.toString();
  //     hasTeams = teamCount > 0; // Kiểm tra nếu có đội thì hasTeams = true
  //     setState(() {});
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
 void dsApply() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;

  String url = 'http://10.0.2.2:8000/api/auth/DangKyGiai';
  final headers = {
    'User-Agent': 'MyApp/1.0',
    'Authorization': 'Bearer $access_token'
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData['data'] is List) {
      final List<dynamic> data = responseData['data'];

      bool showRedDot = false;
      List<Data> filteredDataList = [];

      for (var item in data) {
        if (item['doi_bong_id'] == idDoiBong && item['trang_thai_dang_ky'] == -1) {
          filteredDataList.add(Data.fromJson(item));
          print('id doi bong trong data: ${item['doi_bong_id']}');
          print('Tên đội bóng trong data: ${item['giai_dau_id']}');
            print('id id id iiido: ${item['id']}');
            idDanhSach1=item['id'];
            prefs.setInt('idDangKyGiai',idDanhSach1);
        }
      }

      setState(() {
        dataListDS = filteredDataList;
      });

      print('Lay danh sach dang ky thanh cong');
      for (var data in dataListDS) {
        noiDung = data.noi_dung ?? '';
        thoigian = data.updatedAt ?? '';
        int idGiaiDau = data.giaiDauId!;
        prefs.setInt('iDGiaiDau1', idGiaiDau);
        prefs.setString('noidungTB', noiDung);
      }

      setState(() {
        this.showRedDot = showRedDot;
      });
    } else {
      print('Data is not a List');
    }
  } else {
    throw Exception('Failed to load data');
  }
}





  @override
  void initState() {
    super.initState();
    dsApply();
    getTenGiaiDau();
    updateThongBao();
    getIDDangKyGiai();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
         leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home_Page(),
      ),
    );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 90),
        child: Column(
          children: [
             if (dataListDS.isEmpty)
            Container(
              // Hiển thị thông báo "Chưa có thông báo"
              height: 100,
              child: Center(
                child: Text(
                  'Chưa có thông báo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          else
Container(
              // color: Colors.blue,
              margin: EdgeInsets.only(left:10),
              height: 100,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Thông báo từ giải ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            tenGiaiDau.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Text('Giải của đội bạn đăng ký đã bị từ chối!'),
                      Text(
                        'Lý do: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        noiDung,
                      ),
                      Text(thoigian,style: TextStyle(fontSize: 15),),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black54,
                      )
                    ],
                  )
                ],
              ),
            )
          
          ],
        ),
      ),
    );
  }
}
