import 'package:flutter/material.dart';
import 'package:project_a/budget.dart';
import 'package:project_a/mainContainer.dart';
import 'package:project_a/navigation.dart';
import 'package:project_a/planner.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('plannerBox');
  await Hive.openBox('budgetItemBox');
  await Hive.openBox('budgetCategoryBox');
  await Hive.openBox('discoveryBox');
  await Hive.openBox('pantryBox');
  await Hive.openBox('cookbookBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Shammy's Meal Planning & Budgeting Tool"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();
  final PageController _pageController = PageController();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
        key: _drawerKey,
        child: Navbar(pageController: _pageController),
      ),
      endDrawer: Drawer(
        key: _drawerKey,
        child: Planner(key: UniqueKey(), initDate: DateTime.now()),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: MainContainer(pageController: _pageController)),
            Expanded(child: Budget(initDate: DateTime.now()))
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEndDrawer,
        tooltip: 'Daily Planner',
        child: const Icon(Icons.calendar_today_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
