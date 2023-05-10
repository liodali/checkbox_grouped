import 'package:checkbox_grouped/src/common/grouped_style.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:flutter/material.dart';

import 'package:checkbox_grouped/src/common/item.dart';
import 'package:checkbox_grouped/src/common/state_group.dart';
import 'package:checkbox_grouped/src/widgets/simple_grouped_checkbox.dart';

///  [controller] :(required) GroupController to recuperate selectedItems.
///  [values] :(required) Values contains in each element.
///  [itemsTitle] :(required) A list of strings that describes each chip button
///  [onItemSelected] : callback listner when item is selected
///  [disableItems] : Specifies which item should be disabled

class SimpleGroupedSwitch<T> extends StatefulWidget {
  final List<String> itemsTitle;
  final List<T> values;
  final GroupController controller;
  final List<T> disableItems;
  final OnChanged? onItemSelected;
  @Deprecated("should use `groupStyle`,will be remove in next version")
  final Color? activeColor;
  @Deprecated("should use `groupStyle`,will be remove in next version")
  final TextStyle? textStyle;
  final SwitchGroupStyle? groupStyle;

  SimpleGroupedSwitch({
    Key? key,
    required this.itemsTitle,
    required this.values,
    required this.controller,
    this.groupStyle,
    this.disableItems = const [],
    this.activeColor,
    this.textStyle,
    this.onItemSelected,
  })  : assert(values.length == itemsTitle.length),
        assert(
          disableItems.isEmpty ||
              disableItems.takeWhile((c) => values.contains(c)).isNotEmpty,
          "you cannot disable item doesn't exist",
        ),
        super(key: key);

  static SimpleGroupedSwitchState? of<T>(BuildContext context,
      {bool nullOk = false}) {
    final SimpleGroupedSwitchState<T>? result =
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

class SimpleGroupedSwitchState<T> extends StateGroup<T, SimpleGroupedSwitch> {
  @override
  void initState() {
    super.initState();
    init(
      values: widget.values.cast<T>(),
      itemsTitle: widget.itemsTitle,
      preSelection: widget.controller.initSelectedItem.cast<T>(),
      multiSelection: widget.controller.isMultipleSelection,
      disableItems: widget.itemsTitle
          .where((element) => widget.disableItems
              .contains(widget.values[widget.itemsTitle.indexOf(element)]))
          .toList(),
      checkFirstElement: false,
    );
    widget.controller.init(this);
  }

  @override
  void didUpdateWidget(covariant SimpleGroupedSwitch oldWidget) {
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
        disableItems: widget.itemsTitle
            .where((element) => widget.disableItems
                .contains(widget.values[widget.itemsTitle.indexOf(element)]))
            .toList(),
        itemsTitle: widget.itemsTitle,
        multiSelection: widget.controller.isMultipleSelection,
        preSelection: widget.controller.initSelectedItem?.cast<T>(),
      );
      widget.controller.init(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return ValueListenableBuilder<Item>(
          valueListenable: notifierItems[index],
          builder: (ctx, item, _) {
            return _SwitchListItem(
              indexItem: index,
              onItemChanged: changeSelection,
              item: item,
              activeColor: widget.groupStyle?.activeColor,
              textStyle: widget.groupStyle?.itemTitleStyle?.copyWith(
                  color: item.checked!
                      ? widget.groupStyle?.activeColor
                      : widget.groupStyle?.itemTitleStyle?.color),
            );
          },
        );
        // return itemsWidget(_items[index]);
      },
      itemCount: notifierItems.length,
    );
  }

  @override
  void changeSelection(int index, value) {
    Item item = notifierItems[index].value.copy();
    if (widget.controller.isMultipleSelection) {
      if (!value) {
        notifierItems[index].value = item.copy(checked: false);
        selectionsValue.value = List.from(selectionsValue.value)
          ..remove(widget.values[index]);
      } else {
        notifierItems[index].value = item.copy(checked: value);
        selectionsValue.value = List.from(selectionsValue.value)
          ..add(widget.values[index]);
      }
      if (streamListValues.hasListener) {
        streamListValues.add(selection());
      }
    } else {
      if (!item.checked! && value) {
        notifierItems[index].value = item.copy(checked: value);
        if (value) {
          if (widget.values.indexOf(selectedValue.value) != index) {
            //_items[index].checked = false;
            if (selectedValue.value != null) {
              final indexPreviousItem =
                  widget.values.indexOf(selectedValue.value);
              final previousItem = notifierItems[indexPreviousItem].value;
              notifierItems[indexPreviousItem].value =
                  previousItem.copy(checked: false);
            }
            selectedValue.value = widget.values[index];
          }
        }
      }
      if (widget.onItemSelected != null) widget.onItemSelected!(selection());
      if (streamOneValue.hasListener) {
        streamOneValue.add(selection());
      }
    }
  }

  @override
  selection() {
    if (widget.controller.isMultipleSelection) {
      return selectionsValue.value;
    }
    return selectedValue.value;
  }
}

class _SwitchListItem extends StatelessWidget {
  final Item item;
  final int indexItem;
  final Function(int, bool) onItemChanged;
  final Color? activeColor;
  final TextStyle? textStyle;

  _SwitchListItem({
    required this.item,
    required this.onItemChanged,
    required this.indexItem,
    this.activeColor,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      onChanged: item.isDisabled
          ? null
          : (v) {
              onItemChanged(indexItem, v);
            },
      activeColor: activeColor ?? Theme.of(context).primaryColor,
      value: item.checked!,
      title: Text(
        "${item.title}",
        style: textStyle,
      ),
    );
  }
}
