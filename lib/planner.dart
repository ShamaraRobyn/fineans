import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Planner extends StatefulWidget {
  const Planner({Key? key, required this.initDate}) : super(key: key);

  final DateTime initDate;

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  PlannerItem _plannerItemBuilder(BuildContext ctx, int index) {
    final baseDate = DateTime(
        widget.initDate.year, widget.initDate.month, widget.initDate.day);
    var date = baseDate.add(Duration(days: index));
    return PlannerItem(key: UniqueKey(), id: index, date: date);
  }

  @override
  Widget build(BuildContext context) {
    //

    return ListView.builder(itemBuilder: _plannerItemBuilder);
  }
}

class PlannerItem extends StatefulWidget {
  final int id;
  final DateTime date;
  const PlannerItem({Key? key, required this.id, required this.date})
      : super(key: key);

  @override
  State<PlannerItem> createState() => _PlannerItemState();
}

class _PlannerItemState extends State<PlannerItem> {
  int _type = 0;
  static const String INITVALUE = "";
  String _value = "INITVALUE";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = _getValue();
  }

  void _setValue(value) {
    var box = Hive.box("plannerBox");
    if (box.get(widget.date.toString()) != value) {
      box.put(widget.date.toString(), value);
    }
    setState(() {
      _value = value;
    });
  }

  String _getValue() {
    var box = Hive.box("plannerBox");
    setState(() {
      _value = box.get(widget.date.toString(), defaultValue: "");
    });
    _controller.text = _value;
    return _value;
  }

  TextStyle getFormat() {
    if (_isToday()) {
      return const TextStyle(fontWeight: FontWeight.bold);
    }
    return const TextStyle(fontWeight: FontWeight.normal);
  }

  bool _isToday() {
    return widget.date.difference(DateTime.now()).inHours < 12;
  }

  Color? _getFillColor() {
    if (_isToday()) {
      return const Color.fromARGB(255, 165, 241, 190);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        onChanged: _setValue,
        controller: _controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: _getFillColor(),
            label: Text.rich(TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                      DateFormat('EEEE d/M/yyyy')
                          .format(widget.date)
                          .toString(),
                      style: getFormat()),
                ),
              ],
            ))),
      )
    ]));
  }
}
