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
