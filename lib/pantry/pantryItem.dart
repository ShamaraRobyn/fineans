import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';

class PantryItem extends StatefulWidget {
  final bool isNew;
  final bool isSelected;
  const PantryItem({Key? key, this.isNew = false, this.isSelected = false})
      : super(key: key);

  @override
  State<PantryItem> createState() => _PantryItemState();
}

class _PantryItemState extends State<PantryItem> {
  final String _defaultName = "Example";

  String id = UniqueKey().toString();
  List<String> _categories = [];
  String _name = "Example";
  String _newName = "T";

  final TextEditingController _editItemNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      _name = (_defaultName);
    } else {}
    _editItemNameCtrl.text = _name;
    _editItemNameCtrl.addListener(() {
      if (_editItemNameCtrl.text != "") {
        _newName = _editItemNameCtrl.text;
      }
    });
  }

  void _setName(name) {
    setState(() {
      _name = name;
    });
  }

  void _select() {
    widget.selectFn(widget.index, _name);
  }

  BoxBorder? _getBorder() {
    Color borderColor = const Color.fromARGB(255, 106, 0, 255);
    if (!widget.isSelected) {
      borderColor = borderColor.withAlpha(0);
    }
    return Border.all(color: borderColor);
  }

  void _setCategory(value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        "|" + id.toString() + " " + _name,
        overflow: TextOverflow.visible,
      ),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ], color: Colors.white, border: _getBorder()),
    );
  }
}
