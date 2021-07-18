abstract class BaseController {
  /// enable  all items  in groupedCheckBox
  void enableAll();

  /// disable all items  in groupedCheckBox
  void disableAll();

  /// enable items by there values that was disabled in groupedCheckBox
  ///
  /// [itemsValues] : (List) values that will be enabled
  void enabledItemsByValues(List<dynamic> itemsValues);

  /// enable items by there Titles  in groupedCheckBox
  ///
  /// [items] : (List<String>) strings that will be enabled
  void enabledItemsByTitles(List<String> items);

  /// disabled the  items by there titles  in groupedCheckBox
  ///
  /// [items] : (List) strings that will be disabled
  void disabledItemsByTitles(List<String> items);

  /// disabled the items by there values  in groupedCheckBox
  ///
  /// [itemsValues] : (List) values that will be disabled
  void disabledItemsByValues(List<dynamic> itemsValues);

  /// select one item in group ( singeSelection/multiple selection)
  /// [value] : (dynamic) value of item that should selected
  void select<K>(K value);

  /// select all items in group
  void selectAll();

  /// select some/one item(s) in group
  /// [values] : (dynamic)  value(s) of item(s) that should selected
  void selectItems<k>(List<k> values);

  /// deselect some/one item(s) in group
  /// [values] : (dynamic) value(s) of item(s) that should deselected
  void deselectValues<k>(List<k> values);

  /// deselect all items in group
  void deselectAll();
}

abstract class BaseListController {
  /// enable  all items  in groupedCheckBox
  void enableAll(int index);

  /// disable all items  in groupedCheckBox
  void disableAll(int index);

  /// enable items by there values that was disabled in groupedCheckBox
  ///
  /// [itemsValues] : (List) values that will be enabled
  ///
  /// [indexGroup] : (int) index of the group that will be enabled
  void enabledItemsByValues(int indexGroup, List<dynamic> itemsValues);

  /// enable items by there Titles  in groupedCheckBox
  ///
  /// [items] : (List<String>) strings that will be enabled
  ///
  /// [indexGroup] : (int) index of the group that will be enabled
  void enabledItemsByTitles(int index, List<String> items);

  /// disabled the  items by there titles  in groupedCheckBox
  ///
  /// [indexGroup] : (List) strings that will be disabled
  void disabledItemsByTitles(int indexGroup, List<String> items);

  /// disabled the items by there values  in groupedCheckBox
  ///
  /// [itemsValues] : (List) values that will be disabled
  ///
  /// [indexGroup] : (List) strings that will be disabled
  void disabledItemsByValues(int indexGroup, List<dynamic> itemsValues);
}
