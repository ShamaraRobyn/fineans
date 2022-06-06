import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_a/cookbook.dart';
import 'package:project_a/discover.dart';
import 'package:project_a/pantry/pantry.dart';

class MainContainer extends StatefulWidget {
  final PageController pageController;
  const MainContainer({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<MainContainer> createState() => _ContainerState();
}

class _ContainerState extends State<MainContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Categories
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.pageController,
      children: const <Widget>[DiscoveryPage(), PantryPage(), CookbookPage()],
    );
  }
}
