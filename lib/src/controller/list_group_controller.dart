import '../list_grouped_checkbox.dart';

class ListGroupController {
  final List<bool> isMultipleSelectionPerGroup;
  final List<List<dynamic>> initSelectedValues;
  ListGroupedCheckboxState _state;

  Future<List<dynamic>> get allSelectedItems async =>
      await _state.getAllValues();

  Future<List<dynamic>>  selectedItemsByGroupIndex(int index) async =>
      await _state.getValuesByIndex(index);

  ListGroupController({
    this.initSelectedValues = const [],
    this.isMultipleSelectionPerGroup = const [],
  });

  void init(ListGroupedCheckboxState state) {
    this._state = state;
  }
}
