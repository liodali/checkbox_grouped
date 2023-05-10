import 'package:checkbox_grouped/src/common/grouped_style.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_checkbox.dart';
import 'package:flutter/material.dart';

import 'package:checkbox_grouped/src/common/item.dart';
import 'package:checkbox_grouped/src/common/state_group.dart';

///
///  [controller]            : A list of values that you want to be initially selected.
///
///  [isScrolling]           : enable horizontal scrolling
///
/// [chipGroupStyle]        :  (ChipGroupStyle) the style that will customize  SimpleGroupedChips
///
///  [values]               : (required) Values contains in each element.
///
///  [itemTitle]            : (required) A list of strings that describes each chip button
///
///  [onItemSelected] : callback listener when item is selected
///
///  [disabledItems] : Specifies which item should be disabled
class SimpleGroupedChips<T> extends StatefulWidget {
  final GroupController controller;
  final bool isScrolling;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final Color backgroundColorItem;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final Color? disabledColor;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final Color selectedColorItem;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final Color textColor;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final Color selectedTextColor;
  @Deprecated("should use `chipGroupStyle`,will be remove in next version")
  final IconData? selectedIcon;
  final ChipGroupStyle chipGroupStyle;
  final List<T> values;
  final List<String> itemTitle;
  final List<String>? disabledItems;
  final OnChanged? onItemSelected;

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
    this.chipGroupStyle = const ChipGroupStyle.minimize(),
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
  late final ChipGroupStyle groupStyle;

  @override
  void initState() {
    super.initState();
    groupStyle = ChipGroupStyle(
      backgroundColorItem: widget.chipGroupStyle.backgroundColorItem,
      selectedColorItem: widget.chipGroupStyle.selectedColorItem,
      textColor: widget.chipGroupStyle.textColor,
      selectedTextColor: widget.chipGroupStyle.selectedTextColor,
      disabledColor: widget.chipGroupStyle.disabledColor,
      selectedIcon: widget.chipGroupStyle.selectedIcon,
      itemTitleStyle: widget.chipGroupStyle.itemTitleStyle,
    );
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
  void didUpdateWidget(covariant SimpleGroupedChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      selectionsValue = ValueNotifier([]);
      notifierItems = [];
      items = [];
      valueTitle = ValueNotifier(false);
      values = [];
      init(
        values: widget.values as List<T>,
        checkFirstElement: false,
        disableItems: widget.disabledItems,
        itemsTitle: widget.itemTitle,
        multiSelection: widget.controller.isMultipleSelection,
        preSelection: widget.controller.initSelectedItem?.cast<T>(),
      );
      widget.controller.init(this);
    }
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
    final childrens = [
      for (int i = 0; i < notifierItems.length; i++) ...[
        ValueListenableBuilder(
          valueListenable: notifierItems[i],
          builder: (ctx, dynamic item, child) {
            return _ChoiceChipsWidget(
              onSelection: (v) {
                changeSelection(i, v);
              },
              selectedIcon: groupStyle.selectedIcon != null
                  ? Icon(
                      groupStyle.selectedIcon,
                      color: groupStyle.selectedTextColor,
                    )
                  : null,
              isSelected: item.checked,
              label: Text(
                "${item.title}",
                style: groupStyle.itemTitleStyle?.copyWith(
                      color: item.checked
                          ? groupStyle.selectedTextColor
                          : groupStyle.textColor,
                    ) ??
                    TextStyle(
                      color: item.checked
                          ? groupStyle.selectedTextColor
                          : groupStyle.textColor,
                    ),
              ),
              backgroundColorItem: widget.chipGroupStyle.backgroundColorItem ??
                  groupStyle.backgroundColorItem,
              disabledColor: groupStyle.disabledColor,
              selectedColorItem: groupStyle.selectedColorItem,
            );
          },
        ),
      ],
    ];
    if (widget.isScrolling) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 15.0,
          direction: Axis.horizontal,
          children: childrens,
        ),
        scrollDirection: Axis.horizontal,
      );
    }
    return Wrap(
      spacing: 5.0,
      direction: Axis.horizontal,
      verticalDirection: VerticalDirection.down,
      children: childrens,
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
        if (streamListValues.hasListener) {
          streamListValues.add(selection());
        }
      } else {
        if (selectedValue.value != widget.values[index]) {
          var indexOldItem = notifierItems
              .indexWhere((element) => element.value.checked == true);
          if (indexOldItem != -1) {
            Item oldItem = notifierItems[indexOldItem].value.copy();
            oldItem.checked = false;
            notifierItems[indexOldItem].value = oldItem;
          }

          _item.checked = true;
          notifierItems[index].value = _item;
          selectedValue.value = widget.values[index];
          if (widget.onItemSelected != null) {
            widget.onItemSelected!(widget.values[index]);
          }
          if (streamOneValue.hasListener) {
            streamOneValue.add(selection());
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
        if (streamListValues.hasListener) {
          streamListValues.add(selection());
        }
      }
    }
  }
}

class _ChoiceChipsWidget extends StatelessWidget {
  final Color? backgroundColorItem;
  final Color? disabledColor;
  final Color? selectedColorItem;
  final Icon? selectedIcon;
  final Function(bool)? onSelection;
  final bool? isSelected;
  final Widget label;
  final Widget? avatar;

  _ChoiceChipsWidget({
    required this.label,
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
      label: label,
      avatar: avatar != null
          ? avatar
          : isSelected!
              ? selectedIcon != null
                  ? selectedIcon
                  : null
              : null,
      selectedColor: selectedColorItem,
      backgroundColor: backgroundColorItem,
      disabledColor: disabledColor,
      selected: isSelected!,
      onSelected: onSelection,
    );
  }
}
