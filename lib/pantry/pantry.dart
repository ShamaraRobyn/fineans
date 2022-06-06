import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_a/pantry/pantryItem.dart';
import 'package:project_a/pantry/pantry_provider.dart';

//A page for keeping inventory of what food you have
class PantryPage extends StatefulWidget {
  const PantryPage({Key? key}) : super(key: key);

  @override
  State<PantryPage> createState() => _PantryState();
}

class _PantryState extends State<PantryPage> {
  late PantryProvider _provider;
  
  int _selectedItem = 0;
  final int _maxPageSize = 28;
  late int _pageSize;
  String _searchTerm = "";
  int _gridIndex = 0;


  @override
  void initState() {
    super.initState();
    _provider = PantryProvider();
    _box = Hive.box("pantryBox");
    
    _pageSize = (_count < _maxPageSize) ? _count : _maxPageSize;
    _gridIndex = 0;
  }

  void setSelectedItem(int index, String name) {
    setState(() {
      _selectedItem = index;
    });
  }

  int _getItemCount() {
    if (_box!.isNotEmpty && _searchTerm.isEmpty) {
      setState(() {
        _count = _box!.values.length;
      });
    }
    return _count;
  }

  void _setItemCount(int count) {
    if (_searchTerm.isEmpty) {
      setState(() {
        _count = _box!.values.length;
      });
    } else {
      _count = count;
    }
  }

  void _incrementIndex() {
    if (_gridIndex < _maxPageSize) {
      _gridIndex++;
    }
  }

  PantryItem getItem(int index) {
    return PantryProvider.
    );
  }

  void _addItem() {
    PantryItem(
      isNew: true,
      selectFn: setSelectedItem,
      isSelected: false
    );
    setState(() {
      _count += 1;
    });
  }

  void _runFilter(value) {
    setState(() {
      _searchTerm = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_count.toString());
    _pageSize = (_count < _maxPageSize) ? _count : _maxPageSize;
    log("Page size: " + _pageSize.toString());
    _gridIndex = 0;
    //Categories
    var dropdownValue;
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const SizedBox(
        height: 20,
      ),
      const Text(
        "Pantry",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 40.0),
            labelText: 'Search',
            suffixIcon: Icon(Icons.search)),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        DropdownButton(
          hint: Text("Category"),
          value: dropdownValue,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem(
              value: 'Option 1',
              child: Text('All'),
            ),
            DropdownMenuItem(
              value: 'Option 2',
              child: Text('Fresh'),
            ),
            DropdownMenuItem(
              value: 'Option 3',
              child: Text('Frozen'),
            ),
            DropdownMenuItem(
              value: 'Option 4',
              child: Text('Ambient'),
            ),
            DropdownMenuItem(
              value: 'Option 5',
              child: Text('Seasonings'),
            ),
            DropdownMenuItem(
              value: 'Option 6',
              child: Text('Drinks'),
            ),
          ],
          onChanged: (value) {},
        ),
      ]),
      const SizedBox(
        height: 20,
      ),
      Flexible(
        child: InkWell(
        onTap: _select,
        onLongPress: () async {
          _select();
          await showInformationDialog(context);
          setState(() {});
        },
        onDoubleTap: () async {
          _select();
          await showInformationDialog(context);
          setState(() {});
        },child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _pageSize,
            primary: true,
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, index) {
              return getItem(index);
            })),
      ),
      FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    ]);
  }

   Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onFieldSubmitted: (finalName) {
                      _setName(finalName);
                      Navigator.of(context).pop();
                    },
                    controller: _editItemNameCtrl,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter any text";
                    },
                    decoration:
                        const InputDecoration(hintText: "Please Enter Text"),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Category"),
                      ])
                ],
              )),
              title: const Text('Edit Pantry Item'),
              actions: <Widget>[
                InkWell(
                  child: const Text('OK   '),
                  onTap: () {
                    _setName(_newName);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }
}
