// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:ckc_league/menu_bottom/leagues/schedule/match-details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_match-summary.dart';
import 'package:http/http.dart' as http;

class MatchResult extends StatefulWidget {
  const MatchResult({super.key});

  @override
  State<MatchResult> createState() => _MatchResultState();
}

class _MatchResultState extends State<MatchResult> {
  int? so_bang_dau = 0;
  int? so_doi_vao_vong_trong = 0;
  int? loai_san = 0;
  int? hinh_thuc_dau_id = 0;
  int? idGiaiDau = 0;
  int? so_vong_dau = 0;
  int? so_tran_da_dau = 0;
  int? so_luong_doi_bong = 0;
  int? doi_bong_1_id = 0;
  int? doi_bong_2_id = 0;
  int ti_so_doi_1 = 0;
  int ti_so_doi_2 = 0;
  int idDoiBong1 = 0;
  int idDoiBong2 = 0;
  bool hoanThanh = false;
  bool kiemTraLuu = false;
  String idLichTD = '';
  String idTranDau = '';
  String access_token = '';
  String ten_doi1 = '';
  String ten_doi2 = '';
  String logo_doi1 = 'images/logo3.png';
  String logo_doi2 = 'images/logo3.png';
  String? ten_giai_dau = '';
  String? tenHinhThuc = '';
  String? ban_to_chuc = '';
  String? san_dau = '';
  String? thoi_gian = '';
  String? dia_diem = '';
  String? ngay_dien_ra = '';
  String? ma_tran_dau = '';
  String? ngay_bat_dau = '';
  String? ngay_ket_thuc = '';
  List<String> listTrangThai = [];
  List<String> listThongTin = [];
  List<String> listTenDoiBong = [];
  List<String> listTenCauThu = [];
  List<String> listThoiGian = [];
  List<String> listSoAo = [];
  List<String> tongSoTheVang1 = [];
  List<String> tongSoTheVang2 = [];
  List<String> tongSoTheDo1 = [];
  List<String> tongSoTheDo2 = [];
  List<String> listIDTomTat = [];
  List<dynamic> resultsPlayerInLeague = [];
  List<dynamic> resultsTomTat = [];
  final String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau';
  final String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD';
  final String apiTomTat = 'http://10.0.2.2:8000/api/auth/ChiTietTomTat';
  final String apiDoiBong = 'http://10.0.2.2:8000/api/auth/football';
  final String apiPlayer = 'http://10.0.2.2:8000/api/auth/players';
  final String apiDBTrongGD =
      'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau1';
  final String apiPlayerInLeague =
      'http://10.0.2.2:8000/api/auth/CauThuTrongGiaiDau';
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getToken();
    await getIDDoiBong(ten_doi1, ten_doi2);
    await getTiSo(idDoiBong1, idDoiBong2);
    await getDataPlayerInLeague();
    await getDataTomTat();
  }

  Future<void> getDataPlayerInLeague() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responsePlayerInLeague =
        await http.get(Uri.parse(apiPlayerInLeague), headers: headers);
    if (responsePlayerInLeague.statusCode == 200) {
      final jsonDataPlayerInLeague = json.decode(responsePlayerInLeague.body);
      resultsPlayerInLeague = jsonDataPlayerInLeague['data'];
    } else {
      print('Lỗi getListCauThu: ${responsePlayerInLeague.statusCode}');
    }
  }

  Future<void> getDataTomTat() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseTomTat =
        await http.get(Uri.parse(apiTomTat), headers: headers);
    if (responseTomTat.statusCode == 200) {
      final jsonDataTomTat = json.decode(responseTomTat.body);
      resultsTomTat = jsonDataTomTat['data'];
    } else {
      print('Lỗi table Tóm tắt: ${responseTomTat.statusCode}');
    }
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    access_token = prefs.getString('accessToken') ?? '';
    // Table TranDau
    idTranDau = prefs.getString('idTranDau') ?? '';
    // Table GiaiDau
    idGiaiDau = prefs.getInt('id');
    ten_giai_dau = prefs.getString('ten_giai_dau');
    hinh_thuc_dau_id = prefs.getInt('hinh_thuc_dau_id');
    ban_to_chuc = prefs.getString('ban_to_chuc');
    san_dau = prefs.getString('san_dau');
    so_vong_dau = prefs.getInt('so_vong_dau');
    so_tran_da_dau = prefs.getInt('so_tran_da_dau');
    so_luong_doi_bong = prefs.getInt('so_luong_doi_bong');
    ngay_bat_dau = prefs.getString('ngay_bat_dau');
    ngay_ket_thuc = prefs.getString('ngay_ket_thuc');
    so_bang_dau = prefs.getInt('so_bang_dau');
    so_doi_vao_vong_trong = prefs.getInt('so_doi_vao_vong_trong');
    loai_san = prefs.getInt('loai_san');
    hinh_thuc_dau_id = prefs.getInt('hinh_thuc_dau_id');
    // Table LichTD
    idLichTD = prefs.getString('idLichTD') ?? '';
    ma_tran_dau = prefs.getString('ma_tran_dau') ?? '';
    doi_bong_1_id = prefs.getInt('doi_bong_1_id') ?? 0;
    doi_bong_2_id = prefs.getInt('doi_bong_2_id') ?? 0;
    thoi_gian = prefs.getString('thoi_gian') ?? '';
    ngay_dien_ra = prefs.getString('ngay_dien_ra') ?? '';
    dia_diem = prefs.getString('dia_diem') ?? '';

    setState(() {
      ten_doi1 = prefs.getString('ten_doi1') ?? '';
      ten_doi2 = prefs.getString('ten_doi2') ?? '';
      logo_doi1 = prefs.getString('logo_doi1') ?? '';
      logo_doi2 = prefs.getString('logo_doi2') ?? '';
    });
  }

  Future<int?> getIDDoiBong(String tenDoiBong1, String tenDoiBong2) async {
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

      int idDB1 = resultsFootball.firstWhere(
          (item) => tenDoiBong1 == item['ten_doi_bong'],
          orElse: () => null)?['id'];
      int idDB2 = resultsFootball.firstWhere(
          (item) => tenDoiBong2 == item['ten_doi_bong'],
          orElse: () => null)?['id'];

      setState(() {
        idDoiBong1 = idDB1;
        idDoiBong2 = idDB2;
      });
    } else {
      print('Lỗi football: ${responseFootball.statusCode}');
      return null;
    }
    return null;
  }

  List<String> getTiSoTungDoi(List<dynamic> data, int doi) {
    List<String> tiSoDoi = data
        .where((item) =>
            'Bàn thắng' == item['loai_thong_tin'] &&
            idGiaiDau == item['giai_dau_id'] &&
            int.parse(idTranDau) == item['tran_dau_id'] &&
            doi == item['doi_bong_id'])
        .map((item) => item['id'].toString())
        .toList();
    return tiSoDoi;
  }

  List<String> getThongTin(List<dynamic> data, String tenTT) {
    List<String> tiSoDoi = data
        .where((item) =>
            idGiaiDau == item['giai_dau_id'] &&
            int.parse(idTranDau) == item['tran_dau_id'])
        .map((item) => item[tenTT].toString())
        .toList();
    return tiSoDoi;
  }

  Future<void> getTiSo(int idDoiBong1, int idDoiBong2) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responseTiSo = await http.get(Uri.parse(apiTomTat), headers: headers);
    if (responseTiSo.statusCode == 200) {
      final jsonDataTiSo = json.decode(responseTiSo.body);
      List<dynamic> resultsTiSo = jsonDataTiSo['data'];

      // Lấy thông tin tóm tắt
      List<int> listIDDoiBong = resultsTiSo
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'])
          .map((item) => item['doi_bong_id'] as int)
          .toList();
      await getTenDoiBongList(listIDDoiBong);

      List<int> listIDCauThu = resultsTiSo
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'])
          .map((item) => item['cau_thu_id'] as int)
          .toList();
      await getTenCauThuList(listIDCauThu);
      await getSoAoCauThuList(listIDCauThu);

      tongSoTheVang1 = resultsTiSo
          .where((item) =>
              'Thẻ vàng' == item['loai_thong_tin'] &&
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'] &&
              idDoiBong1 == item['doi_bong_id'])
          .map((item) => item['id'].toString())
          .toList();
      tongSoTheVang2 = resultsTiSo
          .where((item) =>
              'Thẻ vàng' == item['loai_thong_tin'] &&
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'] &&
              idDoiBong2 == item['doi_bong_id'])
          .map((item) => item['id'].toString())
          .toList();
      tongSoTheDo1 = resultsTiSo
          .where((item) =>
              'Thẻ đỏ' == item['loai_thong_tin'] &&
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'] &&
              idDoiBong1 == item['doi_bong_id'])
          .map((item) => item['id'].toString())
          .toList();
      tongSoTheDo2 = resultsTiSo
          .where((item) =>
              'Thẻ đỏ' == item['loai_thong_tin'] &&
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'] &&
              idDoiBong2 == item['doi_bong_id'])
          .map((item) => item['id'].toString())
          .toList();

      setState(() {
        listThongTin = getThongTin(resultsTiSo, 'loai_thong_tin');
        listThoiGian = getThongTin(resultsTiSo, 'thoi_gian');
        listTenDoiBong = listTenDoiBong;
        listTenCauThu = listTenCauThu;
        listSoAo = listSoAo;
        tongSoTheVang1 = tongSoTheVang1;
        tongSoTheVang2 = tongSoTheVang2;
        tongSoTheDo1 = tongSoTheDo1;
        tongSoTheDo2 = tongSoTheDo2;
      });
      // Lấy tỉ số
      List<String> tiSoDoi1 = getTiSoTungDoi(resultsTiSo, idDoiBong1);
      List<String> tiSoDoi2 = getTiSoTungDoi(resultsTiSo, idDoiBong2);

      setState(() {
        ti_so_doi_1 = tiSoDoi1.length;
        ti_so_doi_2 = tiSoDoi2.length;
      });
    } else {
      print('Lỗi football: ${responseTiSo.statusCode}');
      return;
    }
  }

  Future<List<String>> getTenDoiBongList(List<int> doiBongIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiDoiBong), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = doiBongIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['ten_doi_bong'].toString();
      }
      return '';
    }).toList();
    return listTenDoiBong = IDDoiBongList;
  }

  Future<List<String>> getTenCauThuList(List<int> cauThuIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiPlayer), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = cauThuIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['ten_cau_thu'].toString();
      }
      return '';
    }).toList();
    return listTenCauThu = IDDoiBongList;
  }

  Future<List<String>> getSoAoCauThuList(List<int> cauThuIDs) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token',
    };
    final response = await http.get(Uri.parse(apiPlayer), headers: headers);

    final jsonData = json.decode(response.body);
    List<dynamic> doiBongData = jsonData['data'];
    List<String> IDDoiBongList = cauThuIDs.map((doiBong) {
      int index = doiBongData.indexWhere((item) => item['id'] == doiBong);
      if (index >= 0) {
        return doiBongData[index]['so_ao'].toString();
      }
      return '';
    }).toList();
    return listSoAo = IDDoiBongList;
  }

  Future<List<int>?> getIDPlayerInLeague(int idDoiBong) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };
    final responsePlayer =
        await http.get(Uri.parse(apiPlayer), headers: headers);
    final responsePlayerInLeague =
        await http.get(Uri.parse(apiPlayerInLeague), headers: headers);
    if (responsePlayer.statusCode == 200 &&
        responsePlayerInLeague.statusCode == 200) {
      final jsonDataPlayer = json.decode(responsePlayer.body);
      final jsonDataPlayerInLeague = json.decode(responsePlayerInLeague.body);
      List<dynamic> resultsPlayer = jsonDataPlayer['data'];
      List<dynamic> resultsPlayerInLeague = jsonDataPlayerInLeague['data'];

      List<int> idPlayerInLeague = resultsPlayerInLeague
          .where((item) => idGiaiDau == item['id_giai_dau'])
          .map((item) => item['id_cau_thu'] as int)
          .toList();

      List<int> listIDCauThu = resultsPlayer
          .where((item) =>
              idDoiBong == item['doi_bong_id'] &&
              idPlayerInLeague.contains(item['id']))
          .map((item) => item['id'] as int)
          .toList();

      return listIDCauThu;
    } else {
      print('Lỗi getListCauThu: ${responsePlayer.statusCode}');
      return null;
    }
  }

  Future<void> updateDataTranDau() async {
    String apiTranDau = 'http://10.0.2.2:8000/api/auth/TranDau/$idTranDau';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    String ti_so = '$ti_so_doi_1-$ti_so_doi_2';

    final body = {
      'trong_tai_1_id': 0,
      'trong_tai_2_id': 0,
      'lich_thi_dau_id': int.parse(idLichTD),
      'ti_so': ti_so,
      'tong_so_the': 0,
      'so_the_vang': 0,
      'so_the_do': 0,
      'bu_gio': 0,
    };

    final response = await http.put(Uri.parse(apiTranDau),
        body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      updateDataLichTD();
      print('Cập nhật tỉ số thành công');
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<void> updateDataLichTD() async {
    String apiLichTD = 'http://10.0.2.2:8000/api/auth/LichTD/$idLichTD';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    final body = {
      'ma_tran_dau': ma_tran_dau,
      'doi_bong_1_id': doi_bong_1_id,
      'doi_bong_2_id': doi_bong_2_id,
      'giai_dau_id': idGiaiDau,
      'thoi_gian': thoi_gian,
      'ngay_dien_ra': ngay_dien_ra,
      'trang_thai_tran_dau': 1,
      'dia_diem': dia_diem,
    };

    final response = await http.put(Uri.parse(apiLichTD),
        body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      kiemTraLuu = true;
      print('Cập nhật trạng thái trận đấu thành công');
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<void> updateDataGiaiDau() async {
    String apiGiaiDau = 'http://10.0.2.2:8000/api/auth/GiaiDau/$idGiaiDau';
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    // Lấy dữ liệu từ LichTD
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonData = json.decode(responseLichTD.body);
      List<dynamic> resultsLichTD = jsonData['data'];
      listTrangThai = resultsLichTD
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              item['trang_thai_tran_dau'] == 1)
          .map((item) => item['trang_thai_tran_dau'].toString())
          .toList();
    } else {
      print('Lỗi: ${responseLichTD.statusCode}');
    }

    final body = {
      'ten_giai_dau': ten_giai_dau,
      'hinh_thuc_dau_id': hinh_thuc_dau_id,
      'ban_to_chuc': ban_to_chuc,
      'san_dau': san_dau,
      'ngay_bat_dau': ngay_bat_dau,
      'ngay_ket_thuc': ngay_ket_thuc,
      'so_luong_doi_bong': so_luong_doi_bong,
      'so_bang_dau': so_bang_dau,
      'so_doi_vao_vong_trong': so_doi_vao_vong_trong,
      'loai_san': loai_san,
      'so_vong_dau': so_vong_dau,
      'so_tran_da_dau': listTrangThai.length,
    };

    final response = await http.put(Uri.parse(apiGiaiDau),
        body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      print('Cập nhật số trận đã đấu thành công');
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  Future<void> updateDataPlayerInLeague(int idDoiBong) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    // Lấy danh sách ID cầu thủ của 1 đội bóng tham gia vào giải đấu
    List<int>? listIDPlayerInLeague = await getIDPlayerInLeague(idDoiBong);
    print('listIDPlayerInLeague trong 1 giải: $listIDPlayerInLeague');

    // Lấy dữ liệu cũ của table CauThuTrongGiaiDau
    List<int> listSoTranThamGia = [];
    listSoTranThamGia = resultsPlayerInLeague
        .where((item) =>
            listIDPlayerInLeague!.contains(item['id_cau_thu']) &&
            idGiaiDau == item['id_giai_dau'])
        .map((item) => item['so_tran_tham_gia'] as int)
        .toList();

    // Cập nhật bàn thắng - thẻ vàng - thẻ đỏ
    for (int i = 0; i < listIDPlayerInLeague!.length; i++) {
      String idPlayerInLeague = resultsPlayerInLeague
          .where((item) =>
              listIDPlayerInLeague[i] == item['id_cau_thu'] &&
              idGiaiDau == item['id_giai_dau'])
          .map((item) => item['id'])
          .toList()
          .join();
      String apiPlaterInLeague_update =
          'http://10.0.2.2:8000/api/auth/CauThuTrongGiaiDau/$idPlayerInLeague';
      int soBanThang =
          layThongTinGYR(resultsTomTat, listIDPlayerInLeague[i], 'Bàn thắng');
      int soTheVang =
          layThongTinGYR(resultsTomTat, listIDPlayerInLeague[i], 'Thẻ vàng');
      int soTheDo =
          layThongTinGYR(resultsTomTat, listIDPlayerInLeague[i], 'Thẻ đỏ');

      final body = {
        'id_cau_thu': listIDPlayerInLeague[i],
        'id_giai_dau': idGiaiDau,
        'so_tran_tham_gia': listSoTranThamGia[i] + 1,
        'so_ban_thang': soBanThang,
        'so_the_vang': soTheVang,
        'so_the_do': soTheDo,
      };

      final response = await http.put(Uri.parse(apiPlaterInLeague_update),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
      } else {
        print('Lỗi PlayerInLeague: ${response.statusCode}');
      }
    }
  }

  int tongSoTranThamGia(List<dynamic> data, int idCauThu) {
    int tongSoTran = 0;
    List<int> listSoTran = data
        .where((item) => idCauThu == item['id_cau_thu'])
        .map((item) => item['so_tran_tham_gia'] as int)
        .toList();
    for (int i = 0; i < listSoTran.length; i++) {
      tongSoTran += listSoTran[i];
    }
    return tongSoTran;
  }

  Future<void> updateDataPlayer(int idDoiBong) async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    // Lấy danh sách ID cầu thủ của 1 đội bóng tham gia vào giải đấu
    List<int>? listIDPlayerInLeague = await getIDPlayerInLeague(idDoiBong);
    print('listIDPlayerInLeague toàn giải: $listIDPlayerInLeague');

    // Lấy dữ liệu cũ trong bảng players
    List<String> tenCauThu = [];
    List<String> soAo = [];
    List<String> viTri = [];
    final responsePlayers =
        await http.get(Uri.parse(apiPlayer), headers: headers);
    if (responsePlayers.statusCode == 200) {
      final jsonDataPlayers = json.decode(responsePlayers.body);
      List<dynamic> resultsPlayers = jsonDataPlayers['data'];

      tenCauThu = resultsPlayers
          .where((item) => listIDPlayerInLeague!.contains(item['id']))
          .map((item) => item['ten_cau_thu'].toString())
          .toList();
      soAo = resultsPlayers
          .where((item) => listIDPlayerInLeague!.contains(item['id']))
          .map((item) => item['so_ao'].toString())
          .toList();
      viTri = resultsPlayers
          .where((item) => listIDPlayerInLeague!.contains(item['id']))
          .map((item) => item['vi_tri'].toString())
          .toList();
    } else {
      print('Lỗi lấy dữ liệu cũ Players: ${responsePlayers.statusCode}');
    }

    // Cập nhật bàn thắng - thẻ vàng - thẻ đỏ
    for (int i = 0; i < listIDPlayerInLeague!.length; i++) {
      String apiPlayer_update =
          'http://10.0.2.2:8000/api/auth/players/${listIDPlayerInLeague[i]}';
      int soBanThang = layThongTinGYRAll(
          resultsTomTat, listIDPlayerInLeague[i], 'Bàn thắng');
      int soTheVang =
          layThongTinGYRAll(resultsTomTat, listIDPlayerInLeague[i], 'Thẻ vàng');
      int soTheDo =
          layThongTinGYRAll(resultsTomTat, listIDPlayerInLeague[i], 'Thẻ đỏ');
      int tong =
          tongSoTranThamGia(resultsPlayerInLeague, listIDPlayerInLeague[i]);
      final body = {
        'doi_bong_id': idDoiBong,
        'ten_cau_thu': tenCauThu[i],
        'so_ao': soAo[i],
        'vi_tri': viTri[i],
        'so_tran_tham_gia': tong,
        'so_kien_tao': 0,
        'so_ban_thang': soBanThang,
        'so_the_vang': soTheVang,
        'so_the_do': soTheDo,
      };

      final response = await http.put(Uri.parse(apiPlayer_update),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        hoanThanh = true;
      } else {
        print('Lỗi Players: ${response.statusCode}');
      }
    }
  }

  int layThongTinGYR(List<dynamic> data, int idCauThu, String loai) {
    int KQ = 0;
    List<int> banThang = data
        .where((item) =>
            item['loai_thong_tin'] == loai &&
            idCauThu == item['cau_thu_id'] &&
            idGiaiDau == item['giai_dau_id'])
        .map((item) => item['id'] as int)
        .toList();
    KQ = banThang.length;
    return KQ;
  }

  int layThongTinGYRAll(List<dynamic> data, int idCauThu, String loai) {
    int KQ = 0;
    List<int> banThang = data
        .where((item) =>
            item['loai_thong_tin'] == loai && idCauThu == item['cau_thu_id'])
        .map((item) => item['id'] as int)
        .toList();
    KQ = banThang.length;
    return KQ;
  }

  String soLuong(List<dynamic> data, String loai, int idDoiBong) {
    String KQ = data
        .where((item) =>
            idGiaiDau == item['giai_dau_id'] &&
            idDoiBong == item['doi_bong_id'])
        .map((item) => item[loai])
        .toList()
        .join();
    return KQ;
  }

  Future<void> updateDataDBTrongGD(int IDDB) async {
    int soTranThang = 0;
    int soTranHoa = 0;
    int soTranThua = 0;
    int tongBanThang = 0;
    int tongBanThua = 0;
    int soTheVang = 0;
    int soTheDo = 0;
    int trangThai = 0;
    String idDBTrongGD = '';

    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    // Lấy dữ liệu từ DBTrongGD
    final responseDBTrongGD =
        await http.get(Uri.parse(apiDBTrongGD), headers: headers);
    if (responseDBTrongGD.statusCode == 200) {
      final jsonData = json.decode(responseDBTrongGD.body);
      List<dynamic> resultsDBTrongGD = jsonData['data'];

      idDBTrongGD = resultsDBTrongGD
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] && IDDB == item['doi_bong_id'])
          .map((item) => item['id'])
          .toList()
          .join();

      String sTT = soLuong(resultsDBTrongGD, 'so_tran_thang', IDDB);
      String sTH = soLuong(resultsDBTrongGD, 'so_tran_hoa', IDDB);
      String sTTh = soLuong(resultsDBTrongGD, 'so_tran_thua', IDDB);
      String tBT = soLuong(resultsDBTrongGD, 'tong_ban_thang', IDDB);
      String tBTh = soLuong(resultsDBTrongGD, 'tong_ban_thua', IDDB);
      String sTV = soLuong(resultsDBTrongGD, 'so_the_vang', IDDB);
      String sTD = soLuong(resultsDBTrongGD, 'so_the_vang', IDDB);
      setState(() {
        soTranThang = int.parse(sTT);
        soTranHoa = int.parse(sTH);
        soTranThua = int.parse(sTTh);
        tongBanThang = int.parse(tBT);
        tongBanThua = int.parse(tBTh);
        soTheVang = int.parse(sTV);
        soTheDo = int.parse(sTD);
      });
    } else {
      print('Lỗi: ${responseDBTrongGD.statusCode}');
    }
    String apiUpdateDBTrongGD =
        'http://10.0.2.2:8000/api/auth/DoiBongTrongGiaiDau/$idDBTrongGD';

    // Kiểm tra trạng thái trận đấu
    final responseLichTD =
        await http.get(Uri.parse(apiLichTD), headers: headers);
    if (responseLichTD.statusCode == 200) {
      final jsonData = json.decode(responseLichTD.body);
      List<dynamic> resultsLichTD = jsonData['data'];

      String kiemTra = resultsLichTD
          .where((item) => idLichTD == item['id'].toString())
          .map((item) => item['trang_thai_tran_dau'].toString())
          .toList()
          .join();
      trangThai = int.parse(kiemTra);
    } else {
      print('Lỗi Lịch thi đấu: ${responseLichTD.statusCode}');
    }

    // Tính tổng các số lượng
    if (IDDB == idDoiBong1) {
      if (trangThai == 0) {
        soTheVang += tongSoTheVang1.length;
        soTheDo += tongSoTheDo1.length;
        tongBanThang += ti_so_doi_1;
        tongBanThua += ti_so_doi_2;
        // Số trận T-H-B
        if (ti_so_doi_1 > ti_so_doi_2) {
          soTranThang += 1;
        }
        if (ti_so_doi_1 == ti_so_doi_2) {
          soTranHoa += 1;
        }
        if (ti_so_doi_1 < ti_so_doi_2) {
          soTranThua += 1;
        }
      } else {
        soTheVang = tongSoTheVang1.length;
        soTheDo = tongSoTheDo1.length;
        tongBanThang = ti_so_doi_1;
        tongBanThua = ti_so_doi_2;
        // Số trận T-H-B
        if (ti_so_doi_1 > ti_so_doi_2) {
          soTranThang = soTranThang;
        }
        if (ti_so_doi_1 == ti_so_doi_2) {
          soTranHoa = soTranHoa;
        }
        if (ti_so_doi_1 < ti_so_doi_2) {
          soTranThua = soTranThua;
        }
      }
    } else {
      if (trangThai == 0) {
        soTheVang += tongSoTheVang2.length;
        soTheDo += tongSoTheDo2.length;
        tongBanThang += ti_so_doi_2;
        tongBanThua += ti_so_doi_1;
        // Số trận T-H-B
        if (ti_so_doi_1 < ti_so_doi_2) {
          soTranThang += 1;
        }
        if (ti_so_doi_1 == ti_so_doi_2) {
          soTranHoa += 1;
        }
        if (ti_so_doi_1 > ti_so_doi_2) {
          soTranThua += 1;
        }
      } else {
        soTheVang = tongSoTheVang2.length;
        soTheDo = tongSoTheDo2.length;
        tongBanThang = ti_so_doi_2;
        tongBanThua = ti_so_doi_1;
        // Số trận T-H-B
        if (ti_so_doi_1 < ti_so_doi_2) {
          soTranThang = soTranThang;
        }
        if (ti_so_doi_1 == ti_so_doi_2) {
          soTranHoa = soTranHoa;
        }
        if (ti_so_doi_1 > ti_so_doi_2) {
          soTranThua = soTranThua;
        }
      }
    }

    final body = {
      'giai_dau_id': idGiaiDau,
      'doi_bong_id': IDDB,
      'bang_dau': 'null',
      'so_tran_thang': soTranThang,
      'so_tran_hoa': soTranHoa,
      'so_tran_thua': soTranThua,
      'tong_ban_thang': tongBanThang,
      'tong_ban_thua': tongBanThua,
      'so_the_vang': soTheVang,
      'so_the_do': soTheDo,
    };

    final response = await http.put(Uri.parse(apiUpdateDBTrongGD),
        body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      print('Cập nhật đội bóng trong giải đấu thành công');
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  }

  String? image(String tenLoai) {
    if (tenLoai == 'Bàn thắng') {
      return 'images/theball.png';
    }
    if (tenLoai == 'Thẻ đỏ') {
      return 'images/red_card.png';
    }
    if (tenLoai == 'Thẻ vàng') {
      return 'images/yellow_card.png';
    }
    return null;
  }

  Future<void> deleteTomTat() async {
    final headers = {
      'User-Agent': 'MyApp/1.0',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    };

    // Lấy danh sách ID tóm tắt của trận đấu
    final responseTomTat =
        await http.get(Uri.parse(apiTomTat), headers: headers);
    if (responseTomTat.statusCode == 200) {
      final jsonDataTomTat = json.decode(responseTomTat.body);
      List<dynamic> resultsTomTat = jsonDataTomTat['data'];

      listIDTomTat = resultsTomTat
          .where((item) =>
              idGiaiDau == item['giai_dau_id'] &&
              int.parse(idTranDau) == item['tran_dau_id'])
          .map((item) => item['id'].toString())
          .toList();
    } else {
      print('Lỗi: ${responseTomTat.statusCode}');
    }

    // Xóa danh sách tóm tắt
    for (int i = 0; i < listIDTomTat.length; i++) {
      String apiTomTatdel =
          'http://10.0.2.2:8000/api/auth/ChiTietTomTat/${listIDTomTat[i]}';
      final responseDelTomTat =
          await http.delete(Uri.parse(apiTomTatdel), headers: headers);
      if (responseDelTomTat.statusCode == 200) {
        print('Xóa ${i + 1} tóm tắt thành công!');
      } else {
        print('Lỗi: ${responseDelTomTat.statusCode}');
      }
    }
  }

  void showCanhBao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Bạn có chắc chắn thoát khi chưa lưu không?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        deleteTomTat();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MatchDetails_Screen()),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Có',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Không',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFA011129),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Kết quả trận đấu',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            if (kiemTraLuu == false) {
              showCanhBao();
            } else {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MatchDetails_Screen()),
                );
              });
            }
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      logo_doi1,
                      height: 70,
                      width: 70,
                    ),
                    Text(
                      ten_doi1,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Tỉ số',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            ti_so_doi_1.toString(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '-',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            ti_so_doi_2.toString(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image.asset(
                      logo_doi2,
                      height: 70,
                      width: 70,
                    ),
                    Text(
                      ten_doi2,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.green[300],
              child: const Text(
                'TÓM TẮT TRẬN ĐẤU',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: ListView.builder(
              itemCount: listThongTin.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        image(listThongTin[index])!,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listTenDoiBong[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${listSoAo[index]}. ${listTenCauThu[index]}  (${listThoiGian[index]}')",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.99,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MatchSummary()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade50),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                                color: Colors.green, width: 2)),
                      ),
                    ),
                    child: const Text(
                      'THÊM',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: FractionallySizedBox(
                widthFactor: 0.99,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await updateDataDBTrongGD(idDoiBong1);
                      await updateDataDBTrongGD(idDoiBong2);
                      await updateDataTranDau();
                      await updateDataGiaiDau();
                      await updateDataPlayerInLeague(idDoiBong1);
                      await updateDataPlayerInLeague(idDoiBong2);
                      updateDataPlayer(idDoiBong1);
                      updateDataPlayer(idDoiBong2);
                      if (hoanThanh == true) {
                        print('HOÀN THÀNH LƯU THÔNG TIN TRẬN ĐẤU!');
                      }
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MatchDetails_Screen()),
                        );
                      });
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
                      'LƯU',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
