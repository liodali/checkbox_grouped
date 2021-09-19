import 'package:flutter/material.dart';

import '../../checkbox_grouped.dart';
import '../common/utilities.dart';
import '../controller/list_custom_group_controller.dart';

/// display  simple groupedCheckbox
/// [controller]              :  (required) List Group Controller to recuperate selection
///
/// [titles]                  :  (required) A list of strings that describes each checkbox group
///
/// [values]                  : list of values in each group
///
/// [onSelectedGroupChanged]  : callback to get selected items,it fred when the user selected items or deselect items
///
/// [subTitles]               : A list of strings that describes second Text
///
/// [groupTitles]             : Text Widget that describe Title of group checkbox
///
/// [disabledValues]          : specifies which item should be disabled
///
/// [titleGroupedTextStyle]   : (TextStyle) style title text of each group
///
/// [titleGroupedAlignment]   : (Alignment) Alignment of  title text of each group
///
/// [mapItemGroupedType]      : (Map) to define type each item in list (chip,switch,default)
class ListCustomGroupedCheckbox extends StatefulWidget {
  final ListCustomGroupController controller;
  final bool isScrollable;
  final List<List<Widget>> values;
  final List<String> groupTitles;
  final TextStyle? titleGroupedTextStyle;
  final Alignment titleGroupedAlignment;
  final onGroupChanged? onSelectedGroupChanged;

  ListCustomGroupedCheckbox({
    required this.controller,
    required this.groupTitles,
    required this.values,
    this.isScrollable = true,
    this.titleGroupedTextStyle,
    this.titleGroupedAlignment = Alignment.centerLeft,
    this.onSelectedGroupChanged,
    Key? key,
  })  : assert(controller.isMultipleSelectionPerGroup.isEmpty),
        super(key: key);

  static ListCustomGroupedCheckboxState? of(BuildContext context,
      {bool nullOk = false}) {
    final ListCustomGroupedCheckboxState? result =
        context.findAncestorStateOfType<ListCustomGroupedCheckboxState>();
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
  ListCustomGroupedCheckboxState createState() =>
      ListCustomGroupedCheckboxState();
}

class ListCustomGroupedCheckboxState extends State<ListCustomGroupedCheckbox> {
  int len = 0;
  List<CustomGroupController> listControllers = [];

  @override
  void initState() {
    super.initState();
    len = widget.values.length;
    widget.controller.init(this);
    listControllers.addAll(
      List.generate(
        widget.values.length,
        (index) => CustomGroupController(
          initSelectedItem: widget.controller.initSelectedValues.isNotEmpty
              ? widget.controller.initSelectedValues[index]
              : [],
          isMultipleSelection:
              widget.controller.isMultipleSelectionPerGroup.isNotEmpty
                  ? widget.controller.isMultipleSelectionPerGroup[index]
                  : false,
        ),
      ),
    );
  }

  Future<List> getAllValues() async {
    List resultList = List.empty(growable: true);
    var values = listControllers.map((e) => e.selectedItem).where((v) {
      if (v != null) {
        if (v is List && v.isNotEmpty) {
          return true;
        } else {
          return true;
        }
      }
      return false;
    }).toList();
    for (var v in values) {
      if (v is List)
        resultList.addAll(v);
      else {
        if (v != null) resultList.add(v);
      }
    }

    return resultList;
  }

  Future<List> getValuesByIndex(int index) async {
    assert(index < len);
    List resultList = List.empty();
    resultList.addAll(listControllers[index].selectedItem);
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      physics: widget.isScrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Text("");
      },
      itemCount: len,
    );
  }
}
