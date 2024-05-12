// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'configuaration/admin_group-stage.dart';
import 'configuaration/admin_knockout.dart';
import 'configuaration/admin_round-robin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompetitionForm_Screen extends StatefulWidget {
  const CompetitionForm_Screen({super.key});

  @override
  State<CompetitionForm_Screen> createState() => _CompetitionForm_ScreenState();
}

enum SingingCharacter { ht1, ht2, ht3 }

class _CompetitionForm_ScreenState extends State<CompetitionForm_Screen> {
  String? selectedValue;
  SingingCharacter? _character = SingingCharacter.ht1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey[800],
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Hình thức thi đấu'),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: FractionallySizedBox(
          widthFactor: 0.99,
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: onSelectedRadio,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 105,
              padding: const EdgeInsets.only(top: 15, bottom: 10, right: 10),
              child: Row(
                children: [
                  Radio<SingingCharacter>(
                    activeColor: Colors.green,
                    value: SingingCharacter.ht1,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  Image.asset(
                    'images/chia_bang_dau.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chia bảng đấu',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Giai đoạn 1: Chia bảng đấu và thi đấu vòng tròn',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Giai đoạn 2: Đấu loại trực tiếp',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              height: 105,
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
              child: Row(
                children: [
                  Radio<SingingCharacter>(
                    activeColor: Colors.green,
                    value: SingingCharacter.ht2,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  Image.asset(
                    'images/loai_truc_tiep.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loại trực tiếp',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Đội thua sẽ bị loại khỏi giải ngay lập tức. Đội còn lại sẽ được vào vòng trong.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              height: 105,
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
              child: Row(
                children: [
                  Radio<SingingCharacter>(
                    activeColor: Colors.green,
                    value: SingingCharacter.ht3,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  Image.asset(
                    'images/dau_vong_tron.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đấu vòng tròn',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mỗi đội sẽ lần lượt thi đấu với tất cả những đội khác',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSelectedRadio() async {
    if (_character == SingingCharacter.ht1) {
      // Chia bảng đấu
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hinh_thuc_dau_id', 1);
      print('Hình thức đấu: 1');
      // Chuyển màn hình
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GroupStage_Screen()),
      );
    } else if (_character == SingingCharacter.ht2) {
      // Loại trực tiếp
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hinh_thuc_dau_id', 2);
      print('Hình thức đấu: 2');
      // Chuyển màn hình
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KnockOut_Screen()),
      );
    } else {
      // Đấu vòng tròn
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hinh_thuc_dau_id', 3);
      print('Hình thức đấu: 3');
      // Chuyển màn hình
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RoundRobin_Screen()),
      );
    }
  }
}
