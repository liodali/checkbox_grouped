import '../common/custom_state_group.dart';
/// CustomStateGroup to manage custom  grouped checkbox/chips/switch
/// [isMultipleSelection] : (bool) enable multiple selection  in grouped checkbox (default:false).
/// [initSelectedItem] : (List) A Initialize list of values that will be selected in group.
class CustomGroupController {
  late CustomStateGroup _customStateGroup;

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
