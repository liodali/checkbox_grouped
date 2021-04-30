import 'package:checkbox_grouped/src/controller/base_controller.dart';

import '../widgets/list_grouped_checkbox.dart';

/// ListGroupController to manage list of  grouped checkbox/chips/switch
/// [isMultipleSelectionPerGroup] : (List<bool>) enable multiple selection  in each grouped checkbox.
/// [initSelectedValues] : (List) A Initialize list of values on each group of checkbox that will be selected in group.

class ListGroupController implements BaseController{
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
  void disabledItemsByTitles(List<String> items) {
    // TODO: implement disabledItemsByTitles
  }

  @override
  void disabledItemsByValues(List itemsValues) {
    // TODO: implement disabledItemsByValues
  }

  @override
  void enabledItemsByTitles(List<String> items) {
    // TODO: implement enabledItemsByTitles
  }

  @override
  void enabledItemsByValues(List itemsValues) {
    // TODO: implement enabledItemsByValues
  }


}
