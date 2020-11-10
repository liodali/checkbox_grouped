import 'package:checkbox_grouped/src/item.dart';
import 'package:checkbox_grouped/src/simple_grouped_checkbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///  [preSelectionItems] : A list of values that you want to be initially selected.
///  [isMultipleSelection] : enable multiple selection
///  [textStyle] : the style to use for each text of item
///  [activeColor] :the selected color to use for each switch item
///  [values] :(required) Values contains in each element.
///  [itemsTitle] :(required) A list of strings that describes each chip button
///  [onItemSelected] : callback listner when item is selected
///  [disableItems] : Specifies which item should be disabled

class SimpleGroupedSwitch<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final List<String> preSelectionItems;
  final List<T> values;
  final List<T> disableItems;
  final bool isMultipleSelection;
  final onChanged onItemSelected;
  final Color activeColor;
  final TextStyle textStyle;

  SimpleGroupedSwitch({
    Key key,
    this.itemsTitle,
    this.values,
    this.disableItems = const [],
    this.preSelectionItems = const [],
    this.activeColor,
    this.textStyle,
    this.isMultipleSelection = true,
    this.onItemSelected,
  })  : assert(values.length == itemsTitle.length),
        assert(disableItems.takeWhile((c) => values.contains(c)).isNotEmpty,
            "you cannot disable item doesn't exist"),
        assert((isMultipleSelection &&
                (preSelectionItems.isEmpty || preSelectionItems.isNotEmpty)) ||
            (!isMultipleSelection &&
                (preSelectionItems.length == 1 || preSelectionItems.isEmpty))),
        super(key: key);

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
  List<ValueNotifier<Item>> _items;
  ValueNotifier<T> _selectedValue=ValueNotifier(null);
  List<ValueNotifier<T>> _selectedValues;

  selection() {
    if (widget.isMultipleSelection) {
      return _selectedValues.map((e) => e.value).toList();
    }
    return _selectedValue.value;
  }

  @override
  void initState() {
    super.initState();
    _items = [];
    _selectedValues = [];
    widget.itemsTitle.asMap().forEach((index, elem) {
      _items.add(ValueNotifier(Item(
          title: elem,
          checked: widget.preSelectionItems.contains(elem),
          isDisabled: widget.disableItems.contains(widget.values[index]))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return ValueListenableBuilder<Item>(
          valueListenable: _items[index],
          builder: (ctx,item,_){
            return _SwitchListItem(
              indexItem: index,
              onItemChanged: onChanged,
              item: item,
              activeColor: widget.activeColor,
              textStyle: widget.textStyle,
            );
          },
        );
        // return itemsWidget(_items[index]);
      },
      itemCount: _items.length,
    );
  }

  void onChanged(Item item, bool value, int index) {
    if (widget.isMultipleSelection) {
      if (!value) {
        _selectedValues.remove(widget.values[index]);
      }
      _items[index].value = item.copy(checked: value);
      if (widget.onItemSelected != null) widget.onItemSelected(_selectedValues.map((e) => e.value).toList());
    } else {
      if (!item.checked && value) {
        _items[index].value = item.copy(checked: value);
        if (value) {
          if (widget.values.indexOf(_selectedValue) != index) {
            //_items[index].checked = false;
            if (_selectedValue.value != null) {
              final indexPreviousItem = widget.values.indexOf(_selectedValue.value);
              final previousItem = _items[indexPreviousItem].value;
              _items[indexPreviousItem].value =
                  previousItem.copy(checked: false);
            }
            _selectedValue.value = widget.values[index];
          }
        }
        if (widget.onItemSelected != null)
          widget.onItemSelected(_selectedValue.value);
      }
    }
  }


}

class _SwitchListItem extends StatelessWidget {
  final Item item;
  final int indexItem;
  final Function(Item, bool, int) onItemChanged;
  final Color activeColor;
  final TextStyle textStyle;

  _SwitchListItem({
    @required this.item,
    @required this.onItemChanged,
    @required this.indexItem,
    this.activeColor,
    this.textStyle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      onChanged: item.isDisabled
          ? null
          : (v) {
              onItemChanged(item, v, indexItem);
            },
      activeColor: activeColor ?? Theme.of(context).primaryColor,
      value: item.checked,
      title: Text(
        "${item.title}",
        style: textStyle?.copyWith(
          color: item.checked
              ? activeColor
              : (textStyle?.color ??
                      Theme.of(context).textTheme.headline6.color) ??
                  Theme.of(context).textTheme.headline6.getTextStyle(),
        ),
      ),
    );
  }
}
