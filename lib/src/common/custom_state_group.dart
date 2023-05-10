import 'dart:async';

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

abstract class CustomStateGroup<K, T extends StatefulWidget> extends State<T>
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
