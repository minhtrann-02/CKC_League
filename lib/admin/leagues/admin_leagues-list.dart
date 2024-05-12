// ignore_for_file: file_names, depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:ckc_league/admin/leagues/admin_leagues-infor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Object_API/object_api.dart';
import '../main_screen.dart';
import 'add_leagues/admin_add-leagues.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaguesList extends StatefulWidget {
  const LeaguesList({super.key});

  @override
  State<StatefulWidget> createState() => LeaguesListState();
}

class LeaguesListState extends State<LeaguesList> {
  List<Data> filteredData = [];
  List<Data> newfilteredData = [];
  List<Data> initialData = [];
  List<Data> searchResults = [];
  List<Data> dataList = [];
  List<Data> displayedList = [];
  String access_token = '';
  bool isLoading = true;
  String searchQuery = '';
  String tengiaidau = '';
  bool isSearching = false;
  final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau';
  final String apiHinhThuc = 'http://10.0.2.2:8000/api/auth/HinhThuc';

  Future<void> fetchGiaiDauData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(apiGiaiDau), headers: headers);

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      List<dynamic> results = decodedJson['data'];
      List<Data> newData = [];

      for (int i = 0; i < results.length; i++) {
        var customerJson = results[i];
        newData.add(Data.fromJson(customerJson));
      }

      setState(() {
        filteredData.clear();
        filteredData.addAll(newData);
        initialData = List.from(filteredData);
        newfilteredData = List.from(initialData);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void searchInDataList(String query) async{
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // tengiaidau = prefs.getString('ten_giai_dau')??'';
    // setState(() {
    //   searchQuery = query;
    //   if (query.isNotEmpty) {
    //     isSearching = true;
    //     filteredData = filteredData.where((dataItem) {
    //       return dataItem.ten_giai_dau.toString().toLowerCase().contains(query)||
    //       dataItem.ban_to_chuc.toString().toLowerCase().contains(query)||
    //        dataItem.ten_hinh_thuc.toString().toLowerCase().contains(query)||
    //         dataItem.san_dau.toString().toLowerCase().contains(query);
    //     }).toList();
    //   } else {
    //     setState(() {
    //       isSearching = false;
    //     });
    //   }
    // });
  }

  // void updateDisplayedList() {
  //   setState(() {
  //     if (searchResults.isNotEmpty) {
  //       displayedList = searchResults; // Sử dụng searchResults nếu có tìm kiếm
  //     } else {
  //       displayedList = dataList; // Sử dụng dataList nếu không có tìm kiếm
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchGiaiDauData();
  }

  Future<String> getTenHinhThuc(int hinhThucDauId) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final hinhThucDataResponse =
        await http.get(Uri.parse(apiHinhThuc), headers: headers);
    if (hinhThucDataResponse.statusCode == 200) {
      final hinhThucData = jsonDecode(hinhThucDataResponse.body)['data'];

      for (var giaiDau in filteredData) {
        if (giaiDau.hinh_thuc_dau_id == hinhThucDauId) {
          for (var hinhThuc in hinhThucData) {
            if (hinhThuc['id'] == hinhThucDauId) {
              return hinhThuc['ten_hinh_thuc'];
            }
          }
        }
      }
      throw Exception('Matching hinh_thuc not found');
    } else {
      throw Exception('Failed to fetch hinh_thuc data');
    }
  }

  void onInfor(int index) async {
    final selectedData = filteredData[index];
    final tenHinhThuc =
        await getTenHinhThuc(selectedData.hinh_thuc_dau_id as int);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lưu giá trị vào SharedPreferences
    prefs.setInt('id', selectedData.id ?? 0);
    prefs.setInt('idGiaiDau', selectedData.id ?? 0);
    prefs.setString('ten_giai_dau', selectedData.ten_giai_dau ?? '');
    prefs.setString('tenHinhThuc', tenHinhThuc);
    prefs.setString('ngay_bat_dau', selectedData.ngay_bat_dau ?? '');
    prefs.setString('ngay_ket_thuc', selectedData.ngay_ket_thuc ?? '');
  
    prefs.setString('ban_to_chuc', selectedData.ban_to_chuc ?? '');
    prefs.setString('san_dau', selectedData.san_dau ?? '');
    prefs.setInt('so_vong_dau', selectedData.so_vong_dau ?? 0);
    prefs.setInt('so_tran_da_dau', selectedData.so_tran_da_dau ?? 0);
    prefs.setInt('so_bang_dau', selectedData.so_bang_dau ?? 0);
    prefs.setInt(
        'so_doi_vao_vong_trong', selectedData.so_doi_vao_vong_trong ?? 0);
    prefs.setInt('loai_san', selectedData.loai_san ?? 0);
    prefs.setInt('so_luong_doi_bong', selectedData.so_luong_doi_bong ?? 0);
    prefs.setInt('hinh_thuc_dau_id', selectedData.hinh_thuc_dau_id ?? 0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LeaguesInforAdmin_Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xF8001F4E),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MainScreen_Admin()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddLeagues_Screen()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 7),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Tìm kiếm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                searchInDataList(value);
                setState(() {
                  
                });
              },
            ),
          ),
        ),
        title: const Text('Danh sách giải đấu'),
      ),
      body: Container(
        color: Colors.grey[400],
        child: Column(
          children: [
            // Số lượng giải đấu
            Expanded(
              child: Container(
                color: Colors.grey[300],
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredData.length} Giải đấu',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Danh sách giải đấu
            Expanded(
              flex: 14,
              child: RefreshIndicator(
                onRefresh: () async {
                  fetchGiaiDauData();
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ) // Widget loading
                    : ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final giaiDau = filteredData[index];
                          final hinhThucDauId = giaiDau.hinh_thuc_dau_id;
                          double line = filteredData[index].so_tran_da_dau! /
                              filteredData[index].so_vong_dau!;
                          return FutureBuilder<String>(
                            future: getTenHinhThuc(hinhThucDauId as int),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final tenHinhThuc = snapshot.data;

                                return Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: ListTile(
                                    title: ElevatedButton(
                                      onPressed: () {
                                        onInfor(index);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            tinhTrangGiaiDau(
                                                filteredData[index]
                                                    .so_tran_da_dau as int,
                                                filteredData[index].so_vong_dau
                                                    as int),
                                            const SizedBox(height: 10),
                                            Text(
                                              filteredData[index]
                                                  .ten_giai_dau
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${filteredData[index].so_tran_da_dau}/${filteredData[index].so_vong_dau} trận',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 3),
                                            LinearProgressIndicator(
                                              value: line,
                                              minHeight: 5,
                                              backgroundColor: Colors.grey[300],
                                              valueColor: (line < 1)
                                                  ? const AlwaysStoppedAnimation<
                                                      Color>(Colors.green)
                                                  : AlwaysStoppedAnimation<
                                                      Color?>(Colors.grey[600]),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              tenHinhThuc.toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              filteredData[index]
                                                  .ban_to_chuc
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              filteredData[index]
                                                  .san_dau
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return ListTile(
                                  title: Text(giaiDau.ten_giai_dau.toString()),
                                  subtitle: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tinhTrangGiaiDau(int a, int b) {
    return Container(
      height: 25,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (a == 0)
            ? Colors.blue[50]
            : (a < b)
                ? Colors.green[50]
                : Colors.red[50],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        (a == 0)
            ? 'Đang đăng ký'
            : (a < b)
                ? 'Hoạt động'
                : 'Kết thúc',
        style: TextStyle(
          color: (a == 0)
              ? Colors.blue
              : (a < b)
                  ? Colors.green
                  : Colors.red,
        ),
      ),
    );
  }
}
