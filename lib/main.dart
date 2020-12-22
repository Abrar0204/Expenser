import 'package:Expenser/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'loginScreen.dart';
import 'tabContainer.dart';

void main() {
  runApp(MyApp());
}
// --oxford-blue: #18243c; primary
// --heliotrope-gray: #a39ba8;
// --light-steel-blue: #b8c5d6;
// --alice-blue: #edf5fc;
// --prussian-blue: #2c3d5c; accent

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final primaryColor = Color(0xFF18243c); //#18243c
  final accentColor = Color(0xFF2C3D5C); //#2c3d5c
  final textColor = Color(0xFFEDF5FC); //#edf5fc
  final buttonColor = Color(0xFF6A738E); //#6A738E
  final subtitleColor = Color(0xFFA39BA8); //#A39BA8
  final errorColor = Color(0xFFDC3545); //#DC3545
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
        accentColor: accentColor,
        primaryColor: primaryColor,
        primaryColorLight: textColor,
        splashColor: accentColor,
        buttonColor: buttonColor,
        primaryColorDark: subtitleColor,
        errorColor: errorColor,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: accentColor,
          elevation: 2.0,
          selectedItemColor: textColor,
          unselectedItemColor: subtitleColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: subtitleColor,
            decoration: TextDecoration.none,
            fontStyle: FontStyle.normal,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: textColor,
              style: BorderStyle.solid,
            ),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: textColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          headline2: TextStyle(
            color: textColor,
            fontSize: 30,
          ),
          headline3: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w200,
          ),
          headline4: TextStyle(
            color: textColor,
            fontSize: 35,
            fontWeight: FontWeight.w300,
          ),
          headline5: TextStyle(
            color: textColor,
            fontSize: 25,
          ),
          headline6: TextStyle(
            color: subtitleColor,
            fontSize: 17,
          ),
          bodyText1: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
          subtitle1: TextStyle(
            color: subtitleColor,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
          subtitle2: TextStyle(
            color: subtitleColor,
            fontSize: 13,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      home: ExpenderTab(),
    );
  }
}

class ExpenderTab extends StatefulWidget {
  @override
  _ExpenderTabState createState() => _ExpenderTabState();
}

class _ExpenderTabState extends State<ExpenderTab> {
  String prefsName = '';
  double prefsSalary = 0.0;
  String name = '';
  double salary = 0.0;
  bool isLoading = true;

  void getNameAndSalary() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box box;
    var boxExists = await Hive.boxExists('userData');
    if (boxExists) {
      box = await Hive.openBox('userData');
      prefsName = box.get('name');
      prefsSalary = box.get('salary');
    }
    setState(() {
      isLoading = false;
    });
  }

  void logout() async {
    var box = await Hive.openBox('userData');
    setState(() {
      prefsName = '';
      prefsSalary = 0.0;
      box.clear();
    });
  }

  void login(loginName, loginSalary) async {
    var box = await Hive.openBox('userData');

    box.put('name', loginName);
    box.put('salary', loginSalary);
    setState(() {
      prefsName = loginName;
      prefsSalary = loginSalary;
    });
  }

  @override
  void initState() {
    super.initState();
    getNameAndSalary();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: isLoading
              ? Loading()
              : prefsName == '' || prefsSalary == 0.0
                  ? Login(
                      login: login,
                    )
                  : ExpenserTabScaffold(
                      name: prefsName,
                      salary: prefsSalary,
                      logout: logout,
                    ),
        ),
      ),
    );
  }
}
