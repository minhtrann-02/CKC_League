// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'admin_match-result.dart';

class MatchSummary extends StatefulWidget {
  const MatchSummary({super.key});

  @override
  State<MatchSummary> createState() => _MatchSummaryState();
}

enum SingingCharacter { goal, red, yellow }

class _MatchSummaryState extends State<MatchSummary> {
  int idGiaiDau = 0;
  int idCauThu = 0;
  int idDoiBong = 0;
  bool success = false;
  bool loadingTenCT = false;
  bool errorTime = false;
  String access_token = '';
  String ten_doi1 = '';
  String ten_doi2 = '';
  String idTranDau = '';
  String loaiThongTin = 'Bàn thắng';
  String selectedDoiBong = '-- chọn --';
  String selectedCauThu = '';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  final String apiPlayer = 'http://10.0.2.2:8000/api/auth/players';
  final String apiTomTat = 'http://10.0.2.2:8000/api/auth/ChiTietTomTat';
  final String apiPlayerInLeague =
      'http://10.0.2.2:8000/api/auth/CauThuTrongGiaiDau';
  List<String> listTenCT = ['-- chọn --'];
  List<String> soAoCT = [];
  List<dynamic> resultsPlayer = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  var time_controller = TextEditingController();
  SingingCharacter? _character = SingingCharacter.goal;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    idGiaiDau = prefs.getInt('id') ?? 0;
    idTranDau = prefs.getString('idTranDau') ?? '';
    setState(() {
      ten_doi1 = prefs.getString('ten_doi1') ?? '';
      ten_doi2 = prefs.getString('ten_doi2') ?? '';
    });
  }

  Future<List<String>?> getListCauThu(String tenDoiBong) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseFootBall =
        await http.get(Uri.parse(apiDoiBong), headers: headers);
    final responsePlayer =
        await http.get(Uri.parse(apiPlayer), headers: headers);
    final responsePlayerInLeague =
        await http.get(Uri.parse(apiPlayerInLeague), headers: headers);
    if (responseFootBall.statusCode == 200 &&
        responsePlayer.statusCode == 200 &&
        responsePlayerInLeague.statusCode == 200) {
      final jsonDataFootball = json.decode(responseFootBall.body);
      final jsonDataPlayer = json.decode(responsePlayer.body);
      final jsonDataPlayerInLeague = json.decode(responsePlayerInLeague.body);
      List<dynamic> resultsFootball = jsonDataFootball['data'];
      resultsPlayer = jsonDataPlayer['data'];
      List<dynamic> resultsPlayerInLeague = jsonDataPlayerInLeague['data'];

      int idDoiBong = resultsFootball.firstWhere(
          (item) => tenDoiBong == item['ten_doi_bong'],
          orElse: () => null)?['id'];

      List<int> idPlayerInLeague = resultsPlayerInLeague
          .where((item) => idGiaiDau == item['id_giai_dau'])
          .map((item) => item['id_cau_thu'] as int)
          .toList();

      List<String> listSoAoCT = resultsPlayer
          .where((item) =>
              idDoiBong == item['doi_bong_id'] &&
              idPlayerInLeague.contains(item['id']))
          .map((item) => item['so_ao'].toString())
          .toList();

      setState(() {
        // listTenCT.addAll(listTenCauThu);
        selectedCauThu = listSoAoCT[0];
        soAoCT.addAll(listSoAoCT);
        loadingTenCT = true;
        print('Lấy danh sách cầu thủ thành công!');
      });
      return listTenCT;
    } else {
      print('Lỗi cầu thủ: ${responsePlayer.statusCode}');
      print('Lỗi đội bóng: ${responseFootBall.statusCode}');
      print('Lỗi cầu thủ trong giải đấu: ${responsePlayerInLeague.statusCode}');
      return null;
    }
  }

  Future<int?> getIDCauThu(String soAo) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responsePlayer =
        await http.get(Uri.parse(apiPlayer), headers: headers);
    if (responsePlayer.statusCode == 200) {
      final jsonDataPlayer = json.decode(responsePlayer.body);
      List<dynamic> resultsPlayer = jsonDataPlayer['data'];

      int idCT = resultsPlayer.firstWhere(
          (item) =>
              int.parse(soAo) == item['so_ao'] &&
              idDoiBong == item['doi_bong_id'],
          orElse: () => null)?['id'];

      return idCauThu = idCT;
    } else {
      print('Lỗi getIDCauThu: ${responsePlayer.statusCode}');
      return null;
    }
  }

  Future<int?> getIDDoiBong(String tenDoiBong) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseFootball =
        await http.get(Uri.parse(apiDoiBong), headers: headers);
    if (responseFootball.statusCode == 200) {
      final jsonDataFootball = json.decode(responseFootball.body);
      List<dynamic> resultsFootball = jsonDataFootball['data'];

      int idDT = resultsFootball.firstWhere(
          (item) => tenDoiBong == item['ten_doi_bong'],
          orElse: () => null)?['id'];

      return idDoiBong = idDT;
    } else {
      print('Lỗi getIDDoiBong: ${responseFootball.statusCode}');
      return null;
    }
  }

  String getTenTuSoAo(List<dynamic> data, String soAo) {
    String kq = data
        .where((item) =>
            soAo == item['so_ao'].toString() &&
            idDoiBong == item['doi_bong_id'])
        .map((item) => item['ten_cau_thu'])
        .toList()
        .join();
    return kq;
  }

  Future<void> postTomTat() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final body = {
      'loai_thong_tin': loaiThongTin,
      'giai_dau_id': idGiaiDau,
      'tran_dau_id': idTranDau,
      'doi_bong_id': idDoiBong,
      'cau_thu_id': idCauThu,
      'thoi_gian': time_controller.text,
    };
    print('loaiThongTin: $loaiThongTin');
    print('idGiaiDau: $idGiaiDau');
    print('idTranDau: $idTranDau');
    print('idDoiBong: $idDoiBong');
    print('idCauThu: $idCauThu');
    print('thoi_gian_CT: ${time_controller.text}');

    final responseTomTat = await http.post(Uri.parse(apiTomTat),
        body: jsonEncode(body), headers: headers);
    if (responseTomTat.statusCode == 201) {
      print('Thêm thông tin bàn thắng thành công!');
      showThongBao('Thêm thông tin thành công!', Colors.green);
      setState(() {
        success = true;
      });
    } else {
      print('Lỗi postTomTat: ${responseTomTat.statusCode}');
    }
  }

  Widget radio(SingingCharacter checkbox, String image, String loai) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Radio<SingingCharacter>(
            activeColor: Colors.green,
            value: checkbox,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                loaiThongTin = loai;
              });
            },
          ),
          Image.asset(
            image,
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        '$text:',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  void showThongBao(String text, Color color) {
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: const Text(
            'Thêm tóm tắt',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    radio(SingingCharacter.goal, 'images/theball.png',
                        'Bàn thắng'),
                    radio(SingingCharacter.yellow, 'images/yellow_card.png',
                        'Thẻ vàng'),
                    radio(
                        SingingCharacter.red, 'images/red_card.png', 'Thẻ đỏ'),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.green[300],
                  child: const Text(
                    'THÔNG TIN',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                text('Đội bóng'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDoiBong,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedDoiBong = newValue!;
                                if (selectedDoiBong == '-- chọn --') {
                                } else {
                                  getIDDoiBong(selectedDoiBong);
                                }
                              });
                            },
                            items: [
                              const DropdownMenuItem<String>(
                                value: '-- chọn --',
                                child: Text('-- chọn --'),
                              ),
                              DropdownMenuItem<String>(
                                value: ten_doi1,
                                child: Text(ten_doi1),
                                onTap: () async {
                                  await getListCauThu(ten_doi1);
                                  setState(() {
                                    listTenCT = listTenCT;
                                    soAoCT = soAoCT;
                                  });
                                },
                              ),
                              DropdownMenuItem<String>(
                                value: ten_doi2,
                                child: Text(ten_doi2),
                                onTap: () async {
                                  await getListCauThu(ten_doi2);
                                  setState(() {
                                    listTenCT = listTenCT;
                                    soAoCT = soAoCT;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                (loadingTenCT) ? text('Cầu thủ') : Container(),
                (loadingTenCT)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCauThu,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCauThu = newValue!;
                                      getIDCauThu(selectedCauThu);
                                    });
                                  },
                                  items: soAoCT.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          getTenTuSoAo(resultsPlayer, value)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                text('Thời gian (phút)'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: time_controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Thời gian (1-150 phút)',
                      errorText: errorTime
                          ? 'Vui lòng nhập số phút theo quy định!'
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (value) {
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue != null &&
                          (parsedValue < 1 || parsedValue > 150)) {
                        setState(() {
                          errorTime = true;
                        });
                      } else {
                        setState(() {
                          errorTime = false;
                        });
                      }
                    },
                    onTap: () {
                      if (time_controller.text.isEmpty) {
                        setState(() {
                          errorTime = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: FractionallySizedBox(
            widthFactor: 0.99,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (time_controller.text.isEmpty ||
                      selectedDoiBong == '-- chọn --' ||
                      selectedCauThu == '-- chọn --') {
                    showThongBao('Vui lòng nhập đầy đủ thông tin!', Colors.red);
                  } else {
                    await postTomTat();
                    if (success == true) {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MatchResult()),
                        );
                      });
                    } else {
                      showThongBao('Thêm không thành công!', Colors.red);
                    }
                  }
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
        ),
      ),
    );
  }
}
