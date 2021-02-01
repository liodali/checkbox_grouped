import 'package:flutter/material.dart';

import 'item.dart';

abstract class CustomGroupInterface<T> {
  void enabledItemsByValues(List<T> itemsValues);

  void disabledItemsByValues(List<T> itemsValues);

  /// recuperate value selection if is not multi selection
  /// recuperate list of selection value if is multi selection
  dynamic selection();

  void changeSelection(int index, dynamic value);
}

abstract class CustomStateGroup<K, T extends StatefulWidget> extends State<T>
    with CustomGroupInterface<K> {
  ValueNotifier<K> itemSelected = ValueNotifier(null);

  ValueNotifier<List<K>> itemsSelections = ValueNotifier([]);

  List<ValueNotifier<CustomItem<K>>> items;

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
      items[index].value = item;
    });
  }
}
