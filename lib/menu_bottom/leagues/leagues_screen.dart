// ignore_for_file: camel_case_types, use_key_in_widget_constructors, depend_on_referenced_packages, unrelated_type_equality_checks, unused_local_variable
import 'package:flutter/material.dart';
import '../../Object_API/object_api.dart';
import '../home/notification.dart';
import '../home/search.dart';
import 'infor-leagues_srceen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Leagues_Screen extends StatefulWidget {
  const Leagues_Screen({Key? key});

  @override
  State<StatefulWidget> createState() => Tourament_Screen_State();
}

class Tourament_Screen_State extends State<Leagues_Screen> {
  // List<Data> GiaiDau
  List<Data> filteredGDData = [];
  List<Data> newFilteredGDData = [];
  List<Data> initialGDData = [];
  int countCho = 0;
  int countTuChoi = 0;
  int countDangKy = 0;
  int idGiaiDau = 0;
  int idDoiBong = 0;
  int idTeam = 0;
  bool showRedDot = false;
  bool isSearching = false;
  bool isLoading = true;
  List<Data> dataList = [];
  List<Data> dataListDS = [];
  List<int> selectedIds = [];
  List<bool> isChecked = [];
  List<Data> searchResults = [];
  final String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau';
  final String apiHinhThuc = 'http://10.0.2.2:8000/api/auth/HinhThuc';
  String access_token = '';
  // Chuyển màn hình và lưu dữ liệu sang màn hình chi tiết
  void onInfor(int index) async {
    final selectedData = (isSearching ? searchResults : filteredGDData)[index];
    final tenHinhThuc =
        await getTenHinhThuc(selectedData.hinh_thuc_dau_id as int);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Lưu giá trị vào SharedPreferences
    prefs.setString('IDGiaiDau', selectedData.id.toString());
    prefs.setString('ten_giai_dau', selectedData.ten_giai_dau ?? '');
    prefs.setString('hinh_thuc_dau_id', tenHinhThuc);
    prefs.setString('ban_to_chuc', selectedData.ban_to_chuc ?? '');
    prefs.setString('san_dau', selectedData.san_dau ?? '');
    prefs.setString('so_vong_dau', selectedData.so_vong_dau.toString());
    prefs.setString('so_tran_da_dau', selectedData.so_tran_da_dau.toString());
    prefs.setInt('so_luong_doi_bong', selectedData.so_luong_doi_bong ?? 0);

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InforTouament(),
      ),
    );
  }

  void dsApply() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getInt('idGiaiDau') ?? 0;
    idDoiBong = prefs.getInt('idDoiBong') ?? 0;
    print('Id giải đấu: $idGiaiDau');
    String url = 'http://10.0.2.2:8000/api/auth/DangKyGiai';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      bool showRedDot =
          false; // Khởi tạo biến để xác định xem có hiển thị số 1 màu đỏ hay không

      for (var item in data) {
        if (item['trang_thai_dang_ky'] == -1 &&
            item['doi_bong_id'] == idDoiBong &&
            item['trang_thai_tb'] == -1) {
          showRedDot = true; // Nếu trạng thái là -1, hiển thị số 1 màu đỏ
          break; // Thoát khỏi vòng lặp nếu đã tìm thấy trạng thái -1
        }
      }

      final filteredDataList = data
          .where((item) =>
              [2, 1, -1].contains(item['trang_thai_dang_ky']) &&
              item['giai_dau_id'] == idGiaiDau)
          .toList();

      setState(() {
        dataListDS = filteredDataList.map((x) => Data.fromJson(x)).toList();
        isChecked = List.filled(
            dataListDS.length, false); // Khởi tạo danh sách trạng thái checkbox
        countCho =
            countStatus(dataListDS, 2); // Tính tổng trạng thái "Đang chờ"
        countDangKy =
            countStatus(dataListDS, 1); // Tính tổng trạng thái "Đã duyệt"
        countTuChoi =
            countStatus(dataListDS, -1); // Tính tổng trạng thái "Từ chối"
      });

      print('Lay danh sach dang ky thanh cong');
      for (var data in dataListDS) {
        print('id doi bong trong data: ${data.doi_bong_id}');
        print('Tên đội bóng trong data: ${data.tenDoiBong}');
        print('Ngay dang ky: ${data.ngaydangky}');
        print('Giai dau id: ${data.giaiDauId}');
        print('trang thai: ${data.trangThaiDangKy}');
        idTeam = data.doi_bong_id!;
        prefs.setInt('idTeam', idTeam);
      }

      setState(() {
        // Cập nhật biến showRedDot để áp dụng thay đổi trên giao diện
        this.showRedDot = showRedDot;
      });
    } else {
      print('Lỗi thông báo: ${response.statusCode}');
    }
  }

  int countStatus(List<Data> dataList, int status) {
    int count = 0;
    for (var data in dataList) {
      if (data.trangThaiDangKy == status) {
        count++;
      }
    }
    return count;
  }

  void fetchGiaiDauData() async {
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
        filteredGDData.clear();
        filteredGDData.addAll(newData);
        initialGDData = List.from(filteredGDData);
        newFilteredGDData = List.from(initialGDData);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getTenHinhThuc(int hinhThucDauId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token'
    };
    final giaiDauData = filteredGDData;
    final hinhThucDataResponse =
        await http.get(Uri.parse(apiHinhThuc), headers: headers);
    if (hinhThucDataResponse.statusCode == 200) {
      final hinhThucData = jsonDecode(hinhThucDataResponse.body)['data'];

      for (var giaiDau in giaiDauData) {
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

  @override
  void initState() {
    super.initState();
    fetchGiaiDauData();

    dsApply();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth_1 = MediaQuery.of(context).size.width;
    final buttonWidth_1 = screenWidth_1 * 0.4; // Tỉ lệ màn hình mong muốn
    final screenWidth_2 = MediaQuery.of(context).size.width;
    final buttonWidth_2 = screenWidth_2 * 0.3;

    // ignore: no_leading_underscores_for_local_identifiers
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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Trạng thái',
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Đang đăng ký',
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hoạt động',
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
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Kết thúc',
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
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _showMenuForm(BuildContext context) {
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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Hình thức',
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Loại trực tiếp',
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Đấu vòng tròn',
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
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Chia bảng đấu',
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
      );
    }

    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
          title: const Text(
            'Giải đấu',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: onNotification,
                  icon: const Icon(Icons.notifications_rounded),
                ),
                if (showRedDot) // Kiểm tra nếu trạng thái là -1, hiển thị số 1 màu đỏ
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'Tất cả giải',
                ),
              ),
              Tab(
                child: Text(
                  'Giải tham gia',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Tất cả giải
            Column(
              children: [
                //Thanh tác vu
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  _showMenuStatus(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  side: const BorderSide(
                                      color: Colors
                                          .grey), // Màu sắc và độ dày của viền
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Độ cong góc viền
                                  ),
                                  minimumSize: Size(buttonWidth_1,
                                      0), // Đặt chiều rộng tối thiểu cho button
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Trạng thái',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                    )
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  _showMenuForm(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  side: const BorderSide(
                                      color: Colors
                                          .grey), // Màu sắc và độ dày của viền
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Độ cong góc viền
                                  ),
                                  minimumSize: Size(buttonWidth_1,
                                      0), // Đặt chiều rộng tối thiểu cho button
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Hình thức',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Số lượng giải đấu
                      Container(
                        color: Colors.grey[300],
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${filteredGDData.length} Giải đấu',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.grey,
                                  side: const BorderSide(
                                      color: Colors
                                          .grey), // Màu sắc và độ dày của viền
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Độ cong góc viền
                                  ),
                                  minimumSize: Size(buttonWidth_2,
                                      0), // Đặt chiều rộng tối thiểu cho button
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Sắp xếp',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Danh sách giải đấu
                Expanded(
                  flex: 14,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.green,
                        )) // Widget loading
                      : ListView.builder(
                          itemCount: filteredGDData.length,
                          itemBuilder: (context, index) {
                            final giaiDau = filteredGDData[index];
                            final hinhThucDauId = giaiDau.hinh_thuc_dau_id;
                            double line =
                                filteredGDData[index].so_tran_da_dau! /
                                    filteredGDData[index].so_vong_dau!;
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
                                                  filteredGDData[index]
                                                      .so_tran_da_dau as int,
                                                  filteredGDData[index]
                                                      .so_vong_dau as int),
                                              const SizedBox(height: 10),
                                              Text(
                                                filteredGDData[index]
                                                    .ten_giai_dau
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                '${filteredGDData[index].so_tran_da_dau}/${filteredGDData[index].so_vong_dau} trận',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 3),
                                              LinearProgressIndicator(
                                                value: line,
                                                minHeight: 5,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                valueColor: (line < 1)
                                                    ? const AlwaysStoppedAnimation<
                                                        Color>(Colors.green)
                                                    : AlwaysStoppedAnimation<
                                                            Color?>(
                                                        Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                tenHinhThuc.toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                filteredGDData[index]
                                                    .ban_to_chuc
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                filteredGDData[index]
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
                                    title:
                                        Text(giaiDau.ten_giai_dau.toString()),
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
              ],
            ),
            // Tab Giải tham gia
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Bạn chưa tham gia giải đấu nào',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Navigator
  void onSearch() {
    bool showRedDot = false;
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Search()),
      );
    });
  }

  void onNotification() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Notification_Scren()),
      );
    });
  }

  Widget tinhTrangGiaiDau(int a, int b) {
    bool isActive = (a == 0) ? true : false;

    void setActiveButton(int a, int b) async {
      bool isActiveButton = (a > b) ? true : false;
      print(isActiveButton);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('activeButton', isActiveButton);
      // Lưu giá trị isActive vào SharedPreferences
    }

    void setIsActiveToSharedPreferences(bool value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (a > b) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool activeButton = false;
        prefs.setBool('activeDangKy', activeButton);
      }

      await prefs.setBool('isActive', value);
    }

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
