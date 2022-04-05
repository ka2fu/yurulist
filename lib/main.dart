import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/repository/todo_repository.dart';

import 'package:yuruli/ui/done/done_list.dart';
import 'package:yuruli/ui/todo/todo_list.dart';
import 'package:yuruli/ui/yesterday/yesterday_list.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YURULIst',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.blueGrey[800],
      ),
      supportedLocales: const [
        Locale('ja'),
      ],
      localizationsDelegates: const [
        // ← これないとLocale('ja)でエラー出る
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: <String, WidgetBuilder>{
        '/': (_) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final int removeUntilIndex;

  const HomePage({
    Key? key,
    this.removeUntilIndex = 1,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const DoneList(),
    const TodoList(),
    const YesterdayList(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.solidCircleCheck), label: 'done'),
    const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.house), label: 'today'),
    const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.calendarCheck), label: 'yesterday'),
    // icon: FaIcon(FontAwesomeIcons.rightFromBracket), label: 'yesterday'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.removeUntilIndex;
    debugPrint('home initstate');
  }

  void _onTapChange(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('home ontapchange');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final vm = MainViewModel(TodoRepository(TodoDatabase()));
    debugPrint('home build');
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTapChange,
      ),
    );

    // if (vm.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // return ChangeNotifierProvider(
    //   create: (_) => vm,
    //   child: Scaffold(
    //     body: _pages.elementAt(_selectedIndex),
    //     bottomNavigationBar: BottomNavigationBar(
    //       items: _bottomNavItems,
    //       currentIndex: _selectedIndex,
    //       type: BottomNavigationBarType.fixed,
    //       onTap: _onTapChange,
    //     ),
    //   ),
    // );
  }
}
