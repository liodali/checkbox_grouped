import 'package:checkbox_grouped/src/item.dart';
import 'package:checkbox_grouped/src/simple_grouped_checkbox.dart';
import 'package:flutter/material.dart';

class SimpleGroupedSwitch<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final List<String> preSelectionItems;
  final List<T> values;
  final bool isMutlipleSelection;
  final onChanged onSelectedItems;
  SimpleGroupedSwitch({
    Key key,
    this.itemsTitle,
    this.values,
    this.preSelectionItems = const [],
    this.isMutlipleSelection = true,
    this.onSelectedItems,
  })  : assert(values.length == itemsTitle.length),
        assert((isMutlipleSelection &&
                (preSelectionItems.isEmpty || preSelectionItems.isNotEmpty)) ||
            (!isMutlipleSelection &&
                (preSelectionItems.length == 1 || preSelectionItems.isEmpty))),
  super(key:key);

  static SimpleGroupedSwitchState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final SimpleGroupedSwitchState<T> result =
        context.findAncestorStateOfType<SimpleGroupedSwitchState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedSwitch.of() called with a context that does not contain an SimpleGroupedSwitch.'),
      ErrorDescription(
          'No SimpleGroupedSwitch ancestor could be found starting from the context that was passed to SimpleGroupedSwitch.of().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  State<StatefulWidget> createState() => SimpleGroupedSwitchState<T>();
}

class SimpleGroupedSwitchState<T> extends State<SimpleGroupedSwitch> {
  List<Item> _items;
  T _selectedValue;
  List<T> _selectedValues;


  selection(){
    if(widget.isMutlipleSelection){
      return _selectedValues;
    }
    return _selectedValue;
  }

  @override
  void initState() {
    super.initState();
    _items = [];
    _selectedValues = [];
    widget.itemsTitle.asMap().forEach((index, elem) {
      _items.add(Item(
          title: elem,
          checked: widget.preSelectionItems.contains(elem),
          isDisabled: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: itemsWidget(),
      ),
    );
  }

  void onChanged(Item item, bool value, int index) {
    if (widget.isMutlipleSelection) {
      if (!value) {
        _selectedValues.remove(widget.values[index]);
      }
      item.checked = value;
      if(widget.onSelectedItems!=null)
      widget.onSelectedItems(_selectedValues);
    } else {
      if (!item.checked && value) {
        item.checked = value;
        if (value) {
          if (widget.values.indexOf(_selectedValue) != index) {
            //_items[index].checked = false;
            if(_selectedValue!=null)
            _items[widget.values.indexOf(_selectedValue)].checked = false;
            _selectedValue = widget.values[index];
          }
        }
        if(widget.onSelectedItems!=null)
        widget.onSelectedItems(_selectedValue);
      }
    }
  }

  List<Widget> itemsWidget() {
    return _items
        .map((elem) => SwitchListTile(
              onChanged: (v) {
                setState(() {
                  onChanged(elem, v, _items.indexOf(elem));
                });
              },
              value: elem.checked,
              title: Text("${elem.title}"),
            ))
        .toList();
  }
}
