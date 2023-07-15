import 'dart:async';

import 'package:checkbox_grouped/src/common/base_grouped_widget.dart';
import 'package:checkbox_grouped/src/controller/custom_group_controller.dart';
import 'package:flutter/material.dart';

import 'item.dart';
import 'utilities.dart';

abstract class _CustomGroupInterface<T> {
  /// enable the Items of the list of selection value
  /// [itemsValues] : (list) values of items that you want to be enabled
  void enabledItemsByValues(List<T> itemsValues);

  /// disable the Items of the list of selection value
  /// [itemsValues] : (list) values of items that you want to be disabled
  void disabledItemsByValues(List<T> itemsValues);

  /// recuperate value selection if is not multi selection
  /// recuperate list of selection value if is multi selection
  dynamic selection();

  void changeSelection(int index, bool value);
}

abstract class CustomStateGroup<K, T extends BaeCustomGrouped> extends State<T>
    implements _CustomGroupInterface<K> {
  ValueNotifier<K?> itemSelected = ValueNotifier(null);

  ValueNotifier<List<K>> itemsSelections = ValueNotifier([]);

  late List<ValueNotifier<CustomItem<K>>> items;

  final streamOneValue = StreamController<K>.broadcast(
    sync: true,
  );
  final streamListValues = StreamController<List<K>>.broadcast(
    sync: true,
  );

  void selectedListen(CustomListener listener) {
    streamOneValue.stream.listen((data) {
      listener(data);
    });
  }

  void selectionsListen(CustomListener listener) {
    streamListValues.stream.listen((data) {
      listener(data);
    });
  }

  @override
  void initState() {
    super.initState();
    itemsSelections = ValueNotifier([]);
    items = [];
    widget.values.forEach((v) {
      items.add(
        ValueNotifier(
          CustomItem(
            data: v,
            checked: widget.controller.initSelectedItem.contains(v),
            isDisabled: widget.disableItems.contains(v),
          ),
        ),
      );
    });
    widget.controller.init(this);
    if (!widget.controller.isMultipleSelection) {
      if (widget.controller.initSelectedItem.isNotEmpty &&
          widget.controller.initSelectedItem.first != null)
        itemSelected.value = widget.controller.initSelectedItem.first;
    } else {
      if (widget.controller.initSelectedItem.isNotEmpty) {
        itemsSelections.value =
            List.castFrom(widget.controller.initSelectedItem);
      }
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    final oldSelectedValues = oldWidget.controller.state.itemsSelections.value;
    final oldNotifierItems = oldWidget.controller.state.items;
    final oldSelectedValue = oldWidget.controller.state.itemSelected.value;
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      itemsSelections = ValueNotifier(widget.controller.isMultipleSelection
          ? List.from(oldSelectedValues)
          : []);
      items = List.from(oldNotifierItems);
      // widget.values.forEach((v) {
      //   items.add(
      //     ValueNotifier(
      //       CustomItem(
      //         data: v,
      //         checked: widget.controller.initSelectedItem.contains(v),
      //         isDisabled: false,
      //       ),
      //     ),
      //   );
      // });
      widget.controller.init(this);

      if (!widget.controller.isMultipleSelection) {
        itemSelected.value = oldSelectedValue;
      } else {
        itemsSelections.value =
            List.castFrom(widget.controller.initSelectedItem);
      }
    }
    final nValues = List.from(widget.values);
    nValues.removeWhere((value) => oldWidget.values.contains(value));
    if (nValues.isNotEmpty) {
      itemsSelections = ValueNotifier([]);
      itemSelected.value = null;
      items = List.from([]);
      widget.values.forEach((v) {
        items.add(
          ValueNotifier(
            CustomItem(
              data: v,
              checked: widget.controller.initSelectedItem.contains(v),
              isDisabled: widget.disableItems.contains(v),
            ),
          ),
        );
      });
    }
    final nDisabledItems = List.from(widget.disableItems);
    nDisabledItems.removeWhere(
        (disabledItem) => oldWidget.disableItems.contains(disabledItem));
    if (nDisabledItems.isNotEmpty) {
      enabledItemsByValues(List.from(widget.values));
      disabledItemsByValues(List.from(widget.disableItems));
    }
  }

  @override
  void dispose() {
    streamOneValue.close();
    streamListValues.close();
    super.dispose();
  }

  @override
  void enabledItemsByValues(List<K> itemsValues) {
    assert(
        itemsValues
            .takeWhile((e) => !items
                .map((e) => e.value)
                .map((e) => e.data)
                .toList()
                .contains(e))
            .isEmpty,
        "you cannot enable items where they values doesn't exist");
    _itemEnableDisable(false, itemsValues);
  }

  @override
  void disabledItemsByValues(List<K> itemsValues) {
    assert(
        itemsValues
            .takeWhile((e) => !items
                .map((e) => e.value)
                .map((e) => e.data)
                .toList()
                .contains(e))
            .isEmpty,
        "you cannot disable items where they values doesn't exist");
    _itemEnableDisable(true, itemsValues);
  }

  void _itemEnableDisable(bool enable, List<K> values) {
    items
        .where((element) => values.contains(element.value.data))
        .toList()
        .asMap()
        .forEach((key, notifierItem) {
      var index = items.indexOf(notifierItem);
      CustomItem item = CustomItem(
          isDisabled: notifierItem.value.isDisabled,
          checked: notifierItem.value.checked,
          data: notifierItem.value.data);
      item.isDisabled = enable;
      items[index].value = item as CustomItem<K>;
    });
  }

  void reset();
}
