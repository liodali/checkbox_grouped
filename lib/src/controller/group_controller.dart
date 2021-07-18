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

  @override
  void disableAll() {
    _widgetState.disableAll();
  }

  @override
  void enableAll() {
    _widgetState.enableAll();
  }

  @override
  void select<k>(k value) {
    assert(!(value is List),
        "you should use `selectItems` instead of select is only for one value");
    assert(_widgetState.values.contains(value),
        "you cannot select  item that doesn't exist");

    switch (isMultipleSelection) {
      case true:
        _widgetState.selectValues(List.filled(1, value) as List<k>);
        break;
      case false:
        final index = _widgetState.values.indexOf(value);
        _widgetState.notifierItems[index].value =
            _widgetState.notifierItems[index].value.copy(
          checked: true,
        );
        if(_widgetState.selectedValue.value != null) {
          final indexOld =
          _widgetState.values.indexOf(_widgetState.selectedValue.value);
          if (indexOld != -1) {
            _widgetState.notifierItems[indexOld].value =
                _widgetState.notifierItems[indexOld].value.copy(
                  checked: false,
                );
          }
        }
        _widgetState.selectedValue.value = value;
        break;
    }
  }

  @override
  void selectAll() {
    assert(
      isMultipleSelection,
      "you cannot use selectAll in single selection group checkbox",
    );
    _widgetState.selectValues(_widgetState.values);
  }

  @override
  void selectItems<k>(List<k> values) {
    assert(isMultipleSelection,
        "you cannot select multiple items in single selection group");
    if (values.length == 1) {
      select(values.first);
    }
    _widgetState.selectValues(values);
  }

  @override
  void deselectValues<k>(List<k> values) {
    assert(isMultipleSelection,
        "you cannot deselect multiple items in single selection group");
    _widgetState.deselectValues(values);
  }

  @override
  void deselectAll() {
    assert(isMultipleSelection,
        "you cannot deselect all items in single selection group");
    _widgetState.deselectValues(_widgetState.values);
  }
}
