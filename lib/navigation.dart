import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Navbar extends StatefulWidget {
  PageController pageController;
  final Duration animDuration = const Duration(milliseconds: 400);
  final Curve animCurve = Curves.easeIn;
  Navbar({Key? key, required this.pageController}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  void initState() {
    super.initState();
  }

  void _goToPage(page) {
    widget.pageController.animateToPage(page,
        duration: widget.animDuration, curve: widget.animCurve);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Categories
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Main Menu'),
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            _goToPage(0);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Fridge'),
          onTap: () {
            _goToPage(1);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Cookbook'),
          onTap: () {
            _goToPage(2);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
