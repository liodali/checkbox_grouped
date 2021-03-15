import 'package:flutter/material.dart';

import 'item.dart';

/// class [GroupInterface] : abstract class that contain basic function of StateGroup
abstract class _GroupInterface {
  ///[itemsValues] : values that you want to enabled
  void enabledItemsByValues(List<dynamic> itemsValues);

  ///[items] : (List) list of string that you want to enabled
  void enabledItemsByTitles(List<String> items);

  ///[items] : (List) list of string that you want to disabled
  void disabledItemsByTitles(List<String> items);

  ///[itemsValues] : (List) list of values that you want to enabled
  void disabledItemsByValues(List<dynamic> itemsValues);

  /// recuperate value selection if is not multi selection
  /// recuperate list of selection value if is multi selection
  dynamic selection();

  /// [index] : (int) index of item that his value wil change
  ///
  /// [value] : new value of item
  void changeSelection(int index, dynamic value);
}

abstract class StateGroup<K, T extends StatefulWidget> extends State<T>
    with _GroupInterface {
  late ValueNotifier<K?> selectedValue;
  ValueNotifier<List<K>> selectionsValue = ValueNotifier([]);
  List<ValueNotifier<Item>> notifierItems = [];
  List<Item> items = [];
  ValueNotifier<bool?> valueTitle = ValueNotifier(false);
  List<K> values = [];

  @protected
  void init({
    required List<K> values,
    bool checkFirstElement = false,
    List<K> preSelection = const [],
    bool multiSelection = false,
    required List<String> itemsTitle,
    List<String>? disableItems,
  }) {
    this.values = values;
    selectedValue = ValueNotifier(null);
    if (preSelection.isNotEmpty) {
      final cacheSelection = preSelection.toList();
      cacheSelection.removeWhere((e) => values.contains(e));
      if (cacheSelection.isNotEmpty) {
        assert(values.contains(cacheSelection),
            "you want to activate selection of value doesn't exist");
      }
    }
    itemsTitle.asMap().forEach((key, title) {
      bool checked = false;
      if (key == 0) {
        if (multiSelection && checkFirstElement) {
          selectionsValue.value = List.from(selectionsValue.value)
            ..add(values[0]);
          checked = true;
        }
      }
      if (multiSelection && preSelection.length > 0) {
        valueTitle.value = null;
        if (preSelection.contains(values[key])) {
          checked = true;
          selectionsValue.value = List.from(selectionsValue.value)
            ..add(values[key]);
        }
      } else {
        if (!multiSelection && !checkFirstElement && preSelection.length == 1) {
          valueTitle.value = null;
          if (preSelection.contains(values[key])) {
            checked = true;
            selectedValue.value = values[key];
          }
        }
      }
      Item item = Item(
          title: title,
          checked: checked,
          isDisabled: disableItems?.contains(title) ?? false);
      items.add(item);
      notifierItems.add(ValueNotifier(item));
    });

    if (checkFirstElement) {
      items[0].checked = true;
      notifierItems[0].value = Item(
        isDisabled: items[0].isDisabled,
        checked: items[0].checked,
        title: items[0].title,
      );
      //_previousActive = _items[0];
      selectedValue.value = values[0];
    }
  }

  /// disable items that match with list of strings
  /// [itemsValues] : A list of values that you want to be disabled
  @override
  void disabledItemsByValues(List<dynamic> itemsValues) {
    assert(
        (itemsValues.cast<K>()).takeWhile((c) => !values.contains(c)).isEmpty,
        "you cannot enable  items that doesn't exist");
    var items = _recuperateTitleFromValues(itemsValues.cast<K>());
    _itemStatus(items, true);
  }

  /// disable items that match with list of strings
  /// [items] : A list of strings that describes titles
  @override
  void disabledItemsByTitles(List<String> items) {
    assert(
        items
            .takeWhile((c) =>
                !notifierItems.map((e) => e.value.title).toList().contains(c))
            .isEmpty,
        "you want to disable items where they don't exist");
    _itemStatus(items, true);
  }

  /// enable items that match with list of dynamics
  /// [itemsValues] : A list of values
  @override
  void enabledItemsByValues(List<dynamic> itemsValues) {
    assert(
        (itemsValues.cast<K>()).takeWhile((c) => !values.contains(c)).isEmpty,
        "you cannot enable  items that doesn't exist");
    var items = _recuperateTitleFromValues(itemsValues.cast<K>());
    _itemStatus(items, false);
  }

  /// enable items that match with list of strings
  /// [items] : A list of strings that describes titles
  @override
  void enabledItemsByTitles(List<String> items) {
    assert(
        items
            .takeWhile((c) =>
                !notifierItems.map((e) => e.value.title).toList().contains(c))
            .isEmpty,
        "some of items doesn't exist");
    _itemStatus(items, false);
  }

  List<String?> _recuperateTitleFromValues(List<K> itemsValues) {
    return itemsValues.map((e) {
      var indexOfItem = values.indexOf(e);
      return items[indexOfItem].title;
    }).toList();
  }

  void _itemStatus(List<String?> items, bool isDisabled) {
    notifierItems
        .where((element) => items.contains(element.value.title))
        .toList()
        .asMap()
        .forEach((key, notifierItem) {
      var index = notifierItems.indexOf(notifierItem);
      Item item = Item(
          isDisabled: notifierItem.value.isDisabled,
          checked: notifierItem.value.checked,
          title: notifierItem.value.title);
      item.isDisabled = isDisabled;
      notifierItems[index].value = item;
    });
  }
}
