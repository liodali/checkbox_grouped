import 'package:checkbox_grouped/src/common/base_grouped_widget.dart';
import 'package:checkbox_grouped/src/common/grouped_style.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_checkbox.dart';
import 'package:flutter/material.dart';

import 'package:checkbox_grouped/src/common/item.dart';
import 'package:checkbox_grouped/src/common/state_group.dart';

enum ChipsDirection {
  horizontal,
  vertical,
  wrap,
}

/// [SimpleGroupedChips]
///
///
///  [controller]            : A list of values that you want to be initially selected.
///
///  [isScrolling]           : enable horizontal scrolling
///
///  [chipGroupStyle]        :  (ChipGroupStyle) the style that will customize  SimpleGroupedChips
///
///  [values]               : (required) Values contains in each element.
///
///  [itemTitle]            : (required) A list of strings that describes each chip button
///
///  [onItemSelected] : callback listener when item is selected
///
///  [disabledItems] : Specifies which item should be disabled
class SimpleGroupedChips<T> extends BaseSimpleGrouped<T> {
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
  final OnChanged? onItemSelected;
  final ChipsDirection direction;
  SimpleGroupedChips({
    super.key,
    required super.controller,
    required super.values,
    required super.itemsTitle,
    super.disableItems,
    this.onItemSelected,
    this.backgroundColorItem = Colors.grey,
    this.disabledColor = Colors.grey,
    this.selectedColorItem = Colors.black,
    this.selectedTextColor = Colors.white,
    this.textColor = Colors.black,
    this.selectedIcon = Icons.done,
    this.chipGroupStyle = const ChipGroupStyle.minimize(),
    this.isScrolling = false,
    this.direction = ChipsDirection.wrap,
  });

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
  // @override
  // void initState() {
  //   super.initState();
  //   init(
  //     values: widget.values as List<T>,
  //     //checkFirstElement: false,
  //     preSelection: widget.controller.initSelectedItem.cast<T>(),
  //     multiSelection: widget.controller.isMultipleSelection,
  //     itemsTitle: widget.itemsTitle,
  //     disableItems: widget.disableItems,
  //   );
  //   widget.controller.init(this);
  // }

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
              isMultiChoice: widget.controller.isMultipleSelection,
              onSelection: (v) {
                changeSelection(i, v);
              },
              shape: item.checked
                  ? widget.chipGroupStyle.checkedShape
                  : widget.chipGroupStyle.shape,
              selectedIcon: widget.chipGroupStyle.selectedIcon != null
                  ? Icon(
                      widget.chipGroupStyle.selectedIcon,
                      color: widget.chipGroupStyle.selectedTextColor,
                      size: 18,
                    )
                  : null,
              isSelected: item.checked,
              label: Text(
                "${item.title}",
                style: widget.chipGroupStyle.itemTitleStyle?.copyWith(
                      color: item.checked
                          ? widget.chipGroupStyle.selectedTextColor
                          : widget.chipGroupStyle.textColor,
                    ) ??
                    TextStyle(
                      color: item.checked
                          ? widget.chipGroupStyle.selectedTextColor
                          : widget.chipGroupStyle.textColor,
                    ),
              ),
              backgroundColorItem: widget.chipGroupStyle.backgroundColorItem ??
                  widget.chipGroupStyle.backgroundColorItem,
              disabledColor: widget.chipGroupStyle.disabledColor,
              selectedColorItem: widget.chipGroupStyle.selectedColorItem,
            );
          },
        ),
      ],
    ];
    final child = switch (widget.direction) {
      (ChipsDirection.wrap) => Wrap(
          spacing: widget.isScrolling ? 15.0 : 5.0,
          direction: Axis.horizontal,
          children: childrens,
        ),
      (ChipsDirection.horizontal) => Wrap(
          spacing: 15.0,
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.up,
          children: childrens,
        ),
      (ChipsDirection.vertical) => Wrap(
          spacing: 15.0,
          direction: Axis.vertical,
          children: childrens,
        ),
    };
    if (widget.isScrolling) {
      return SingleChildScrollView(
        child: child,
        scrollDirection: Axis.horizontal,
      );
    }
    return child;
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
  final OutlinedBorder? shape;
  final bool isMultiChoice;
  _ChoiceChipsWidget({
    required this.label,
    this.isMultiChoice = false,
    this.avatar,
    this.onSelection,
    this.isSelected,
    this.backgroundColorItem,
    this.disabledColor,
    this.selectedColorItem,
    this.selectedIcon,
    this.shape,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMultiChoice) {
      return FilterChip(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        label: label,
        shape: shape,
        avatarBorder: RoundedRectangleBorder(),
        side: shape?.side,
        avatar: avatar != null
            ? avatar
            : isSelected!
                ? selectedIcon != null
                    ? selectedIcon
                    : null
                : null,
        showCheckmark: false,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              size: 48,
            ),
        selectedColor: selectedColorItem,
        backgroundColor: backgroundColorItem,
        disabledColor: disabledColor,
        selected: isSelected!,
        onSelected: onSelection,
      );
    }
    return ChoiceChip(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      label: label,
      shape: shape,
      avatarBorder: RoundedRectangleBorder(),
      side: shape?.side,
      avatar: avatar != null
          ? avatar
          : isSelected!
              ? selectedIcon != null
                  ? ColoredBox(
                      color: Colors.transparent,
                      child: selectedIcon,
                    )
                  : null
              : null,
      iconTheme: Theme.of(context).iconTheme.copyWith(
            size: 48,
          ),
      selectedColor: selectedColorItem,
      backgroundColor: backgroundColorItem,
      disabledColor: disabledColor,
      selected: isSelected!,
      onSelected: onSelection,
    );
  }
}
