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
  void enabledItemsByValues(List<K> itemsValues) {}

  @override
  void disabledItemsByValues(List<K> itemsValues) {}
}
