import 'dart:collection';

import '../common/custom_state_group.dart';

typedef CustomListener = void Function(dynamic);

class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener);

  final CustomListener listener;
}

/// CustomStateGroup to manage custom selection grouped
///
/// [isMultipleSelection] : (bool) enable multiple selection  in grouped checkbox (default:false).
///
/// [initSelectedItem] : (List) A Initialize list of values that will be selected in group.
class CustomGroupController {
  late CustomStateGroup _customStateGroup;

  final List<dynamic> initSelectedItem;
  final bool isMultipleSelection;
  final List<CustomListener> listeners = [];

  dynamic get selectedItem => _customStateGroup.selection();

  void listen(CustomListener listener) {
    listeners.add(listener);
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
      if (!isMultipleSelection) {
        _customStateGroup.selectedListen(element);
      } else {
        _customStateGroup.selectionsListen(element);
      }
    });
  }

  void enabledItems(List<dynamic> items) =>
      _customStateGroup.enabledItemsByValues(items);

  void disabledItems(List<dynamic> items) =>
      _customStateGroup.disabledItemsByValues(items);
}
