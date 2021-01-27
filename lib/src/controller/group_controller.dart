import '../StateGroup.dart';

class GroupController {
  dynamic initSelectedItem;

  final bool isMultipleSelection;

  dynamic get selectedItem => _widgetState.selection();

  StateGroup _widgetState;

  GroupController({
    this.initSelectedItem,
    this.isMultipleSelection = false,
  });

  void init(StateGroup state) {
    this._widgetState = state;
  }
}
