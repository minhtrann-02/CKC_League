import 'package:flutter/material.dart';
import 'package:ckc_league/Object_API/object_api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Rank_Screen extends StatefulWidget{
  @override
  State<Rank_Screen>createState()=>Rank_Screen_State();
}

class Rank_Screen_State extends State<Rank_Screen> {
   String access_token = '';
   int idGiaiDau = 0;
   int tongTranDau = 0;
     late List data;
     List<Data> dataList = []; // Khởi tạo một mảng mới
     List<int> doiBongIds = [];
     List<int> soTranThang = [];
     List<int> tongSoTran = [];
     List<int>soTranHoa = [];
     List<int>tongBanThang = [];
     List<int>tongBanThua=[];
     List<int>soTranThua = [];
     List<int>hieuSo = [];
     List<int>diem = [];
     List<String> doiBongNames = [];
     List<String> doiBongUrls = [];
     List<Team> teams = [];
void fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
  access_token = prefs.getString('accessToken') ?? '';
  print('ID giải đấu: $idGiaiDau');
  final String url =
      'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau1?token=$access_token';
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['data'] != null) {
      // Lọc danh sách dữ liệu theo cột 'giai_dau_id'
      dataList = (responseData['data'] as List)
          .where((item) => item['giai_dau_id'] == idGiaiDau)
          .map((item) => Data.fromJson(item))
          .toList();

      for (var item in dataList) {
        if (!doiBongIds.contains(item.doi_bong_id)) {
          doiBongIds.add(item.doi_bong_id!);
          soTranThang.add(item.soTranThang!);
          soTranHoa.add(item.soTranHoa!);
          soTranThua.add(item.soTranThua!);
          tongBanThang.add(item.tong_ban_thang!);
          tongBanThua.add(item.tong_ban_thua!);
          print(doiBongIds);

          tongTranDau += item.soTranThang! + item.soTranHoa! + item.soTranThua!;
          List<dynamic> doiBongInfo = await getDoiBong1(item.doi_bong_id!);
          String doiBongName = doiBongInfo[0] as String; // Khai báo biến doiBongName
          String doiBongLogo = doiBongInfo[1] as String; // Khai báo biến doiBongLogo
          doiBongNames.add(doiBongName);
          doiBongUrls.add(doiBongLogo);
          print(doiBongName);
          print(doiBongLogo);
          print('Tong tran dau: $tongTranDau');
        }
      }

      for (int i = 0; i < doiBongIds.length; i++) {
        int tong = soTranThang[i] + soTranThua[i] + soTranHoa[i];
        tongSoTran.add(tong);

        int HS = tongBanThang[i] - tongBanThua[i];
        hieuSo.add(HS);

        int Diem = soTranThang[i] * 3 + soTranHoa[i];
        diem.add(Diem);
      }

      // Cập nhật danh sách teams và sắp xếp theo điểm số giảm dần
      teams = [];
      for (int i = 0; i < doiBongIds.length; i++) {
        Team team = Team(
          doiBongId: doiBongIds[i],
          doiBongName: doiBongNames[i],
          doiBongUrl: doiBongUrls[i],
          tongSoTran: tongSoTran[i],
          soTranThang: soTranThang[i],
          soTranHoa: soTranHoa[i],
          soTranThua: soTranThua[i],
          hieuSo: hieuSo[i],
          diem: diem[i],
        );
        teams.add(team);
      }

      teams.sort((a, b) {
        if (b.diem != a.diem) {
          return b.diem.compareTo(a.diem); // Sắp xếp theo điểm giảm dần
        } else if (b.doiBongName != a.doiBongName) {
          return a.doiBongName.compareTo(b.doiBongName); // Sắp xếp theo tên đội bóng tăng dần
        } else if (b.tongSoTran != a.tongSoTran) {
          return b.tongSoTran.compareTo(a.tongSoTran); // Sắp xếp theo số trận đấu giảm dần
        } else {
          return b.hieuSo.compareTo(a.hieuSo); // Sắp xếp theo hiệu số giảm dần
        }
      });

      print('Tổng số trận theo từng chỉ mục:');
      for (int i = 0; i < tongSoTran.length; i++) {
        print('Đội ${doiBongIds[i]}: ${tongSoTran[i]} trận');
      }

      setState(() {
        // Cập nhật trạng thái của biến teams
        this.teams = teams;
      });
    }
  } else {
    throw Exception('Failed to load data');
  }
}








Future<List<dynamic>> getDoiBong1(int doiBongId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  access_token = prefs.getString('accessToken') ?? '';
  final String url =
      'http://10.0.2.2:8000/api/auth/football/$doiBongId?token=$access_token';
  final headers = {'User-Agent': 'MyApp/1.0'};
  final response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    final doiBongName = responseData['data']['ten_doi_bong'];
    final logoUrl = responseData['data']['logo'];
    return [doiBongName, logoUrl];
  } else {
    throw Exception('Failed to load team data');
  }
}



@override
  void initState() {
    super.initState();
    data = [];
    fetchData();
 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   Color(0xFA011129),
        centerTitle: true,
        title: Text('Bảng xếp hạng'),
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Điều hướng trở lại trang trước
          },
        ),
      ),
      body: Container(
  child: Column(
    children: [
      Container(
        color:  Color(0xFA011129),
        height: 50,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '#   Đội',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trận',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'T-H-B',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Hiệu số',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Điểm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
   itemCount: teams.length,
  itemBuilder: (BuildContext context, int index) {
    Team team = teams[index];
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 15),
      height: 60,
      decoration:  BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  (index + 1).toString(),
                  style:  TextStyle(
                    fontSize: 16,
                  ),
                ),
                 SizedBox(width: 5),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    team.doiBongUrl,
                    height: 35,
                    width: 35,
                  ),
                ),
                Text(
                  team.doiBongName,
                  style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
           Expanded(
            flex: 3,
            child: Row(
              children: [
                SizedBox(width: 12),
                Text(
                    tongSoTran[index].toString(),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 35),
                Text.rich(
                  TextSpan(
                    children: [ 
                      TextSpan(
                        text: '${team.soTranThang}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '-${team.soTranHoa}-',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${team.soTranThua}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Text(
                  hieuSo[index].toString(),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 40),
                Text(
                  team.diem.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)

      ),
    ],
  ),
),

    );
  }
}


class Team {
  final int doiBongId;
  final String doiBongName;
  final String doiBongUrl;
  final int tongSoTran;
  final int soTranThang;
  final int soTranHoa;
  final int soTranThua;
  final int hieuSo;
  final int diem;

  Team({
    required this.doiBongId,
    required this.doiBongName,
    required this.doiBongUrl,
    required this.tongSoTran,
    required this.soTranThang,
    required this.soTranHoa,
    required this.soTranThua,
    required this.hieuSo,
    required this.diem,
  });
}