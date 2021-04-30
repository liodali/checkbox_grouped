abstract class BaseController {

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
