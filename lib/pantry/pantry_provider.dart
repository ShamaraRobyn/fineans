import 'package:hive/hive.dart';
import 'package:project_a/pantry/pantryItem.dart';

class PantryProvider {
  String match = "";
  List<PantryItem> itemList = [];

  late Box box;
  late int _count;

  PantryProvider() {
    box = Hive.box("pantryBox");
    _count = _box!.values.length;
  }

  PantryItem? get(int pos) {
    return itemList[pos];
  }

  int count() {
    return itemList.length;
  }

  bool _doesMatch(String value) {
    return value.contains(match);
  }

  List<Object> _getDetails() {
    return [id, _name, _categories];
  }

  void _setDetails(list) {
    setState(() {
      id = list[0];
      _name = list[1];
      _categories = list[2];
    });
  }

  void refresh() {
    itemList.clear();
    PantryItem item;
    for (int i = 0; i < box.length; i++) {
      item = box.get(i);
      if (_doesMatch(box.get(i)[1].toString().toLowerCase())) {
        itemList.add(PantryItem(
          index: i,
        ));
      }
    }
  }

  void _save() {
    box = Hive.box("pantryBox");
    if (box.get(id) != _getDetails()) {
      box.put(id, _getDetails());
    }
    setState(() {});
  }

  void _load(index) {
    var box = Hive.box("pantryBox");
    //If there's no filters set, just go by index
    if (index < box.length) {
      int tempIndex = index;
      if (widget.searchTerm.isEmpty) {
        _setDetails(box.getAt(index));
      } else {
        //go through entries until we find one that meets the criteria
        bool found = false;
        while (!found && index < box.length) {
          List<dynamic> result = box.getAt(index);
          if (result[1]
              .toString()
              .toLowerCase()
              .contains(widget.searchTerm.toLowerCase())) {
            found = true;
            _setDetails(box.getAt(index));
          }
          widget.incrementIndex();
          tempIndex++;
          //Set the item count here.
          if (index == box.length && widget.searchTerm.isNotEmpty) {
            log("setting count: " + index.toString());
            widget.setItemCount(index);
          }
        }
      }
    }
    _save();
  }
}
