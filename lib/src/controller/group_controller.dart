import '../common/state_group.dart';
import '../common/utilities.dart';
import 'base_controller.dart';

/// GroupController to manage simple grouped checkbox/chips/switch
/// [isMultipleSelection] : (bool) enable multiple selection  in grouped checkbox (default:false).
/// [initSelectedItem] : (List) A Initialize list of values that will be selected in group.
class GroupController implements BaseController {
  dynamic initSelectedItem;

  final bool isMultipleSelection;

  dynamic get selectedItem => _widgetState.selection();

  late StateGroup _widgetState;
  final List<CustomListener> _listeners = [];

  GroupController({
    this.initSelectedItem = const [],
    this.isMultipleSelection = false,
  }) : assert(!(isMultipleSelection == false && initSelectedItem.length > 1),
            "you cannot select multiple item when multipleSelection is false");

  void init(StateGroup state) {
    this._widgetState = state;
    _listeners.forEach((element) {
      _addListener(element);
    });
  }

  /// add listener : to get  data changed directly
  void listen(void Function(dynamic) listener) {
    try {
      _addListener(listener);
    } catch (LateInitializationError) {
      _listeners.add(listener);
    }
  }

  void _addListener(CustomListener element) {
    if (!isMultipleSelection) {
      _widgetState.selectedListen(element);
    } else {
      _widgetState.selectionsListen(element);
    }
  }

  @override
  void enabledItemsByValues(List<dynamic> itemsValues) =>
      _widgetState.enabledItemsByValues(itemsValues);

  @override
  void enabledItemsByTitles(List<String> items) =>
      _widgetState.enabledItemsByTitles(items);

  @override
  void disabledItemsByTitles(List<String> items) =>
      _widgetState.disabledItemsByTitles(items);

  @override
  void disabledItemsByValues(List<dynamic> itemsValues) =>
      _widgetState.disabledItemsByValues(itemsValues);
}
