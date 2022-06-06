import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

//A page for keeping inventory of what food you have
class CookbookPage extends StatefulWidget {
  const CookbookPage({Key? key}) : super(key: key);

  @override
  State<CookbookPage> createState() => _CookbookState();
}

class _CookbookState extends State<CookbookPage> {
  Box? _box;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _box = Hive.box("cookbookBox");
    _count = _box!.values.length;
  }

  void _addItem() {}

  @override
  Widget build(BuildContext context) {
    //Categories
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Cookbook"),
      Flexible(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        crossAxisCount: 4,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[100],
            child: const Text("He'd have you all unravel at the"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[200],
            child: const Text('Heed not the rabble'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[300],
            child: const Text('Sound of screams but the'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[400],
            child: const Text('Who scream'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[500],
            child: const Text('Revolution is coming...'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[600],
            child: const Text('Revolution, they...'),
          ),
        ],
      )),
      FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    ]);
  }
}
