import '../../checkbox_grouped.dart';
import '../common/item.dart';
import 'simple_grouped_checkbox.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import '../common/state_group.dart';

///  [controller] : A list of values that you want to be initially selected.
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
  final GroupController controller;
  final bool isScrolling;
  final Color backgroundColorItem;
  final Color? disabledColor;
  final Color selectedColorItem;
  final Color textColor;
  final Color selectedTextColor;
  final IconData selectedIcon;
  final List<T> values;
  final List<String> itemTitle;
  final List<String>? disabledItems;
  final onChanged? onItemSelected;

  SimpleGroupedChips({
    Key? key,
    required this.controller,
    required this.values,
    required this.itemTitle,
    this.disabledItems,
    this.onItemSelected,
    this.backgroundColorItem = Colors.grey,
    this.disabledColor = Colors.grey,
    this.selectedColorItem = Colors.black,
    this.selectedTextColor = Colors.white,
    this.textColor = Colors.black,
    this.selectedIcon = Icons.done,
    this.isScrolling = false,
  })  : assert(
            disabledItems == null ||
                disabledItems == [] ||
                disabledItems
                    .takeWhile((i) => itemTitle.contains(i))
                    .isNotEmpty,
            "you cannot disable items doesn't exist in itemTitle"),
        super(key: key);

  static SimpleGroupedChipsState? of<T>(BuildContext context,
      {bool nullOk = false}) {
    final SimpleGroupedChipsState<T>? result =
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

class SimpleGroupedChipsState<T> extends StateGroup<T, SimpleGroupedChips> {
  @override
  void initState() {
    super.initState();
    init(
      values: widget.values as List<T>,
      checkFirstElement: false,
      preSelection: widget.controller.initSelectedItem.cast<T>(),
      multiSelection: widget.controller.isMultipleSelection,
      itemsTitle: widget.itemTitle,
      disableItems: widget.disabledItems,
    );
    widget.controller.init(this);
  }

  @override
  selection() {
    if (widget.controller.isMultipleSelection) {
      return selectionsValue.value;
    }
    return selectedValue.value;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScrolling) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 15.0,
          direction: Axis.horizontal,
          children: [
            for (int i = 0; i < notifierItems.length; i++) ...[
              ValueListenableBuilder(
                valueListenable: notifierItems[i],
                builder: (ctx, dynamic item, child) {
                  return _ChoiceChipsWidget(
                    onSelection: (v) {
                      changeSelection(i, v);
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
        for (int i = 0; i < notifierItems.length; i++) ...[
          ValueListenableBuilder(
            valueListenable: notifierItems[i],
            builder: (ctx, dynamic item, child) {
              return _ChoiceChipsWidget(
                onSelection: (v) {
                  changeSelection(i, v);
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

  @override
  void changeSelection(int index, dynamic value) {
    Item _item = notifierItems[index].value.copy();
    if (value) {
      if (widget.controller.isMultipleSelection) {
        selectionsValue.value = List.from(selectionsValue.value)
          ..add(widget.values[index]);
        _item.checked = value;
        notifierItems[index].value = _item;
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(selectionsValue.value);
        }
      } else {
        if (selectedValue.value != widget.values[index]) {
          // TODO : find old selected and deselected
          var valueListenerOldItem = notifierItems
              .firstWhereOrNull((element) => element.value.checked == true);
          if (valueListenerOldItem != null) {
            Item oldItem = valueListenerOldItem.value.copy();
            int indexOldItem = notifierItems.indexOf(valueListenerOldItem);
            oldItem.checked = false;
            notifierItems[indexOldItem].value = oldItem;
          }

          _item.checked = true;
          notifierItems[index].value = _item;
          selectedValue.value = widget.values[index];
          if (widget.onItemSelected != null) {
            widget.onItemSelected!(widget.values[index]);
          }
        }
      }
    } else {
      if (widget.controller.isMultipleSelection) {
        selectionsValue.value = List.from(selectionsValue.value)
          ..remove(widget.values[index]);
        _item.checked = value;
        notifierItems[index].value = _item;
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(selectionsValue.value);
        }
      }
    }
  }

  @override
  void disabledItemsByTitles(List<String> items) {
    // TODO: implement disabledItemsByTitles
  }

  @override
  void disabledItemsByValues(List itemsValues) {
    // TODO: implement disabledItemsByValues
  }

  @override
  void enabledItemsByTitles(List<String> items) {
    // TODO: implement enabledItemsByTitles
  }

  @override
  void enabledItemsByValues(List itemsValues) {
    // TODO: implement enabledItemsByValues
  }
}

class _ChoiceChipsWidget extends StatelessWidget {
  final Color? backgroundColorItem;
  final Color? disabledColor;
  final Color? selectedColorItem;
  final Icon? selectedIcon;
  final Function(bool)? onSelection;
  final bool? isSelected;
  final Widget? label;
  final Widget? avatar;

  _ChoiceChipsWidget({
    this.label,
    this.avatar,
    this.onSelection,
    this.isSelected,
    this.backgroundColorItem,
    this.disabledColor,
    this.selectedColorItem,
    this.selectedIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: label!,
      avatar: avatar != null
          ? avatar
          : isSelected!
              ? selectedIcon
              : null,
      selectedColor: selectedColorItem,
      backgroundColor: backgroundColorItem,
      disabledColor: disabledColor,
      selected: isSelected!,
      onSelected: onSelection,
    );
  }
}
