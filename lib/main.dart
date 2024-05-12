// ignore_for_file: depend_on_referenced_packages

import 'package:ckc_league/menu_bottom/my_team/DoiBong/my_team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'account/login_screen.dart';

void main() {
  initializeDateFormatting('vi', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Tiếng Việt
        Locale('en', 'US'), // Tiếng Anh
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login_Screen(),
        '/myteam': (context) => My_team(),
      },
    );
  }
}
