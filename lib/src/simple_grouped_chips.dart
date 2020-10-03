import 'package:checkbox_grouped/src/item.dart';
import 'package:checkbox_grouped/src/simple_grouped_checkbox.dart';
import 'package:flutter/material.dart';

///  [preSelection] : A list of values that you want to be initially selected.
///  [isMultiple] : enable multiple selection
///  [isScrolling] : enable horizontal scrolling
///  [backgroundColorItem] : the background color for each item
///  [selectedColorItem] : the background color to use when item is  selected
///  [textColor] : the color to use for each text of item
///  [selectedTextColor] :the selected color to use for each text of item
///  [selectedIcon] :the selected icon to use for each selected  item
///  [values] :(required) Values contains in each element.
///  [itemTitle] :(required) A list of strings that describes each chip button
///  [onItemSelected] : callback listner when item is selected
///  [disabledItems] : Specifies which item should be disabled

class SimpleGroupedChips<T> extends StatefulWidget {
  final List<T> preSelection;
  final bool isMultiple;
  final bool isScrolling;
  final Color backgroundColorItem;
  final Color disabledColor;
  final Color selectedColorItem;
  final Color textColor;
  final Color selectedTextColor;
  final IconData selectedIcon;
  final List<T> values;
  final List<String> itemTitle;
  final List<String> disabledItems;
  final onChanged onItemSelected;

  SimpleGroupedChips({
    Key key,
    @required this.values,
    @required this.itemTitle,
    this.disabledItems,
    this.onItemSelected,
    this.backgroundColorItem = Colors.grey,
    this.disabledColor = Colors.grey,
    this.selectedColorItem = Colors.black,
    this.selectedTextColor = Colors.white,
    this.textColor = Colors.black,
    this.selectedIcon = Icons.done,
    this.preSelection = const [],
    this.isScrolling = false,
    this.isMultiple = false,
  })  : assert(isMultiple == true && preSelection.isNotEmpty ||
            isMultiple == false && preSelection.isEmpty ||
            isMultiple == true && preSelection.isEmpty),
        assert(
            disabledItems == null ||
                disabledItems == [] ||
                disabledItems
                    .takeWhile((i) => itemTitle.contains(i))
                    .isNotEmpty,
            "you cannot disable items doesn't exist in itemTitle"),
        super(key: key);

  static SimpleGroupedChipsState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final SimpleGroupedChipsState<T> result =
        context.findAncestorStateOfType<SimpleGroupedChipsState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SimpleGroupedCheckbox.of() called with a context that does not contain an SimpleGroupedCheckbox.'),
      ErrorDescription(
          'No SimpleGroupedCheckbox ancestor could be found starting from the context that was passed to SimpleGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  SimpleGroupedChipsState<T> createState() => SimpleGroupedChipsState<T>();
}

class SimpleGroupedChipsState<T> extends State<SimpleGroupedChips> {
  Item _previousActive;
  T _selectedValue;
  List<T> _selectionsValue = [];
  List<ValueNotifier<Item>> _items = [];
  bool valueTitle = false;

  @override
  void initState() {
    super.initState();
    if (widget.isMultiple && widget.preSelection.isNotEmpty) {
      _selectionsValue.addAll(widget.preSelection as List<T>);
    }
    _items.addAll(widget.itemTitle
        .map((item) => ValueNotifier(Item(
              title: item,
              checked: widget.isMultiple && widget.preSelection.isNotEmpty
                  ? _selectionsValue
                      .contains(widget.values[widget.itemTitle.indexOf(item)])
                  : false,
              isDisabled: widget.disabledItems?.contains(item) ?? false,
            )))
        .toList());
  }

