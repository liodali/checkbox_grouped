import '../common/custom_state_group.dart';

class CustomGroupController {
  CustomStateGroup _customStateGroup;

  final List<dynamic> initSelectedItem;
  final bool isMultipleSelection;

  dynamic get selectedItem => _customStateGroup.selection();

  CustomGroupController({
    this.isMultipleSelection = false,
    this.initSelectedItem = const [],
  });

  void init(CustomStateGroup stateGroup) {
    this._customStateGroup = stateGroup;
  }
  void enabledItems(List<dynamic> items) =>
      _customStateGroup.enabledItemsByValues(items);

  void disabledItems(List<dynamic> items) =>
      _customStateGroup.disabledItemsByValues(items);
}
