// ignore_for_file: depend_on_referenced_packages, unused_import, unused_field, duplicate_import, unused_local_variable
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ckc_league/Object_API/object_api.dart';
import 'package:ckc_league/account/login_screen.dart';
import 'package:ckc_league/admin/add_user.dart';
import 'package:ckc_league/admin/admin_info.dart';
import 'package:ckc_league/admin/camera.dart';
import 'package:ckc_league/admin/leagues/admin_leagues-list.dart';
import 'package:ckc_league/admin/list_form.dart';
import 'package:ckc_league/admin/list_referee.dart';
import 'package:ckc_league/admin/list_team.dart';
import 'package:ckc_league/admin/list_user.dart';
import 'package:ckc_league/admin/rank_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen_Admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreen_Admin_State();
}

class MainScreen_Admin_State extends State<MainScreen_Admin> {
  bool showBottomSheet = false;
  String? hoten = '';
  String email = '';
  String lop = '';
  String loaitaikhoan = '';
  String sdt = '';
  Image? selectedImage;
  String avatarPath = '';
  int id = 0;
  bool _isLoggedIn = false;
  File? _image;
  String access_token = '';

  Future<void> logoutToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/logout');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'token': access_token});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Logout thành công');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<String> saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/avatar.jpg';

    await imageFile.copy(imagePath);

    return imagePath;
  }

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final imagePath = imageFile.path;
      print('Đường dẫn ảnh: $imagePath');
      // Gọi hàm updateAvatar để cập nhật avatar với đường dẫn mới
      await updateAvatar(id, imagePath);
    }
  }

  void logout(BuildContext context) {
    // Thực hiện các thao tác cần thiết để đăng xuất, ví dụ như xóa thông tin đăng nhập, xóa token, vv.

    // Điều hướng người dùng đến màn hình đăng nhập và xóa hết các màn hình trước đó trong stack
    logoutToken();
    Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) =>
            false); // Thay thế '/login' bằng tên đúng của màn hình đăng nhập trong ứng dụng của bạn
  }

  Future<void> getHoten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hoten = prefs.getString('hoten') ?? '';
    id = prefs.getInt('ID') ?? 0;
    sdt = prefs.getString('sdt') ?? '';
    email = prefs.getString('email') ?? '';
    lop = prefs.getString('lop') ?? '';
    loaitaikhoan = prefs.getString('loaiTaiKhoan') ?? '';
    access_token = prefs.getString('access_token') ?? '';
    setState(() {});
  }

  Future<List<Data>> getUserData(int id) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token',
    };
    final String url = 'http://10.0.2.2:8000/api/auth/Login';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData != null &&
          jsonData['status'] == true &&
          jsonData['data'] is List) {
        final dataList =
            (jsonData['data'] as List).map((x) => Data.fromJson(x)).toList();
        return dataList;
      } else {
        throw Exception('Lỗi khi lấy dữ liệu người dùng từ API');
      }
    } else {
      throw Exception('Lỗi khi lấy dữ liệu người dùng từ API');
    }
  }

  void printUserData(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getInt('id') ?? 0;
      final userDataList = await getUserData(id);
      final filteredData = userDataList.where((data) => data.id == id).toList();

      if (filteredData.isNotEmpty) {
        final userData = filteredData[0];
      } else {
        print('Không có dữ liệu người dùng có ID $id');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
    }
  }

  Future<void> updateAvatar(int id, String avatarPath) async {
    final url = 'http://10.0.2.2:8000/api/auth/Login/$id';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token',
    };

    final request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);
    final userData = await getUserData(id);
    final file = File(avatarPath);
    final imageData = await file.readAsBytes();
    final filePart = http.MultipartFile.fromBytes(
      'avatar',
      imageData,
      filename: path.basename(file.path),
      contentType: MediaType('image', 'png'),
    );
    request.files.add(filePart);

