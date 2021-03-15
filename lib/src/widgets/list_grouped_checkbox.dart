import 'package:flutter/material.dart';

import '../controller/group_controller.dart';
import '../controller/list_group_controller.dart';
import 'simple_grouped_checkbox.dart';

typedef onGroupChanged<T> = void Function(dynamic selected);

/// display  simple groupedCheckbox
/// [controller] :  (required) List Group Controller to recuperate selection
/// [titles] :  (required) A list of strings that describes each checkbox group
/// [values] : list of values in each group
/// [onSelectedGroupChanged] : callback to get selected items,it fred when the user selected items or deselect items
/// [subTitles] : A list of strings that describes second Text
/// [groupTitles] : Text Widget that describe Title of group checkbox
/// [disabledValues] : specifies which item should be disabled
class ListGroupedCheckbox<T> extends StatefulWidget {
  final ListGroupController controller;
  final List<List<T>> values;
  final List<List<String>> titles;
  final List<String> groupTitles;
  final List<String> subTitles;
  final List<List<T>> disabledValues;
  final onGroupChanged<T>? onSelectedGroupChanged;

  ListGroupedCheckbox({
    required this.controller,
    required this.titles,
    required this.groupTitles,
    required this.values,
    this.subTitles = const [],
    this.onSelectedGroupChanged,
    this.disabledValues = const [],
    Key? key,
  })  : assert(values.length == titles.length),
        assert(groupTitles.length == titles.length),
        assert(controller.isMultipleSelectionPerGroup.isEmpty ||
            controller.isMultipleSelectionPerGroup.length == titles.length),
        super(key: key);

  static ListGroupedCheckboxState? of<T>(BuildContext context,
      {bool nullOk = false}) {
    final ListGroupedCheckboxState<T>? result =
        context.findAncestorStateOfType<ListGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'ListGroupedCheckboxState.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No ListGroupedCheckboxState ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  ListGroupedCheckboxState<T> createState() => ListGroupedCheckboxState<T>();
}

class ListGroupedCheckboxState<T> extends State<ListGroupedCheckbox> {
  int len = 0;
  List<GroupController> listControllers = [];

  @override
  void initState() {
    super.initState();
    len = widget.values.length;
    widget.controller.init(this);
    listControllers.addAll(List.generate(
        widget.values.length,
        (index) => GroupController(
              initSelectedItem: widget.controller.initSelectedValues.isNotEmpty
                  ? widget.controller.initSelectedValues[index]
                  : [],
              isMultipleSelection:
                  widget.controller.isMultipleSelectionPerGroup.isNotEmpty
                      ? widget.controller.isMultipleSelectionPerGroup[index]
                      : false,
            )));
  }

  Future<List<T>> getAllValues() async {
    List<T> resultList = List.empty(growable: true);
    var values = listControllers.map((e) => e.selectedItem).where((v) {
      if (v != null) {
        if (v is List && v.isNotEmpty) {
          return true;
        } else if (v is T) {
          return true;
        }
      }
      return false;
    }).toList();
    for (var v in values) {
      if (v is List)
        resultList.addAll(v.cast<T>());
      else {
        if (v != null) resultList.add(v);
      }
    }

    return resultList;
  }

  Future<List<T>> getValuesByIndex(int index) async {
    assert(index < len);
    List<T> resultList = List.empty();
    resultList.addAll(listControllers[index].selectedItem);
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return SimpleGroupedCheckbox<T>(
          controller: listControllers[index],
          itemsTitle: widget.titles[index],
          values: widget.values[index] as List<T>,
          disableItems: widget.disabledValues.isNotEmpty
              ? widget.disabledValues[index] as List<String>
              :  [],
          groupTitle: widget.groupTitles[index],
          onItemSelected: widget.onSelectedGroupChanged != null
              ? (selection) async {
                  final list = await getAllValues();
                  widget.onSelectedGroupChanged!(list);
                }
              : null,
        );
      },
      itemCount: len,
    );
  }
}
