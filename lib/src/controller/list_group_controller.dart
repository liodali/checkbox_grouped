import 'package:checkbox_grouped/src/controller/base_controller.dart';

import '../widgets/list_grouped_checkbox.dart';

/// ListGroupController to manage list of  grouped checkbox/chips/switch
/// [isMultipleSelectionPerGroup] : (List<bool>) enable multiple selection  in each grouped checkbox.
/// [initSelectedValues] : (List) A Initialize list of values on each group of checkbox that will be selected in group.

class ListGroupController implements BaseListController {
  final List<bool> isMultipleSelectionPerGroup;
  final List<List<dynamic>> initSelectedValues;
  late ListGroupedCheckboxState _state;

  Future<List<dynamic>> get allSelectedItems async =>
      await _state.getAllValues();

  Future<List<dynamic>> selectedItemsByGroupIndex(int index) async =>
      await _state.getValuesByIndex(index);

  ListGroupController({
    this.initSelectedValues = const [],
    this.isMultipleSelectionPerGroup = const [],
  });

  void init(ListGroupedCheckboxState state) {
    this._state = state;
  }

  @override
  void disableAll(int index) {
    _state.listControllers[index].disableAll();
  }

  @override
  void disabledItemsByTitles(int index, List<String> items) {
    _state.listControllers[index].disabledItemsByTitles(items);
  }

  @override
  void disabledItemsByValues(int index, List itemsValues) {
    _state.listControllers[index].disabledItemsByValues(itemsValues);
  }

  @override
  void enableAll(int index) {
    _state.listControllers[index].enableAll();
  }

  @override
  void enabledItemsByTitles(int index, List<String> items) {
    _state.listControllers[index].enabledItemsByTitles(items);
  }

  @override
  void enabledItemsByValues(int index, List itemsValues) {
    _state.listControllers[index].enabledItemsByValues(itemsValues);
  }
}