// Add other data to the request body
    request.fields.addAll({
      'email': userData[0].email ?? '',
      'matkhau': userData[0].matkhau ?? '',
      'hoten': userData[0].hoten ?? '',
      'sdt': userData[0].sdt.toString(),
      'loai_tai_khoan': userData[0].loaiTaiKhoan ?? '',
      'lop': userData[0].lop ?? '',
    });
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Cập nhật thành công
      print('Cập nhật avatar thành công');
      print('Response: $responseString');
    } else {
      // Xử lý lỗi nếu có
      print('Lỗi khi cập nhật avatar: ${response.statusCode}');
      print('Response: $responseString');
    }
  }

  void fetchData() async {
    final String url = 'http://10.0.2.2:8000/api/auth/Login';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<Data> dataList =
          (responseData['data'] as List).map((x) => Data.fromJson(x)).toList();

      // Lấy giá trị hoten từ đối tượng đầu tiên trong danh sách dataList
      hoten = dataList[0].hoten!;

      setState(() {
        // Cập nhật UI khi có dữ liệu
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getHoten();
    printUserData(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFA011129),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                    //  padding: EdgeInsets.only(top:10),
                    height: 100,
                    // color: Color.fromARGB(255, 158, 136, 121),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.black,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : AssetImage('images/avt_admin.png')
                                      as ImageProvider<Object>?,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.black),
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
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0),
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
                                                child: Row(
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
                                                onPressed: () => _pickImage(
                                                    ImageSource.camera)
                                                //                         Navigator.push(
                                                // context,
                                                // MaterialPageRoute(
                                                //     builder: (context) => ImagePickerExample()));

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
                                              child: Row(
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
                                              onPressed: () => _pickImage(
                                                  ImageSource.gallery),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                               foregroundColor: Colors.white, backgroundColor: Colors.blueGrey[
                                                    800],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0), // chỉ định bán kính bo tròn
                                                ),
                                              ),
                                              child: Row(
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
                        ),
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(hoten ?? '',
                                style: TextStyle(
                                    fontFamily: 'Labrada',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            // Text(email ??'',
                            //     style: TextStyle(
                            //         fontFamily: 'Labrada',
                            //         color: Colors.white)),
                          ],
                        ))
                      ],
                    )),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.account_circle_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Thông tin cá nhân',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'BodoniModa')),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Admin_Info()));
                },
              ),
              
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Cài đặt',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'BodoniModa')),
                  ],
                ),
                onTap: () {
                  // Do something
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Đăng xuất',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'BodoniModa')),
                  ],
                ),
                onTap: () async {
                  setState(() {
                    _isLoggedIn = false;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              Icons.logout, // Icon logout
                              color: Colors.red,
                              size: 24,
                            ),
                            SizedBox(width: 8), // Khoảng cách giữa Icon và Text
                            Text(
                              'Đăng xuất',
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
                              'Bạn có chắc chắn muốn đăng xuất?',
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
                                    'Có',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () => logout(context),
                                  style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  child: Text(
                                    'Không',
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
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Trang chủ'),
        centerTitle: true,
        backgroundColor: const Color(0xFA011129),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: CarouselSlider.builder(
                itemCount: newsTitles.length,
                options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return GestureDetector(
                    onTap: () {
                      _launchURL(newsUrls[index]);
                    },
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.grey,
                          child: Image.asset(
                            newsImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black54,
                            child: Text(
                              newsTitles[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Danh Mục',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => List_User()),
                );
              },
              child: Container(
                height: 400,
                child: GridView.count(
                  crossAxisCount: 2,
                  // scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 80,
                      height: 130,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: Color(0xFA011129),
                                height: 100,
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: WaveClipper(),
                            child: Container(
                              color: Color(0xFA011129),
                              height: 80,
                              alignment: Alignment.center,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.view_list_sharp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 0,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Danh sách tài khoản',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PlayfairDisplay'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => List_Team()),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 130,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: Color(0xFA011129),
                                  height: 100,
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: Color(0xFA011129),
                                height: 80,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.sports_soccer,
                                    color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Danh sách đội bóng',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlayfairDisplay'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        // Xử lý sự kiện khi Container được nhấp vào
                        // Chuyển đến trang khác
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => List_Referee()),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 130,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: Color(0xFA011129),
                                  height: 100,
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: Color(0xFA011129),
                                height: 80,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.perm_identity,
                                    color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Danh sách trọng tài',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PlayfairDisplay',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaguesList()),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 130,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: Color(0xFA011129),
                                  height: 100,
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: Color(0xFA011129),
                                height: 80,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.emoji_events_rounded,
                                    color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Danh sách giải đấu',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlayfairDisplay'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => List_Form()),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 130,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: Color(0xFA011129),
                                  height: 100,
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: Color(0xFA011129),
                                height: 80,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.analytics_outlined,
                                    color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Hình thức thi đấu',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlayfairDisplay'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    // Container(
                    //   width: 80,
                    //   height: 130,
                    //   margin: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black, width: 1),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Stack(
                    //     children: [
                    //       Opacity(
                    //         opacity: 0.5,
                    //         child: ClipPath(
                    //           clipper: WaveClipper(),
                    //           child: Container(
                    //             color: Color(0xFA011129),
                    //             height: 100,
                    //           ),
                    //         ),
                    //       ),
                    //       ClipPath(
                    //         clipper: WaveClipper(),
                    //         child: Container(
                    //           color: Color(0xFA011129),
                    //           height: 80,
                    //           alignment: Alignment.center,
                    //         ),
                    //       ),
                    //       Positioned(
                    //         top: 10,
                    //         left: 10,
                    //         child: Container(
                    //           width: 50,
                    //           height: 50,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Colors.white,
                    //           ),
                    //           child: Icon(
                    //             Icons.view_list_sharp,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: 20,
                    //         right: 0,
                    //         left: 10,
                    //         child: Container(
                    //           padding: EdgeInsets.all(8),
                    //           child: Text(
                    //             'Danh mục tài khoản',
                    //             style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontFamily: 'PlayfairDisplay'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Add more Container widgets for other items in the GridView
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<String> newsUrls = [
    'https://vnexpress.net/the-thao',
    'https://www.24h.com.vn/bong-da-c48.html',
    'https://vietnamnet.vn/the-thao/bong-da-quoc-te',
    'https://thethao247.vn/world-cup/457-dan-em-than-thiet-len-tieng-cho-rang-messi-van-co-the-thi-dau-world-cup-2026-d290011.html',
  ];

  final List<String> newsTitles = [
    'Yaya Toure: "Barca thế hệ 2009 mạnh hơn Man City"',
    'Trực tiếp bóng đá nữ Việt Nam - New Zealand: "Thuốc thử" quan trọng, chờ gây sốc chủ nhà',
    'Mbappe được yêu cầu rời PSG, lộ sự thật phũ phàng',
    '"Đàn em thân thiết" lên tiếng, cho rằng Messi vẫn có thể thi đấu World Cup 2026',
  ];

  final List<String> newsImages = [
    'images/banner.png',
    'images/banner1.jpg',
    'images/banner3.jpg',
    'images/banner4.jpg',
  ];
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = new Path();
    // path.lineTo(0, size.height);
    // var firstStart = Offset(size.width/5,size.height);
    // var firstEnd = Offset(size.width/2.25, size.height-50.0);
    // path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    path.lineTo(0, size.height);
    var secondStart = Offset(size.width - (size.width / 5), size.height - 105);
    var secondEnd = Offset(size.width, size.height);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
