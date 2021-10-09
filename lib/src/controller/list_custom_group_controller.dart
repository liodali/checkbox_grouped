import '../widgets/list_custom_grouped_checkbox.dart';

/// ListGroupController to manage list of  grouped checkbox/chips/switch
/// [isMultipleSelectionPerGroup] : (List<bool>) enable multiple selection  in each grouped checkbox.
/// [initSelectedValues] : (List) A Initialize list of values on each group of checkbox that will be selected in group.

class ListCustomGroupController {
  final List<bool> isMultipleSelectionPerGroup;
  final Map<int, List<dynamic>> initSelectedValuesByGroup;
  late ListCustomGroupedCheckboxState _state;

  Future<List<dynamic>> get allSelectedItems async =>
      await _state.getAllValues();

  Future<Map<int, dynamic>> get mapSelectedItems async =>
      await _state.getMapValues();

  Future<List<dynamic>> selectedItemsByGroupIndex(int index) async =>
      await _state.getListValuesByIndex(index);

  ListCustomGroupController({
    this.initSelectedValuesByGroup = const {},
    this.isMultipleSelectionPerGroup = const [],
  });
}

extension initialization on ListCustomGroupController {
  void init(ListCustomGroupedCheckboxState state) {
    this._state = state;
  }
}
