import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key, required this.initDate}) : super(key: key);
  final DateTime initDate;

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  Box? _box;
  int _count = 0;

  Category? _categoryBuilder(BuildContext ctx, int index) {
    if (index < _count) {
      var c = _box!.get(index);
      return Category(key: UniqueKey(), id: c.index);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _box = Hive.box("budgetCategoryBox");
    _count = _box!.values.length;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childList = [];
    for (var key in _box!.keys) {
      var category = _categoryBuilder(context, key);
      if (category != null) childList.add(category);
    }

    //Categories
    return Column(children: [
      const Card(
        child: Text("Budget for: #Month#"),
      ),
      //Display Categories
      Expanded(
        child: ListView(children: childList, shrinkWrap: true),
      )
    ]);
  }
}

class Category extends StatefulWidget {
  final int id;

  const Category({Key? key, required this.id}) : super(key: key);
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _expanded = false;
  CategoryDetails _details = CategoryDetails();
  int _count = 0;
  Box? _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box("budgetItemBox");
    _count = _box!.values.length;
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _setName(name) {
    setState(() {
      _details.name = name;
    });
    _saveState();
  }

  void _saveState() {
    var box = Hive.box("budgetCategoryBox");
    box.put(widget.id, _details);
  }

  void _getSavedState() {
    var box = Hive.box("budgetCategoryBox");
    if (box.get(widget.id) != null) {
      setState(() {
        _details = box.get(widget.id, defaultValue: {CategoryDetails()});
      });
    }
  }

  BudgetItem? _budgetItemBuilder(BuildContext ctx, int index) {
    if (index < _count) {
      return BudgetItem(key: UniqueKey(), id: index);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childList = [];
    for (var key in _box!.keys) {
      var item = _budgetItemBuilder(context, key);
      if (item != null) childList.add(item);
    }
    return Column(children: [
      Card(child: Text(_details.name)),
      ListView(
        children: childList,
        shrinkWrap: true,
      )
    ]);
  }
}

class Repeat {
  final int days; //Period with which transaction recurs in days
  final int weeks; //Period with which transaction recurs in weeks
  final int months; //Period with which transaction recurs in months

  const Repeat(this.days, this.weeks, this.months);
}

class CategoryDetails {
  String name;
  CategoryDetails({this.name = "Unnamed Category"});
}

class ItemDetails {
  String name;
  int amount; //amount in smallest denomination of currency.
  bool sign; //false for negative, true for positive
  Repeat? repeat;
  int category; //placeholder for category id

  ItemDetails(
      {this.name = "",
      this.amount = 0,
      this.sign = true,
      this.repeat,
      this.category = 0});
}

class BudgetItem extends StatefulWidget {
  final int id;

  BudgetItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BudgetItem> createState() => _BudgetItemState();
}

class _BudgetItemState extends State<BudgetItem> {
  final TextEditingController _controller = TextEditingController();
  ItemDetails? _details;

  @override
  void initState() {
    super.initState();
    _getSavedState();
  }

  void _getSavedState() {
    var box = Hive.box("budgetItemBox");
    if (box.get(widget.id) != null) {
      setState(() {
        _details = box.get(widget.id, defaultValue: {ItemDetails()});
      });
    }
  }

  void _saveState() {
    var box = Hive.box("budgetItemBox");
    box.put(widget.id, _details);
  }

  void _setName(String name) {
    setState(() {
      _details?.name = name;
    });
  }

  TextStyle _getFormat() {
    return const TextStyle(fontWeight: FontWeight.normal);
  }

  Color? _getFillColor() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        onChanged: _setName,
        controller: _controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: _getFillColor(),
            label: Text.rich(TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text("Hi", style: _getFormat()),
                ),
              ],
            ))),
      )
    ]));
  }
}
