import '../common/custom_state_group.dart';

typedef CustomListener = void Function(dynamic);

/// CustomStateGroup to manage custom selection grouped
///
/// [isMultipleSelection] : (bool) enable multiple selection  in grouped checkbox (default:false).
///
/// [initSelectedItem] : (List) A Initialize list of values that will be selected in group.
class CustomGroupController {
  CustomStateGroup? _customStateGroup;

  final List<dynamic> initSelectedItem;
  final bool isMultipleSelection;
  final List<CustomListener> listeners = [];

  dynamic get selectedItem => _customStateGroup!.selection();

  /// add listener : to get  data changed directly
  void listen(CustomListener listener) {
    if (_customStateGroup == null) listeners.add(listener);
    else{
      _addListener(listener);
    }
  }

  CustomGroupController({
    this.isMultipleSelection = false,
    dynamic initSelectedItem,
  })  : assert(!(initSelectedItem is List), "shouldn't be a List"),
        this.initSelectedItem = [initSelectedItem];

  CustomGroupController.multiple({
    this.isMultipleSelection = true,
    this.initSelectedItem = const [],
  });

  void init(CustomStateGroup stateGroup) {
    this._customStateGroup = stateGroup;
    listeners.forEach((element) {
      _addListener(element);
    });
  }

  void _addListener(CustomListener element) {
     if (!isMultipleSelection) {
      _customStateGroup!.selectedListen(element);
    } else {
      _customStateGroup!.selectionsListen(element);
    }
  }

  /// enabledItems : to make items enabled
  ///
  /// [items] : (list) list of items that will be enabled
  void enabledItems(List<dynamic> items) =>
      _customStateGroup!.enabledItemsByValues(items);

  /// enabledItems : to disabled specific  items by they values
  ///
  /// [items] : (list) list of items that will be disabled
  void disabledItems(List<dynamic> items) =>
      _customStateGroup!.disabledItemsByValues(items);
}
