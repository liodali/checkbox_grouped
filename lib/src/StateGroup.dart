import 'package:flutter/material.dart';

import 'item.dart';

abstract class GroupInterface {
  void enabledItemsByValues(List<dynamic> itemsValues);

  void enabledItemsByTitles(List<String> items);

  void disabledItemsByTitles(List<String> items);

  void disabledItemsByValues(List<dynamic> itemsValues);

  /// recuperate value selection if is not multi selection
  /// recuperate list of selection value if is multi selection
  dynamic selection();

  void changeSelection(int index, dynamic value);
}

abstract class StateGroup<K, T extends StatefulWidget> extends State<T>
    with GroupInterface {
  ValueNotifier<K> selectedValue;
  ValueNotifier<List<K>> selectionsValue = ValueNotifier([]);
  List<ValueNotifier<Item>> notifierItems = [];
  List<Item> items = [];
  ValueNotifier<bool> valueTitle = ValueNotifier(false);
  List<K> values = [];

  @protected
  void init({
    @required List<K> values,
    bool checkFirstElement = false,
    List<K> preSelection,
    bool multiSelection = false,
    @required List<String> itemsTitle,
    List<String> disableItems,
  }) {
    this.values = values;
    selectedValue = ValueNotifier(null);
    if (preSelection != null && preSelection.isNotEmpty) {
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
      if (multiSelection && preSelection != null && preSelection.length > 0) {
        valueTitle.value = null;
        if (preSelection.contains(values[key])) {
          checked = true;
          selectionsValue.value = List.from(selectionsValue.value)
            ..add(values[key]);
        }
      } else {
        if (!multiSelection &&
            !checkFirstElement &&
            preSelection != null &&
            preSelection.length == 1) {
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

  /// [items]: A list of values that you want to be disabled
  /// disable items that match with list of strings
  @override
  void disabledItemsByValues(List<dynamic> itemsValues) {
    var items = _recuperateTitleFromValues(itemsValues.cast<K>());
    _itemStatus(items, true);
  }

  /// [items]: A list of strings that describes titles
  /// disable items that match with list of strings
  @override
  void disabledItemsByTitles(List<String> items) {
    _itemStatus(items, true);
  }

  /// [items]: A list of values
  /// enable items that match with list of dynamics
  @override
  void enabledItemsByValues(List<dynamic> itemsValues) {
    var items = _recuperateTitleFromValues(itemsValues.cast<K>());
    _itemStatus(items, false);
  }

  /// [items]: A list of strings that describes titles
  /// enable items that match with list of strings
  @override
  void enabledItemsByTitles(List<String> items) {
    _itemStatus(items, false);
  }

  List<String> _recuperateTitleFromValues(List<K> itemsValues) {
    return itemsValues.map((e) {
      var indexOfItem = values.indexOf(e);
      return items[indexOfItem].title;
    }).toList();
  }

  void _itemStatus(List<String> items, bool isDisabled) {
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
