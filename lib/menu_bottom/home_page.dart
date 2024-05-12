// ignore_for_file: camel_case_types, unused_import

import 'package:ckc_league/menu_bottom/leagues/leagues_screen.dart';
import 'package:ckc_league/menu_bottom/my_team/main_myteam.dart';
import 'package:ckc_league/menu_bottom/profile/profile_screen.dart';
import 'package:ckc_league/menu_bottom/tourament/tourament_screen.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'my_team/DoiBong/add_team.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<StatefulWidget> createState() => Home_Page_State();
}

class Home_Page_State extends State<Home_Page> {
  int _selectedIndex = 0;
  final Widget _home = const Home();
  final Widget _tourament = const Leagues_Screen();
  final Widget _myteam =  My_team();
  final Widget _profile = const Profile_Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Giải đấu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: 'MyTeam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(color: Colors.black54),
        unselectedItemColor: Colors.black54,
        onTap: onTapHandler,
      ),
    );
  }

  void onTapHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getBody() {
    if (_selectedIndex == 0) {
      return _home;
    } else if (_selectedIndex == 1) {
      return _tourament;
    } else if (_selectedIndex == 2) {
      return _myteam;
    } else {
      return _profile;
    }
  }
}
