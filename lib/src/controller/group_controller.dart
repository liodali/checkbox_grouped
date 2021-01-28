import '../StateGroup.dart';

class GroupController {
  dynamic initSelectedItem;

  final bool isMultipleSelection;

  dynamic get selectedItem => _widgetState.selection();

  StateGroup _widgetState;

  GroupController({
    this.initSelectedItem = const [],
    this.isMultipleSelection = false,
  }) : assert(!(isMultipleSelection == false && initSelectedItem.length > 1),
            "you cannot select multiple item when multipleSelection is false");

  void enabledItemsByValues(List<dynamic> itemsValues) =>
      _widgetState.enabledItemsByValues(itemsValues);

  void enabledItemsByTitles(List<String> items) =>
      _widgetState.enabledItemsByTitles(items);

  void disabledItemsByTitles(List<String> items) =>
      _widgetState.disabledItemsByTitles(items);

  void disabledItemsByValues(List<dynamic> itemsValues) =>
      _widgetState.disabledItemsByValues(itemsValues);

  void init(StateGroup state) {
    this._widgetState = state;
  }
}