  selection() {
    if (widget.isMultiple) {
      return _selectionsValue;
    }
    return _selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScrolling) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 15.0,
          direction: Axis.horizontal,
          children: [
            for (int i = 0; i < _items.length; i++) ...[
              ValueListenableBuilder(
                valueListenable: _items[i],
                builder: (ctx, item, child) {
                  return _ChoiceChipsWidget(
                    onSelection: (v) {
                      _changeSelection(index: i, item: item, value: v);
                    },
                    selectedIcon: Icon(
                      widget.selectedIcon,
                      color: widget.selectedTextColor,
                    ),
                    isSelected: item.checked,
                    label: Text(
                      "${item.title}",
                      style: TextStyle(
                        color: item.checked
                            ? widget.selectedTextColor
                            : widget.textColor,
                      ),
                    ),
                    backgroundColorItem: widget.backgroundColorItem,
                    disabledColor: widget.disabledColor,
                    selectedColorItem: widget.selectedColorItem,
                  );
                },
              ),
            ],
          ],
        ),
        scrollDirection: Axis.horizontal,
      );
    }
    return Wrap(
      spacing: 5.0,
      direction: Axis.horizontal,
      verticalDirection: VerticalDirection.down,
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          ValueListenableBuilder(
            valueListenable: _items[i],
            builder: (ctx, item, child) {
              return _ChoiceChipsWidget(
                onSelection: (v) {
                  _changeSelection(index: i, item: item, value: v);
                },
                selectedIcon: Icon(
                  widget.selectedIcon,
                  color: widget.selectedTextColor,
                ),
                isSelected: item.checked,
                label: Text(
                  "${item.title}",
                  style: TextStyle(
                    color: item.checked
                        ? widget.selectedTextColor
                        : widget.textColor,
                  ),
                ),
                backgroundColorItem: widget.backgroundColorItem,
                disabledColor: widget.disabledColor,
                selectedColorItem: widget.selectedColorItem,
              );
            },
          ),
        ],
      ],
    );
  }


  void _changeSelection({int index, Item item, bool value}) {
    Item _item = item.copy();
    if (value) {
      if (widget.isMultiple) {
        _selectionsValue.add(widget.values[index]);
        _item.checked = value;
        _items[index].value = _item;
        if (widget.onItemSelected != null) {
          widget.onItemSelected(_selectionsValue);
        }
      } else {
        if (_selectedValue != widget.values[index]) {
          // TODO : find old selected and deselected
          var valueListenerOldItem = _items.firstWhere(
              (element) => element.value.checked == true,
              orElse: () => null);
          if(valueListenerOldItem!=null){
            Item oldItem = valueListenerOldItem.value.copy();
            int indexOldItem = _items.indexOf(valueListenerOldItem);
            oldItem.checked = false;
            _items[indexOldItem].value = oldItem;
          }

          _item.checked = true;
          _items[index].value = _item;
          _selectedValue = widget.values[index];
          if (widget.onItemSelected != null) {
            widget.onItemSelected(widget.values[index]);
          }
        }
      }
    } else {
      if (widget.isMultiple) {
        _selectionsValue.remove(widget.values[index]);
        _item.checked = value;
        _items[index].value = _item;
        if (widget.onItemSelected != null) {
          widget.onItemSelected(_selectionsValue);
        }
      }
    }
  }
}

class _ChoiceChipsWidget extends StatelessWidget {
  final Color backgroundColorItem;
  final Color disabledColor;
  final Color selectedColorItem;
  final Icon selectedIcon;
  final Function(bool) onSelection;
  final bool isSelected;
  final Widget label;
  final Widget avatar;

  _ChoiceChipsWidget({
    this.label,
    this.avatar,
    this.onSelection,
    this.isSelected,
    this.backgroundColorItem,
    this.disabledColor,
    this.selectedColorItem,
    this.selectedIcon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: label,
      avatar: avatar != null
          ? avatar
          : isSelected
              ? selectedIcon
              : null,
      selectedColor: selectedColorItem,
      backgroundColor: backgroundColorItem,
      disabledColor: disabledColor,
      selected: isSelected,
      onSelected: onSelection,
    );
  }
}
