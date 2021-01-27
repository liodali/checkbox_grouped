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
}

abstract class StateGroup<K, T extends StatefulWidget> extends State<T>
    with GroupInterface {
  ValueNotifier<K> selectedValue;
  ValueNotifier<List<K>> selectionsValue = ValueNotifier([]);
  List<ValueNotifier<Item>> notifierItems = [];
  List<Item> items = [];
  ValueNotifier<bool> valueTitle = ValueNotifier(false);

  @protected
  void init({
    List<K> values,
    checkFirstElement,
    List<K> preSelection,
    bool multiSelection,
    List<String> itemsTitle,
    List<String> disableItems,
  }) {
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
}
